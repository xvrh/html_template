// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_conditionExample)
Future<TrustedHtml> conditionExample({bool someCondition}) async {
  var $ = StringBuffer();

  $.write('  ');
  $.writeln('''<!--  Conditionally include the <h2> tag  -->''');
  $.write('\n  ');
  if (someCondition ?? false) {
    $.write('<h2>');
    $.write('Condition on a tag');
    $.write('</h2>');
  }
  $.write('\n  \n  ');
  $.writeln(
      '''<!--  Include the 'disabled' attribute if the condition is true  -->''');
  $.write('\n  ');
  $.write('<input${template.attributeIf('disabled', someCondition)}>');
  $.write('\n  \n  ');
  $.writeln('''<!--  Add 'my-class' CSS class if the condition is true  -->''');
  $.write('\n  ');
  $.write('<input${template.classAttribute({'my-class': someCondition})}>');
  $.write('\n  \n    ');
  $.writeln('''<!--  Use any Dart expression for the condition  -->''');
  $.write('\n  ');
  if ((await fetchData()).isEmpty ?? false) {
    $.write('<hr>');
  }
  $.write('\n  ');

  return TrustedHtml($.toString());
}

@GenerateFor(_conditionAlt)
TrustedHtml conditionAlt({bool showMenu}) {
  var $ = StringBuffer();

  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');
  if (!showMenu) {
    $.write('<h2>');
    $.write('Sub title');
    $.write('</h2>');
  }

  return TrustedHtml($.toString());
}
