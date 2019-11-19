// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_literals.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_myTemplate)
TrustedHtml myTemplate(List<Data> data, {bool showMenu}) {
  var $ = StringBuffer();

  $.write('Title');

  if (showMenu) {
    $.write('<h1>');
    $.write('Title');
    $.write('</h1>');
  } else {
    Data item;
    $.write('    ');
    $.write('<ul>');
    $.write('\n      ');
    for (item in data ?? const []) {
      $.write('<li>');
      $.write('${TrustedHtml.escape(item)}');
      $.write('</li>');
    }
    $.write('\n    ');
    $.write('</ul>');
    $.write('\n    ');
  }
  $.write('end');

  return TrustedHtml('${$}');
}
