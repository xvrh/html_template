import 'dart:convert';

class TemplateAnnotation {
  const TemplateAnnotation();

  /// Returns the attribute if the condition is true.
  String attributeIf(String attributeName, bool condition) {
    if (condition) {
      return ' $attributeName';
    }
    return '';
  }

  /// Build a class attribute
  String classAttribute(
    Object? class1, [
    Object? class2,
    Object? class3,
    Object? class4,
    Object? class5,
  ]) {
    var classes = <String>{};
    for (var arg in [class1, class2, class3, class4, class5]) {
      if (arg != null) {
        if (arg is Iterable<String>) {
          classes.addAll(arg);
        } else if (arg is Map<String, bool>) {
          for (var classEntry in arg.entries) {
            var condition = classEntry.value;
            if (condition) {
              classes.add(classEntry.key);
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

  Iterable<T> nonNullIterable<T>(Iterable<T>? iterable) => iterable ?? const [];

  bool nonNullBool(bool? value) => value ?? false;

  // ignore: avoid_setters_without_getters
  set master(void Function(TrustedHtml body) template) {}
}

/// The annotation to put on a private method to activate the builder on it.
const template = TemplateAnnotation();

/// A marker class to recognize HTML that should not be sanitized.
class TrustedHtml {
  static final escape = _Escape();
  final String _value;

  TrustedHtml(this._value);

  @override
  String toString() => _value;

  @override
  bool operator ==(Object other) =>
      other is TrustedHtml && '$other' == '$this' ||
      other is String && other == '$this';

  @override
  int get hashCode => _value.hashCode;
}

class _Escape {
  static const _element = HtmlEscape(HtmlEscapeMode.element);
  static const _attribute = HtmlEscape(HtmlEscapeMode.attribute);
  static const _sqAttribute = HtmlEscape(HtmlEscapeMode.sqAttribute);

  String call(Object? input) {
    if (input == null) return '';
    if (input is TrustedHtml) return '$input';
    return _element.convert('$input');
  }

  String attribute(Object? input) {
    if (input == null) return '';
    return _Escape._attribute.convert('$input');
  }

  String attributeSingleQuote(Object? input) {
    if (input == null) return '';
    return _Escape._sqAttribute.convert('$input');
  }
}

class GenerateFor {
  const GenerateFor(Function reference);
}
