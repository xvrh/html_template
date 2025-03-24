import 'package:html_template/html_template.dart';

part 'master_details.g.dart';

// ignore_for_file: unnecessary_statements

@template
void _productTemplate(Product product) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <h1 [class.new]="${product.isNew}">$product</h1>
  ''';

  template.master = (body) => master(title: product.name, body: body);
}

@template
void _master({required String title, required TrustedHtml body}) {
  '<!doctype html>';
  '''
<html>
  <head>
    <title>$title</title>
  </head>
  <body>
    $body
  </body>
</html>
  ''';
}

class Product {
  bool get isNew => false;
  String? get icon => '';
  String get name => '';
}
