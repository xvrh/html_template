// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_details.dart';

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

  TrustedHtml Function(TrustedHtml) $master =
      (body) => master(title: product.name, body: body);

  return $master(TrustedHtml($.toString()));
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_master)
TrustedHtml master({required String title, required TrustedHtml body}) {
  var $ = StringBuffer();

  $.writeln('<!doctype html>');

  $.write('<html>');
  $.write('<head>');
  $.write('\n    ');
  $.write('<title>');
  $.write('${TrustedHtml.escape(title)}');
  $.write('</title>');
  $.write('\n  ');
  $.write('</head>');
  $.write('\n  ');
  $.write('<body>');
  $.write('''
    ${TrustedHtml.escape(body)}
  

  ''');
  $.write('</body>');
  $.write('</html>');

  return TrustedHtml($.toString());
}
