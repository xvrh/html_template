// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_myTemplate)
TrustedHtml myTemplate() {
  var $ = StringBuffer();

  $.write('  ');
  $.write('<h1>');
  $.write('Images');
  $.write('</h1>');
  $.write('''
  ${TrustedHtml.escape(img('landscape.png'))}
  ''');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_img)
TrustedHtml img(String url) {
  var $ = StringBuffer();

  $.write('<img src="${TrustedHtml.escape.attribute(url)}">');

  return TrustedHtml($.toString());
}
