import 'package:html_template/html_template.dart';
import 'package:test/test.dart';

part 'template_test.g.dart';

// ignore_for_file: unused_element
// ignore_for_file: unnecessary_statements

void main() {
  void eq(TrustedHtml templateResult, String expected) {
    expect(templateResult, equals(TrustedHtml(expected)));
  }

  test('empty template', () {
    eq(emptyTemplate(), '');
  });

  test('simple template', () {
    eq(simpleTemplate(), '<h1>Title</h1>');
  });

  test('condition', () {
    eq(condition(myVar: true), 'True');
    eq(condition(myVar: false), '');
    eq(condition(myVar: null), '');
  });

  test('interpolation', () {
    eq(interpolation('abc'), '-abc-');
    eq(interpolation('<abc>'), '-&lt;abc&gt;-');
    eq(interpolation(null), '--');
  });

  test('loop', () {
    eq(loop(['abc', 'def']), '<li>abc</li><li>def</li>');
    eq(loop([]), '');
    eq(loop(null), '');
  });

  test('switch', () {
    eq(switchTemplate(MyEnum.one), '''
<div><span>One</span></div>
<span>End</span>''');
    eq(switchTemplate(null), '''
<div><span>Default</span></div>
<span>End</span>''');
  });

  test('Attributes', () {
    eq(attribute(disabled: true, isActive: true), '''
<input disabled class="active">
<span class="aa dis"></span>
''');
    eq(
        attribute(
            disabled: false,
            isActive: true,
            classes: ['my-class', 'my-class', 'other']),
        '''
<input class="my-class other active">
<span class="aa"></span>
''');
  });
}

@template
void _emptyTemplate() {}

@template
void _simpleTemplate() {
  '''<h1>Title</h1>''';
}

@template
void _condition({bool? myVar = false}) {
  '''<text *if="$myVar">True</text>''';
}

@template
void _interpolation(String? someText) {
  '''-$someText-''';
}

@template
void _loop(Iterable<String>? list) {
  var item = '';
  '''<li *for="$item in $list">$item</li>''';
}

enum MyEnum { one, two, three }

@template
void _switchTemplate(MyEnum? myEnum) {
  '''
<div *switch="$myEnum">
  <span *case="${MyEnum.one}">One</span>
  <span *case="${MyEnum.two}">Two</span>
  <span *default>Default</span>
</div>
''';

  '<span>End</span>';
}

@template
void _attribute(
    {bool disabled = false, bool isActive = false, List<String>? classes}) {
  '''
<input [disabled]="$disabled" [class.active]="$isActive" [classes]="$classes">
<span [classes]="${{'aa': isActive, 'dis': disabled}}"></span>
''';
}
