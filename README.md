# html_template

A server-side HTML templating engine. It extends the normal Dart String Interpolation feature with conditions and loops.

It has the following properties:

- It uses the standard String interpolation feature of Dart (`$myVariable`) to **keep autocompletion and static analysis for
  every variable in the template**.
- Based on the Angular syntax (*if, *for, *switch, [class.my-class]...) (without the ng prefix)
- Based on code generation (it depends on the build/build_runner package)


## Examples

#### Simple conditions
Create a private function with a `@template` attribute:

```dart
part 'my_template.g.dart';

@template
_productTemplate(Product product, {bool withSeparator = false}) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <a [class.new]="${product.isNew}">$product</a>
  <hr *if="$withSeparator">
  ''';
}
```

- The `*if` attribute on the html tag allows to conditionally output a node. The condition is some Dart code within 
  an interpolation (ie. `${condition == xx}` or simply `$condition`). It can be any Dart expression.
- `[class.active]="$condition"` output a `class="active"` attribute if the condition specified is true.
- `${variable}` or `$variable` are escaped by default.

This will generate a public `productTemplate` function with the same arguments. The generated code will look like:
```dart
// Generated
TrustedHtml productTemplate(Product product, {bool withSeparator = false}) {
  var output = StringBuffer();
  if (product.icon != null) {
    output.writeln('<img src="${escapeAttribute(product.icon)}">');
  }
  output.writeln('<a class="${entry.isNew ? "new" : ""}">${escapeHtml(product)}</a>');
  if (withSeparator) {
    output.writeln('<hr>');
  }
  return TrustedHtml(output.toString());
}
```

Note: to generate the code, you will have to run one of the commands:
- `webdev serve`
- `pub run build_runner watch`

You will then call the public method to generate your html in the server.
```dart
main() {
  router.get('/products/<id>', (request) async {
    var product = await database.findProduct(params(request, 'id'));

    // Imagine a "masterTemplate" that output the <head> tag
    var html = masterTemplate(body: productTemplate(product));

    return Response.ok(html, headers: {'content-type': 'text/html'});
  });
}
```

#### Loop
To repeat an html element, you use an attribute `*for="$item in $iterable"`.  

```dart
part 'my_template.g.dart';

@template
_myTemplateFunction(List<MenuItem> menu) {
  MenuEntry entry;
  '''
  <ul>
    <li *for="$entry in $menu">${entry.title}</li>
  </ul>
  ''';
}
```

Note: You have to define the item variable outside of the string literal. (this is a bit unfortunate but string literals 
dont allow to define variable inside them).

#### Normal Dart code
You can use normal Dart code around the string literals to do more complex thing in your template.
You can have has many string literal as you want and put them in control flow.

```dart
@template
_myTemplate({bool showMenu}) async {
  '<h1>Title</h1>';

  if (!showMenu) {
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

#### Nested template
Include an other template in your template by calling it in a string interpolation:

```dart
@template
_myTemplate() {
  '''
  <h1>Images</h1>
  ${imageTemplate('landscape.png')}
  ''';
}

@template
_imageTemplate(String url) {
  '<img src="$url">';
}
```

Note: you must call the "generated" function, not the original.

#### Component style
The template function could be inside a class the generated code will be slightly different to receive the class as an
argument.

#### Other features
- Conditional attribute with `<input [disabled]=$condition>`
- Multi classes: `<span [classes]="$anIterableOfClasses">` or `<span [classes]="${'a-class': condition}">`
- Use `<text *if="..">` tag if you want to output some text without the html element wrapper.
