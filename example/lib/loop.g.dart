// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_simpleLoop)
TrustedHtml simpleLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  MenuItem? item;
  $.write('  ');
  $.write('<ul>');
  $.write('\n    ');
  for (var item in template.nonNullIterable(menu)) {
    $.write('<li>');
    $.write('''
      ${TrustedHtml.escape(item.title)}
    ''');
    $.write('</li>');
  }
  $.write('\n  ');
  $.write('</ul>');
  $.write('\n  ');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_alternativeLoop)
TrustedHtml alternativeLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  $.writeln('<ul>');

  for (var item in menu) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item.title)}');
    $.write('</li>');
  }
  $.writeln('</ul>');

  return TrustedHtml($.toString());
}
