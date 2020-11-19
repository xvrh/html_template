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

  return TrustedHtml($.toString());
}

@GenerateFor(_pageTemplate)
TrustedHtml pageTemplate(Product product, {List<String> scripts}) {
  var $ = StringBuffer();

  String script;
  $.writeln('<!DOCTYPE html>');
  $.write(
      '<html language="${TrustedHtml.escape.attribute(Language.current)}">');
  $.write('<head>');
  $.write('\n    ');
  $.write('<title>');
  $.write('${TrustedHtml.escape(product.name)} - My site');
  $.write('</title>');
  $.write('\n    ');
  for (script in scripts ?? const []) {
    $.write('<script src="${TrustedHtml.escape.attribute(script)}" async="">');
    $.write('</script>');
  }
  $.write('\n  ');
  $.write('</head>');
  $.write('\n  ');
  $.write('<body>');
  $.write('''
    ${TrustedHtml.escape(productTemplate(product))}
  

  ''');
  $.write('</body>');
  $.write('</html>');

  return TrustedHtml($.toString());
}
