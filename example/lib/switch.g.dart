// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
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
