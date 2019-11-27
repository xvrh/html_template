// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_myTemplate)
TrustedHtml myTemplate(List<MenuEntry> menu) {
  var $ = StringBuffer();

  MenuEntry entry;
  $.write('  ');
  $.write('<ul>');
  $.write('\n    ');
  for (entry in menu ?? const []) {
    $.write('<li>');
    $.write('''
      ${TrustedHtml.escape(entry.title)}
    ''');
    $.write('</li>');
  }
  $.write('\n  ');
  $.write('</ul>');
  $.write('\n  ');

  return TrustedHtml('${$}');
}
