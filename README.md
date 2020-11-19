# html_template

A server-side HTML template engine in Dart.

![intellij-screenshot](https://raw.githubusercontent.com/xvrh/html_template/master/doc/screenshot.png)

### Features

- Auto-completion and static analysis in the template.
- Classical control-flow constructs: `*if`, `*for`, `*switch`
- Conditionally add CSS classes (`[class.my-class]="$condition"`) and HTML attributes (`[disabled]="$condition"`)
- Automatically escapes the variables
- Syntax highlighting (in IntelliJ-based IDE)

### Example

#### Write the template code

Declare a private `void` function tagged with a `@template` attribute:

```dart
import 'package:html_template/html_template.dart';

part 'main.g.dart';

@template
void _productTemplate(Product product) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <h1 [class.new]="${product.isNew}">$product</h1>
  ''';
}

@template
void _pageTemplate(Product product, {List<String> scripts}) {
  String script;
  '''
<!doctype html>
<html language="${Language.current}">
  <head>
    <title>${product.name} - My site</title>
    <script *for="$script in $scripts" src="$script" async></script>
  </head>
  <body>
    ${productTemplate(product)}
  </body>
</html>
  ''';
}
```

#### Generate the code

- `pub run build_runner watch --delete-conflicting-outputs`

This generates a public function with the same arguments as the original. The generated code looks like:
```dart
// Generated
TrustedHtml productTemplate(Product product) {
  var $ = StringBuffer();

  $.write('  ');
  if (product.icon != null) {
    $.write('<img src="${TrustedHtml.escape.attribute(product.icon)}">');
  }
  $.write('\n  ');
  $.write('<h1${template.classAttribute({'new': product.isNew})}>');
  $.write('${TrustedHtml.escape(product)}');
  $.write('</h1>');
  $.write('\n  ');

  return TrustedHtml($.toString());
}
//...
```
See the real generated code [here](example/lib/main.g.dart)

#### Use the template

Call the generated public methods to build the HTML page from your data.
```dart
void main() {
  router.get('/products/<id>', (request) async {
    var product = await database.findProduct(params(request, 'id'));

    // Create the html for the response from the Product of your database
    var html = pageTemplate(product);

    return Response.ok(html, headers: {'content-type': 'text/html'});
  });
}
```

### Conditions
```dart
@template
void _conditionExample({bool someCondition}) async {
  '''  
  <!-- Conditionally include the <h2> tag -->
  <h2 *if="$someCondition">Condition on a tag</h2>
  
  <!-- Include the 'disabled' attribute if the condition is true -->
  <input [disabled]="$someCondition"/>
  
  <!-- Add 'my-class' CSS class if the condition is true -->
  <input [class.my-class]="$someCondition">
  
    <!-- Use any Dart expression for the condition -->
  <hr *if="${(await fetchData()).isEmpty}"/>
  ''';
}
```

### Loop
To repeat an HTML element, use the attribute: `*for="$item in $iterable"`.  

```dart
@template
void _simpleLoop(List<MenuItem> menu) {
  MenuItem item;
  '''
  <ul>
    <li *for="$item in $menu">
      ${item.title}
    </li>
  </ul>
  ''';
}
```

Notice that we have to define the `item` variable outside of the string literal.   
This is a bit unfortunate but string literals don't allow to define a variable inside them).

You can also write a loop with several string literals:
```dart
@template
void _alternativeLoop(List<MenuItem> menu) {
  '<ul>';
  for (var item in menu) {
    '<li>${item.title}</li>';
  }
  '</ul>';
}
```

### Switch
```dart
@template
void _switchExample(Season season) {
  '''
<div *switch="$season">
  <span *case="${Season.summer}">Hot</span>
  <span *case="${Season.winter}">Cold</span>
  <div *default>Pleasant</div>
</div>
  ''';
}
```

### CSS Classes
```dart
@template
void _cssClassesExample(List<Data> data, {bool showMenu}) {
  // Add classes based on condition
  '<li [class.active]="$showMenu" [class.enabled]="${data.isNotEmpty}">Actif</li>';

  // We can pass a Map<String, bool> to the [classes] attribute
  var myClasses = {'enabled': showMenu};
  '<a type="text" [classes]="$myClasses"></a>';
}
```

### Dart code
You can use normal Dart code around the string literals to do complex things in your template.
You can have has many strings literal as you want.

```dart
@template
void _myTemplate() async {
  '<h1>Title</h1>';

  var myPage = buildPage();
  if (!myPage.hasData) {
    '<h2>Sub title</h2>';
  } else {
    var data = await fetchData();
    Data item;
    '''
    <ul>
      <li *for="$item in $data">$item</li>
    </ul>
    ''';
  }
  '<footer>Footer</footer>';
}
```

### Nested template & master layout
Include another template by calling the generated function in a string interpolation:

```dart
@template
void _myTemplate() {
  '''
  <h1>Images</h1>
  ${img('landscape.png')}
  ''';
}

@template
void _img(String url) {
  '<img src="$url">';
}
```

### Others
Use `<text *if="..">xx</text>` tag if you want to output some text without the html element wrapper.
