import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_style/dart_style.dart';
import 'package:html_template/src/code_generator.dart';
import 'package:html_template/src/interpolation.dart';
import 'package:test/test.dart';

final _dartFormatter = DartFormatter(
  languageVersion: DartFormatter.latestLanguageVersion,
);

String generateCode(String input, {Options? options}) {
  var parsed = parseString(content: input);
  if (parsed.errors.isNotEmpty) {
    throw Exception(parsed.errors.toString());
  }
  var unit = parsed.unit;

  var firstFunction = unit.declarations.whereType<FunctionDeclaration>().first;
  var rawCode = generateCodeFromFunction(firstFunction, options: options);

  try {
    return _dartFormatter.format(rawCode);
  } catch (e) {
    print('Failed to format source code: $rawCode');
    rethrow;
  }
}

String generateCodeForTest(String input, {Options? options}) {
  options ??= Options();
  return generateCode(
    input,
    options: options.copyWith(addGenerateForAttribute: false),
  );
}

void main() {
  test('Convert function signature with void', () {
    var input = r'void _myTemplate({required bool showMenu}) {}';
    expect(
      generateCodeForTest(input),
      startsWith(r'TrustedHtml myTemplate({required bool showMenu}) {'),
    );
  });

  test('Convert function signature with Future', () {
    var input = r'Future _myTemplate({bool? showMenu}) {}';
    expect(
      generateCodeForTest(input),
      startsWith(r'Future<TrustedHtml> myTemplate({bool? showMenu}) {'),
    );
  });

  test('Convert function signature with Future<void>', () {
    var input = r'Future<void> _myTemplate({bool? showMenu}) {}';
    expect(
      generateCodeForTest(input),
      startsWith(r'Future<TrustedHtml> myTemplate({bool? showMenu}) {'),
    );
  });

  test('Convert function signature with empty async', () {
    var input = r'_myTemplate({bool? showMenu}) async {}';
    expect(
      generateCodeForTest(input),
      startsWith(r'Future<TrustedHtml> myTemplate({bool? showMenu}) async {'),
    );
  });

  test('Convert function signature with empty not async', () {
    var input = r'_myTemplate({bool? showMenu}) {}';
    expect(
      generateCodeForTest(input),
      startsWith(r'TrustedHtml myTemplate({bool? showMenu}) {'),
    );
  });

  test('Generate code from template function', () {
    var input = r"""
void _myTemplate({bool? showMenu}) {
  var data = getData();
  String format(int i) => i.toString();

  '''
<div>
  <ul *if="$showMenu">
  
  </ul>

</div>
  ''';
}
""";

    var result = generateCodeForTest(input);

    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate({bool? showMenu}) {
  var $ = StringBuffer();
  
  var data = getData();
  String format(int i) => i.toString();
  $.write('<div>');
  $.write('\n  ');
  if (template.nonNullBool(showMenu)) {
    $.write('<ul>');
    $.write('\n  \n  ');
    $.write('</ul>');
  }
  $.write('\n\n');
  $.write('</div>');
  $.write('\n  ');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with loop', () {
    var input = r"""
void _myTemplate(List<Data> data, {required bool showMenu}) {
  '''
<ul>
<li *for="$item in $data">$item</li>
</ul>''';
}
""";
    var result = generateCodeForTest(input);
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {required bool showMenu}) {
  var $ = StringBuffer();
  
  $.write('<ul>');
  $.write('\n');
  for (var item in template.nonNullIterable(data)) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item)}');
    $.write('</li>');
  }
  $.write('\n');
  $.write('</ul>');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with complex loop', () {
    var input = r"""
void _myTemplate(List<Data> data, {bool? showMenu}) {
  '''
<ul>
<li *for="$item in ${menu.breadcrumb.takeWhile((e) => e != lastBreadcrumb)}">$item</li>
</ul>''';
}
""";
    var result = generateCodeForTest(input);
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {bool? showMenu}) {
  var $ = StringBuffer();
  
  $.write('<ul>');
  $.write('\n');
  for (var item in template.nonNullIterable(menu.breadcrumb.takeWhile((e) => e != lastBreadcrumb))) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item)}');
    $.write('</li>');
  }
  $.write('\n');
  $.write('</ul>');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with multi loop', () {
    var input = r"""
void _myTemplate(List<Data>? data, {bool? showMenu}) {
  '''
<ul>
<li *for="$item in $data">
  <a *for="$e in ${item.subData}">${e.title}</a>
</li>
</ul>''';
}
""";

    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );

    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data>? data, {bool? showMenu}) {
  var $ = StringBuffer();
  
  $.write('<ul>');
  for (var item in template.nonNullIterable(data)) {
    $.write('<li>');
    for (var e in template.nonNullIterable(item.subData)) {
      $.write('<a>');
      $.write('${TrustedHtml.escape(e.title)}');
      $.write('</a>');
    }
    $.write('</li>');
  }
  $.write('</ul>');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate loop and if in the same tag', () {
    var input = r"""
void _myTemplate(List<Data> data, {required bool showMenu}) {
  '''
<ul>
<li *if="$showMenu" *for="$item in $data">$item</li>
</ul>''';
}
""";

    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );

    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {required bool showMenu}) {
  var $ = StringBuffer();
  
  $.write('<ul>');
  if (template.nonNullBool(showMenu)) {
    for (var item in template.nonNullIterable(data)) {
      $.write('<li>');
      $.write('${TrustedHtml.escape(item)}');
      $.write('</li>');
    }
  }
  $.write('</ul>');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Never output text tag', () {
    var input = r"""
void _myTemplate(List<Data> data, {bool? showMenu}) {
  '''
alb
<text *if="$showMenu">$item</text>
<text>bla</text>
''';
}
""";

    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );

    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {bool? showMenu}) {
  var $ = StringBuffer();
  
  $.write('''alb
''');
  if (template.nonNullBool(showMenu)) {
    $.write('${TrustedHtml.escape(item)}');
  }
  $.write('bla');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Allow multiple string literals', () {
    var input = r"""
void _myTemplate(List<Data> data, {bool? showMenu}) {
  '''<h1>H</h1>''';

  if (showMenu) {
    '<h1>Title</h1>';
  } else {
    Data item;
    '''
    <ul>
      <li *for="$item in $data">$item</li>
    </ul>
    ''';
  }
  'end';
}
""";
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {bool? showMenu}) {
  var $ = StringBuffer();
  
  $.writeln('''<h1>H</h1>''');

  if (showMenu) {
    $.writeln('<h1>Title</h1>');
  } else {
    Data item;
    $.write('<ul>');
    for (var item in template.nonNullIterable(data)) {
      $.write('<li>');
      $.write('${TrustedHtml.escape(item)}');
      $.write('</li>');
    }
    $.write('</ul>');
  }
  $.writeln('end');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with conditional attribute', () {
    var input = r"""
void _myTemplate(List<Data> data, {bool showMenu}) {
  '''
<li [active]="$showMenu">Actif</li>
<input type="text" [disabled]="$showMenu">''';
}
""";
    var result = generateCodeForTest(input);
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {bool showMenu}) {
  var $ = StringBuffer();
  
  $.write('<li${template.attributeIf('active', showMenu)}>');
  $.write('Actif');
  $.write('</li>');
  $.write('\n');
  $.write('<input type="text"${template.attributeIf('disabled', showMenu)}>');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with classes', () {
    var input = r"""
void _myTemplate(List<Data> data, {bool showMenu}) {
  '''
<li [class.active]="$showMenu" [class.enabled]="${data.isNotEmpty}">Actif</li>
<input type="text" [classes]="${data.map((e) => e.name)}">
<a type="text" [classes]="${{'enabled': showMenu}}" [class.active]="${true}" [classes]="$data"></a>''';
}
""";
    var result = generateCodeForTest(input);
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate(List<Data> data, {bool showMenu}) {
  var $ = StringBuffer();
  
  $.write('<li${template.classAttribute({'active': showMenu, 'enabled': data.isNotEmpty})}>');
  $.write('Actif');
  $.write('</li>');
  $.write('\n');
  $.write('<input type="text"${template.classAttribute(data.map((e) => e.name))}>');
  $.write('\n');
  $.write('<a type="text"${template.classAttribute({'enabled': showMenu}, {'active': true})}>');
  $.write('</a>');

  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code from template expression', () {
    var input = r"""
void _myTemplate({bool showMenu}) => 
  '''
<div>simple template $showMenu ${showMenu}</div>
  ''';
""";
    var result = generateCodeForTest(input);
    expect(
      result,
      equals(
        _dartFormatter.format(r"""
TrustedHtml myTemplate({bool showMenu}) {
  var $ = StringBuffer();
  
  $.write('<div>');
  $.write('simple template ${TrustedHtml.escape(showMenu)} ${TrustedHtml.escape(showMenu)}');
  $.write('</div>');
  $.write('\n  ');
  
  return TrustedHtml($.toString());
}
"""),
      ),
    );
  });

  test('Generate code with dynamic attribute and tag name', () {
    var input = r'''
_myTemplate() {
  '<img $attr=""><$tag open></$tag>';
}
    ''';
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<img ${attr}="">');
  $.write('<${tag} open="">');
  $.write('</${tag}>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Escape attribute with interpolation', () {
    var input = r"""
_myTemplate() {
  '''<img src="${item.url}">
    <img src="$item" alt=$myVar alt2=${myVar} alt3="ab${myVar}cd${var2}" alt4='$myVar'>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<img src="${TrustedHtml.escape.attribute(item.url)}">');
  $.write('<img src="${TrustedHtml.escape.attribute(item)}" alt="${TrustedHtml.escape.attribute(myVar)}" alt2="${TrustedHtml.escape.attribute(myVar)}" alt3="ab${TrustedHtml.escape.attribute(myVar)}cd${TrustedHtml.escape.attribute(var2)}" alt4="${TrustedHtml.escape.attribute(myVar)}">');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Text with single quote should be escaped', () {
    var input = r"""
_myTemplate() {
  '''
  <h1 alt="'My title's ${map['ok']}" alt2="'abc'">'My Title'</h1>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<h1 alt="\'My title\'s ${TrustedHtml.escape.attribute(map['ok'])}" alt2="\'abc\'">');
  $.write('\'My Title\'');
  $.write('</h1>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Generate code with switch case', () {
    var input = r"""
_myTemplate() {
  '''
<div *switch="$myVar">
  <span *case="one">One</span>
  <img *case="${two}" src="">
  <ul *case="${'three'}">
    <li>Inner</li>
  </ul>
  <div *default>Default</div>
</div>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<div>');
  switch (myVar) {
    case 'one': 
      $.write('<span>');
      $.write('One');
      $.write('</span>');
      break;
    case two: 
      $.write('<img src="">');
      break;
    case 'three': 
      $.write('<ul>');
      $.write('<li>');
      $.write('Inner');
      $.write('</li>');
      $.write('</ul>');
      break;
    default: 
      $.write('<div>');
      $.write('Default');
      $.write('</div>');
      break;
  }
  $.write('</div>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Generate code switch with text', () {
    var input = r"""
_myTemplate() {
  '''
<text *switch="$myVar">
  <text *case="one">One</text>
  <text *case="${two}">Two</text>
  <text *case="${'three'}">
    <li>Inner</li>
  </text>
  <text *default>Default</text>
</text>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  switch (myVar) {
    case 'one': 
      $.write('One');
      break;
    case two: 
      $.write('Two');
      break;
    case 'three': 
      $.write('<li>');
      $.write('Inner');
      $.write('</li>');
      break;
    default: 
      $.write('Default');
      break;
  }
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Should support special character in interpolation', () {
    var input = r"""
_myTemplate() {
  '''
<div>${'><'}</div>
<div>${'<div>'}</div>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<div>');
  $.write('${TrustedHtml.escape('><')}');
  $.write('</div>');
  $.write('<div>');
  $.write('${TrustedHtml.escape('<div>')}');
  $.write('</div>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Should support complete html document with doctype', () {
    var input = r"""
_myTemplate() {
  '''
<!doctype html>
<html language="${Language.current.code}">
  <head>
    <title>Mon ${info.title}</title>
  </head>
  <body>
    <h1>Title</h1>
  </body>
</html>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.writeln('<!DOCTYPE html>');
  $.write('<html language="${TrustedHtml.escape.attribute(Language.current.code)}">');
  $.write('<head>');
  $.write('<title>');
  $.write('Mon ${TrustedHtml.escape(info.title)}');
  $.write('</title>');
  $.write('</head>');
  $.write('<body>');
  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');
  $.write('</body>');
  $.write('</html>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Should support complete html document without doctype', () {
    var input = r"""
_myTemplate() {
  '''
<html language="${Language.current.code}">
  <head>
    <title>Mon ${info.title}</title>
  </head>
  <body>
    <h1>Title</h1>
  </body>
</html>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.write('<html language="${TrustedHtml.escape.attribute(Language.current.code)}">');
  $.write('<head>');
  $.write('<title>');
  $.write('Mon ${TrustedHtml.escape(info.title)}');
  $.write('</title>');
  $.write('</head>');
  $.write('<body>');
  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');
  $.write('</body>');
  $.write('</html>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('doctype as independent literal', () {
    var input = r"""
_myTemplate() {
  '<!doctype html>';
  '''
<html language="${Language.current.code}">
  <head>
    <title>Mon ${info.title}</title>
  </head>
  <body>
    <h1>Title</h1>
  </body>
</html>
  ''';
}
    """;
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml myTemplate() {
  var $ = StringBuffer();
  
  $.writeln('<!doctype html>');

  $.write('<html language="${TrustedHtml.escape.attribute(Language.current.code)}">');
  $.write('<head>');
  $.write('<title>');
  $.write('Mon ${TrustedHtml.escape(info.title)}');
  $.write('</title>');
  $.write('</head>');
  $.write('<body>');
  $.write('<h1>');
  $.write('Title');
  $.write('</h1>');
  $.write('</body>');
  $.write('</html>');
  
  return TrustedHtml($.toString());
}    
'''),
      ),
    );
  });

  test('Alternative loop', () {
    var input = r"""
@template
void _alternativeLoop(List<MenuItem> menu) {
  '<ul>';
  for (var item in menu) {
    '<li>${item.title}</li>';
  }
  '</ul>';
}
""";
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml alternativeLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  $.writeln('<ul>');

  for (var item in menu) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item.title)}');
    $.write('</li>');
  }
  $.writeln('</ul>');

  return TrustedHtml($.toString());
}
'''),
      ),
    );
  });

  test(
    'Alternative loop with attribute',
    () {
      var input = r"""
@template
void _alternativeLoop(List<MenuItem> menu) {
  '<ul lang="${Language.current}">';
  for (var item in menu) {
    '<li>${item.title}</li>';
  }
  '</ul>';
}
""";
      var result = generateCodeForTest(
        input,
        options: Options(skipWhitespaces: true),
      );
      expect(
        result,
        equals(
          _dartFormatter.format(r'''
TrustedHtml alternativeLoop(List<MenuItem> menu) {
  var $ = StringBuffer();

  $.write('<ul lang="${TrustedHtml.escape.attribute(Language.current)}">');

  for (var item in menu) {
    $.write('<li>');
    $.write('${TrustedHtml.escape(item.title)}');
    $.write('</li>');
  }
  $.writeln('</ul>');

  return TrustedHtml($.toString());
}
'''),
        ),
      );
    },
    skip: 'Need fix, should not ouput the closing ul tab before the loop',
  );

  test('Custom html', () {
    var input = r"""
@template
void _html() {
  'Text';
  '${Language.current}';
  'Text: ${Language.current}';
}
""";
    var result = generateCodeForTest(
      input,
      options: Options(skipWhitespaces: true),
    );
    expect(
      result,
      equals(
        _dartFormatter.format(r'''
TrustedHtml html() {
  var $ = StringBuffer();

  $.writeln('Text');
  
  $.write('${TrustedHtml.escape(Language.current)}');

  $.write('Text: ${TrustedHtml.escape(Language.current)}');

  return TrustedHtml($.toString());
}
'''),
      ),
    );
  });

  test('Extact interpolation', () {
    expect(extractInterpolation(r'${myVar}'), equals('myVar'));
    expect(extractInterpolation(r'${myVar == "a"}'), equals('myVar == "a"'));
    expect(extractInterpolation(r'${myVar == null}'), equals('myVar == null'));
    expect(extractInterpolation(r'$myVar'), equals('myVar'));
    expect(extractInterpolation(r'${getData(xx)}'), equals('getData(xx)'));
    expect(
      extractInterpolation(r"${{'enable': true}}"),
      equals("{'enable': true}"),
    );
    expect(
      () => extractInterpolation('myVar'),
      throwsA(TypeMatcher<GeneratorException>()),
    );
    expect(
      () => extractInterpolation(r'$myVar == true'),
      throwsA(TypeMatcher<GeneratorException>()),
    );
    expect(
      () => extractInterpolation(r'${myVar} == true'),
      throwsA(TypeMatcher<GeneratorException>()),
    );
    expect(
      () => extractInterpolation(r' ${myVar}'),
      throwsA(TypeMatcher<GeneratorException>()),
    );
    expect(
      () => extractInterpolation(r'${myVar} '),
      throwsA(TypeMatcher<GeneratorException>()),
    );
    expect(
      () => extractInterpolation(r'true'),
      throwsA(TypeMatcher<GeneratorException>()),
    );
  });
}
