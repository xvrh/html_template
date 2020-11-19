import 'package:html_template/html_template.dart';
import 'package:meta/meta.dart';
import 'main.dart';

// ignore_for_file: unnecessary_statements

//--- generated
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
//----
