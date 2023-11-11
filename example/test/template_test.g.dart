// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_test.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_emptyTemplate)
TrustedHtml emptyTemplate() {
  var $ = StringBuffer();

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_simpleTemplate)
TrustedHtml simpleTemplate() {
  var $ = StringBuffer();

  $.writeln('''<h1>Title</h1>''');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_condition)
TrustedHtml condition({bool? myVar = false}) {
  var $ = StringBuffer();

  if (template.nonNullBool(myVar)) {
    $.write('True');
  }

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_interpolation)
TrustedHtml interpolation(String? someText) {
  var $ = StringBuffer();

  $.write('-${TrustedHtml.escape(someText)}-');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_loop)
TrustedHtml loop(Iterable<String>? list) {
  var $ = StringBuffer();

  var item = '';
  for (var item in template.nonNullIterable(list)) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item)}');
    $.write('</li>');
  }

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_switchTemplate)
TrustedHtml switchTemplate(MyEnum? myEnum) {
  var $ = StringBuffer();

  $.write('<div>');
  switch (myEnum) {
    case MyEnum.one:
      $.write('<span>');
      $.write('One');
      $.write('</span>');
      break;
    case MyEnum.two:
      $.write('<span>');
      $.write('Two');
      $.write('</span>');
      break;
    default:
      $.write('<span>');
      $.write('Default');
      $.write('</span>');
      break;
  }
  $.write('</div>');
  $.write('\n');

  $.writeln('<span>End</span>');

  return TrustedHtml($.toString());
}

// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
@GenerateFor(_attribute)
TrustedHtml attribute(
    {bool disabled = false, bool isActive = false, List<String>? classes}) {
  var $ = StringBuffer();

  $.write(
      '<input${template.attributeIf('disabled', disabled)}${template.classAttribute(classes, {
        'active': isActive
      })}>');
  $.write('\n');
  $.write(
      '<span${template.classAttribute({'aa': isActive, 'dis': disabled})}>');
  $.write('</span>');
  $.write('\n');

  return TrustedHtml($.toString());
}
