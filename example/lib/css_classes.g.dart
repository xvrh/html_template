// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'css_classes.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
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
