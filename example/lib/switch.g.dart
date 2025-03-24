// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_switchExample)
TrustedHtml switchExample(Season season) {
  var $ = StringBuffer();

  $.write('<div>');
  switch (season) {
    case Season.summer:
      $.write('<span>');
      $.write('Hot');
      $.write('</span>');
      break;
    case Season.winter:
      $.write('<span>');
      $.write('Cold');
      $.write('</span>');
      break;
    default:
      $.write('<div>');
      $.write('Pleasant');
      $.write('</div>');
      break;
  }
  $.write('</div>');
  $.write('\n  ');

  return TrustedHtml($.toString());
}
