// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_conditionExample)
Future<TrustedHtml> conditionExample({required bool someCondition}) async {
  var $ = StringBuffer();

  $.write('  ');
  $.writeln('''<!--  Conditionally include the <h2> tag  -->''');
  $.write('\n  ');
  if (template.nonNullBool(someCondition)) {
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
  if (template.nonNullBool((await fetchData()).isEmpty)) {
    $.write('<hr>');
  }
  $.write('\n  ');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_conditionAlt)
TrustedHtml conditionAlt({required bool showMenu}) {
  var $ = StringBuffer();

  $.writeln('<h1>Title</h1>');

  if (!showMenu) {
    $.writeln('<h2>Sub title</h2>');
  }

  return TrustedHtml($.toString());
}
