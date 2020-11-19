// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_literals.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_myTemplate)
Future<TrustedHtml> myTemplate() async {
  var $ = StringBuffer();

  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');
  var myPage = buildPage();
  if (!myPage.hasData) {
    $.write('<h2>');
    $.write('Sub title');
    $.write('</h2>');
  } else {
    var data = await fetchData();
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
  $.write('<footer>');
  $.write('Footer');
  $.write('</footer>');

  return TrustedHtml($.toString());
}
