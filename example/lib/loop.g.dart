// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_simpleLoop)
TrustedHtml simpleLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  MenuItem item;
  $.write('  ');
  $.write('<ul>');
  $.write('\n    ');
  for (item in menu ?? const []) {
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

@GenerateFor(_alternativeLoop)
TrustedHtml alternativeLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  $.write('<ul>');
  $.write('</ul>');
  for (var item in menu) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item.title)}');
    $.write('</li>');
  }

  return TrustedHtml($.toString());
}
