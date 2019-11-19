import 'package:html_template/html_template.dart';

part 'a_package.g.dart';

@template
_productTemplate(Product product, {bool withSeparator = false}) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <a [class.new]="${product.isNew}">$product</a>
  <hr *if="$withSeparator">
  ''';
}

class Product {
  String icon;
  bool isNew;
}
