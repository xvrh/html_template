

import 'package:html_template/html_template.dart';
import 'package:meta/meta.dart';
import 'main.dart';

//====== 1
// Generated
TrustedHtml productTemplate(Product product, {bool withSeparator = false}) {
  var output = StringBuffer();
  if (product.icon != null) {
    output.writeln('<img src="${escapeAttribute(product.icon)}">');
  }
  output.writeln('<h1 class="${product.isNew ? "new" : ""}">');
  output.writeln('${escapeHtml(product)}');
  output.writeln('</h1>');
  return TrustedHtml('$output');
}

TrustedHtml masterTemplate({@required TrustedHtml body, String title}) {
  var output = StringBuffer();
  output.writeln('<!doctype html>');
  output.writeln('<html language="${escapeAttribute(Language.current)}">');
  // ...
  return TrustedHtml('$output');
}
//=====
