// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_productTemplate)
TrustedHtml productTemplate(Product product) {
  var $ = StringBuffer();

  $.write('  ');
  if (template.nonNullBool(product.icon != null)) {
    $.write('<img src="${TrustedHtml.escape.attribute(product.icon)}">');
  }
  $.write('\n  ');
  $.write('<h1${template.classAttribute({'new': product.isNew})}>');
  $.write('${TrustedHtml.escape(product)}');
  $.write('</h1>');
  $.write('\n  ');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_pageTemplate)
TrustedHtml pageTemplate(Product product, {List<String>? scripts}) {
  var $ = StringBuffer();

  var script = '';
  $.write('<html lang="${TrustedHtml.escape.attribute(Language.current)}">');
  $.write('<head>');
  $.write('\n    ');
  $.write('<title>');
  $.write('${TrustedHtml.escape(product.name)} - My site');
  $.write('</title>');
  $.write('\n    ');
  for (var script in template.nonNullIterable(scripts)) {
    $.write('<script src="${TrustedHtml.escape.attribute(script)}" async="">');
    $.write('</script>');
  }
  $.write('\n  ');
  $.write('</head>');
  $.write('\n  ');
  $.write('<body>');
  $.write('''
    ${TrustedHtml.escape(productTemplate(product))}
  

  ''');
  $.write('</body>');
  $.write('</html>');

  return TrustedHtml($.toString());
}
