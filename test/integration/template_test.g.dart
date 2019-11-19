// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_test.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_emptyTemplate)
TrustedHtml emptyTemplate() {
  var $ = StringBuffer();

  return TrustedHtml('${$}');
}

@GenerateFor(_simpleTemplate)
TrustedHtml simpleTemplate() {
  var $ = StringBuffer();

  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');

  return TrustedHtml('${$}');
}

@GenerateFor(_condition)
TrustedHtml condition({bool myVar = false}) {
  var $ = StringBuffer();

  if (myVar ?? false) {
    $.write('True');
  }

  return TrustedHtml('${$}');
}

@GenerateFor(_interpolation)
TrustedHtml interpolation(String someText) {
  var $ = StringBuffer();

  $.write('-${TrustedHtml.escape(someText)}-');

  return TrustedHtml('${$}');
}

@GenerateFor(_loop)
TrustedHtml loop(Iterable<String> list) {
  var $ = StringBuffer();

  String item;
  for (item in list ?? const []) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item)}');
    $.write('</li>');
  }

  return TrustedHtml('${$}');
}

@GenerateFor(_switchTemplate)
TrustedHtml switchTemplate(MyEnum myEnum) {
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

  $.write('<span>');
  $.write('End');
  $.write('</span>');

  return TrustedHtml('${$}');
}

@GenerateFor(_attribute)
TrustedHtml attribute(
    {bool disabled = false, bool isActive = false, List<String> classes}) {
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

  return TrustedHtml('${$}');
}
