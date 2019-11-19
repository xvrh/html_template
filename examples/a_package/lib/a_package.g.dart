// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'a_package.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_productTemplate)
TrustedHtml productTemplate(Product product, {bool withSeparator = false}) {
  var $ = StringBuffer();

  $.write('  ');
  if (product.icon != null ?? false) {
    $.write('<img src="${TrustedHtml.escape.attribute(product.icon)}">');
  }
  $.write('\n  ');
  $.write('<a${template.classAttribute({'new': product.isNew})}>');
  $.write('${TrustedHtml.escape(product)}');
  $.write('</a>');
  $.write('\n  ');
  if (withSeparator ?? false) {
    $.write('<hr>');
  }
  $.write('\n  ');

  return TrustedHtml('${$}');
}
