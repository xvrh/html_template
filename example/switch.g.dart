// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_myTemplate)
TrustedHtml myTemplate(Season season) {
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
      $.write('Neutral');
      $.write('</div>');
      break;
  }
  $.write('</div>');
  $.write('\n  ');

  return TrustedHtml('${$}');
}
