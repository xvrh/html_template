// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
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
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
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
