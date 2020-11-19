// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'css_classes.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_cssClassesExample)
TrustedHtml cssClassesExample(List<Data> data, {bool showMenu}) {
  var $ = StringBuffer();

  $.write('<li${template.classAttribute({
    'active': showMenu,
    'enabled': data.isNotEmpty
  })}>');
  $.write('Actif');
  $.write('</li>');
  var myClasses = {'enabled': showMenu};
  $.write('<a type="text"${template.classAttribute(myClasses)}>');
  $.write('</a>');

  return TrustedHtml($.toString());
}
