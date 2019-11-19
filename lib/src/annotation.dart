import 'dart:convert';

class TemplateAnnotation {
  const TemplateAnnotation();

  String attributeIf(String attributeName, bool condition) {
    if (condition) {
      return ' $attributeName';
    }
    return '';
  }

  String classAttribute(dynamic class1,
      [dynamic class2, dynamic class3, dynamic class4, dynamic class5]) {
    var classes = <String>{};
    for (var arg in [class1, class2, class3, class4, class5]) {
      if (arg != null) {
        if (arg is Iterable) {
          classes.addAll(arg);
        } else if (arg is Map) {
          for (String className in arg.keys) {
            bool condition = arg[className];
            if (condition) {
              classes.add(className);
            }
          }
        } else if (arg is String) {
          classes.add(arg);
        }
      }
    }
    if (classes.isNotEmpty) {
      return ' class="${const HtmlEscape(HtmlEscapeMode.attribute).convert(classes.join(' '))}"';
    } else {
      return '';
    }
  }
}

const template = TemplateAnnotation();

class TrustedHtml {
  static final escape = _Escape();
  final String _value;

  TrustedHtml(this._value);

  toString() => _value;

  bool operator ==(other) =>
      other is TrustedHtml && '$other' == '$this' ||
      other is String && other == '$this';

  int get hashCode => _value.hashCode;
}

class _Escape {
  static const _element = HtmlEscape(HtmlEscapeMode.element);
  static const _attribute = HtmlEscape(HtmlEscapeMode.attribute);
  static const _sqAttribute = HtmlEscape(HtmlEscapeMode.sqAttribute);

  String call(input) {
    if (input == null) return '';
    if (input is TrustedHtml) return '$input';
    return _element.convert('$input');
  }

  String attribute(input) {
    if (input == null) return '';
    return _Escape._attribute.convert('$input');
  }

  String attributeSingleQuote(input) {
    if (input == null) return '';
    return _Escape._sqAttribute.convert('$input');
  }
}

class GenerateFor {
  const GenerateFor(Function reference);
}
