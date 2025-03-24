// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'css_classes.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_cssClassesExample)
TrustedHtml cssClassesExample(List<Data> data, {bool showMenu = false}) {
  var $ = StringBuffer();

  $.write(
    '<li${template.classAttribute({'active': showMenu, 'enabled': data.isNotEmpty})}>',
  );
  $.write('Actif');
  $.write('</li>');
  var myClasses = {'enabled': showMenu};
  $.write('<a type="text"${template.classAttribute(myClasses)}>');
  $.write('</a>');

  return TrustedHtml($.toString());
}
