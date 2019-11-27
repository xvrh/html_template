# html_template

A server-side HTML templating engine in Dart. It extends the normal String Interpolation feature with conditions and loops.

It has the following properties:

- It uses the standard String interpolation feature of Dart (`$myVariable`) to keep **auto-completion and static analysis for
  every variable in the template**.
- Based on the Angular syntax (`*if`, `*for`, `*switch`, `[class.my-class]`...) (without the `ng` prefix)
- Based on code generation (it depends on the build/build_runner package)


## Examples

#### Full basic example
Create a private `void` function tagged with a `@template` attribute:

```dart
@template
void _productTemplate(Product product) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <h1 [class.new]="${product.isNew}">$product</h1>
  ''';
}

@template
void _masterTemplate({@required TrustedHtml body, String title, List<String> scripts}) {
  String script;
  '''
<!doctype html>
<html language="${Language.current}">
  <head>
    <title>$title - My site</title>
    <script *for="$script in $scripts" async></script>
  </head>
  <body>
    $body
  </body>
</html>
  ''';
}
```

- The `*if` attribute on a html element allows to conditionally output a node. The condition is some Dart code within 
  an interpolation (ie. `${condition == xx}` or simply `$condition`). It can be any Dart expression.
- `[class.active]="$condition"` output a `class="active"` attribute if the condition specified is true.
- `${variable}` or `$variable` are [escaped](https://api.dartlang.org/stable/dart-convert/HtmlEscape-class.html) by 
  default and Null values are converted to empty strings.

To generate the code, you will have to run one of the command:
- `pub run build_runner watch`
- `webdev serve`

This generates two public functions with the same arguments. The generated code looks like:
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

TrustedHtml masterTemplate({@required TrustedHtml body, String title}) {
  var output = StringBuffer();
  output.writeln('<!doctype html>');
  output.writeln('<html language="${escapeAttribute(Language.current)}">');
  // ...
}
```
See the real generated code [here](example/main.g.dart)

Call the public methods to create the HTML page from your data.
```dart
main() {
  router.get('/products/<id>', (request) async {
    var product = await database.findProduct(params(request, 'id'));

    // Create the html for the response from the Product of your database
    var html = masterTemplate(body: productTemplate(product), title: product.name);

    return Response.ok(html, headers: {'content-type': 'text/html'});
  });
}
```

#### Loop
To repeat an html element, use the attribute `*for` attribute like `*for="$item in $iterable"`.  

```dart
@template
_myTemplate(List<MenuItem> menu) {
  MenuEntry entry;
  '''
  <ul>
    <li *for="$entry in $menu">${entry.title}</li>
  </ul>
  ''';
}
```

You have to define the item variable outside of the string literal. (this is a bit unfortunate but string literals 
dont allow to define variable inside them).

Note: The iterable is allowed to be `null`.

#### Switch
TODO

#### Attributes
TODO

- Conditional attribute with `<input [disabled]=$condition>`
- Multi classes: `<span [classes]="$anIterableOfClasses">` or `<span [classes]="${'a-class': condition}">`

#### Normal Dart code
You can use normal Dart code around the string literals to do complex things in your template.
You can have has many string literal as you want.

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
  ${img('landscape.png')}
  ''';
}

@template
_img(String url) {
  '<img src="$url">';
}
```

Note: you must call the "generated" function, not the original.

#### Component style
The template function could be inside a class the generated code will be slightly different to receive the class as an
argument.

#### Text element
- Use `<text *if="..">` tag if you want to output some text without the html element wrapper.
