// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

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

@GenerateFor(_img)
TrustedHtml img(String url) {
  var $ = StringBuffer();

  $.write('<img src="${TrustedHtml.escape.attribute(url)}">');

  return TrustedHtml($.toString());
}
