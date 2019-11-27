// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_productTemplate)
TrustedHtml productTemplate(Product product) {
  var $ = StringBuffer();

  $.write('  ');
  if (product.icon != null ?? false) {
    $.write('<img src="${TrustedHtml.escape.attribute(product.icon)}">');
  }
  $.write('\n  ');
  $.write('<h1${template.classAttribute({'new': product.isNew})}>');
  $.write('${TrustedHtml.escape(product)}');
  $.write('</h1>');
  $.write('\n  ');

  return TrustedHtml('${$}');
}

@GenerateFor(_masterTemplate)
TrustedHtml masterTemplate(
    {@required TrustedHtml body, String title, List<String> scripts}) {
  var $ = StringBuffer();

  String script;
  $.writeln('<!DOCTYPE html>');
  $.write(
      '<html language="${TrustedHtml.escape.attribute(Language.current)}">');
  $.write('<head>');
  $.write('\n    ');
  $.write('<title>');
  $.write('${TrustedHtml.escape(title)} - My site');
  $.write('</title>');
  $.write('\n    ');
  for (script in scripts ?? const []) {
    $.write('<script async="">');
    $.write('</script>');
  }
  $.write('\n  ');
  $.write('</head>');
  $.write('\n  ');
  $.write('<body>');
  $.write('''
    ${TrustedHtml.escape(body)}
  

  ''');
  $.write('</body>');
  $.write('</html>');

  return TrustedHtml('${$}');
}
