## 0.4.0

- Allow to set a master template within a template.
```dart
@template
void _productTemplate(Product product) {
  // ... the template
  
  // Call this to automatically wrap productTemplate in the pageTemplate
  template.master = (body) => pageTemplate(title: product.name, body: body);
}

@template
void _pageTemplate({required String title, required TrustedHtml body}) {
  '''
<html>
  <head><title>$title</title></head>
  <body>$body</body>
</html>
  ''';
}
 
```

## 0.3.1

- Upgrade dependencies

## 0.3.0

- Fix alternative loop syntax
- Fix `<doctype>`

## 0.2.2

- Replace `package:pedantic` with `package:lints`
- Upgrade `package:analyzer` dependency.

## 0.2.1

- Support latest version of dependencies

## 0.2.0

- Support null-safety

## 0.1.1

- Improve pub score

## 0.1.0

- Initial version, created by Stagehand
