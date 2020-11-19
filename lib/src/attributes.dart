import 'package:meta/meta.dart';
import 'code_generator.dart' show GeneratorException;
import 'interpolation.dart';

final _classAttributeExtractor =
    RegExp(r'^\[class\.([a-z0-9-_]+)\]$', caseSensitive: false);
final _conditionalExtractor =
    RegExp(r'^\[([a-z0-9-_]+)\]$', caseSensitive: false);

final _structuralDirectives = <String, StructuralAttribute Function(String)>{
  'if': (attribute) => IfAttribute(attribute),
  'for': (attribute) => ForAttribute(attribute),
  'switch': (attribute) => SwitchAttribute(attribute),
  'case': (attribute) => CaseAttribute(attribute),
  'default': (_) => SwitchDefaultAttribute(),
};

class Attributes {
  final Map<String, String> stringReplacements;
  final Map<String, String> _attributes;
  final _class = <String, String>{};
  final _classes = <String>[];
  final structurals = <StructuralAttribute>[];

  Attributes(Map<Object, String> attributesFromElement,
      {@required this.stringReplacements})
      : _attributes =
            attributesFromElement.map((k, v) => MapEntry(k.toString(), v)) {
    for (var attribute in _attributes.entries.toList()) {
      var name = attribute.key;
      var classMatch = _classAttributeExtractor.firstMatch(name);
      var attributeValue = _withInterpolation(attribute.value, escape: false);
      if (classMatch != null) {
        _class[classMatch.group(1)] = extractInterpolation(attributeValue);
        _attributes.remove(name);
      } else if (name == '[classes]') {
        _classes.add(extractInterpolation(attributeValue));
        _attributes.remove(name);
      } else if (name.startsWith('*')) {
        var structuralDirective = _structuralDirectives[name.substring(1)];
        if (structuralDirective != null) {
          structurals.add(structuralDirective(attributeValue));
          _attributes.remove(name);
        }
      }
    }
  }

  String _withInterpolation(String data, {@required bool escape}) {
    for (var replacementKey in stringReplacements.keys) {
      var replacement = stringReplacements[replacementKey];
      if (escape) {
        replacement = 'TrustedHtml.escape.attribute($replacement)';
      }
      data = data.replaceAllMapped(replacementKey, (_) => '\${$replacement}');
    }
    return data;
  }

  String toCode() {
    var code = <String>[];
    for (var entry in _attributes.entries) {
      var value = entry.value;
      var name = entry.key;

      var conditionalMatch = _conditionalExtractor.firstMatch(name);
      if (conditionalMatch != null) {
        code.add(
            "\${template.attributeIf('${conditionalMatch.group(1)}', ${extractInterpolation(_withInterpolation(value, escape: false))})}");
      } else {
        value = value.replaceAll("'", r"\'");
        code.add(
            ' ${_withInterpolation(name, escape: false)}="${_withInterpolation(value, escape: true)}"');
      }
    }
    if (_class.isNotEmpty || _classes.isNotEmpty) {
      var classArguments = <String>[];
      classArguments.addAll(_classes);
      if (_class.isNotEmpty) {
        var mapArguments =
            _class.entries.map((e) => "'${e.key}': ${e.value}").join(', ');
        classArguments.add('{$mapArguments}');
      }

      code.add("\${template.classAttribute(${classArguments.join(', ')})}");
    }

    return code.join('');
  }
}

abstract class StructuralAttribute {
  String get openStructure;

  String get closeStructure;

  bool get encloseTag => true;
}

class IfAttribute extends StructuralAttribute {
  final String condition;

  IfAttribute(String attributeValue)
      : condition = extractInterpolation(attributeValue);

  @override
  String get openStructure {
    return 'if ($condition ?? false) {';
  }

  @override
  String get closeStructure => '}';
}

final _forExtractor =
    RegExp(r'^\s*([^\s]+)\s+in\s+(.+)\s*$', caseSensitive: false);

class ForAttribute extends StructuralAttribute {
  String _item, _iterable;

  ForAttribute(String attributeValue) {
    var extracted = _forExtractor.firstMatch(attributeValue);
    if (extracted == null) {
      throw GeneratorException(
          r'*for attributes must be in the format: *for="$item in $iterable"');
    }
    _item = extractInterpolation(extracted.group(1));
    _iterable = extractInterpolation(extracted.group(2));
  }

  @override
  String get openStructure {
    return 'for ($_item in $_iterable ?? const []) {';
  }

  @override
  String get closeStructure => '}';
}

class SwitchAttribute extends StructuralAttribute {
  final String _expression;

  SwitchAttribute(String value) : _expression = extractInterpolation(value);

  @override
  String get openStructure => 'switch ($_expression) {';

  @override
  String get closeStructure => '}';

  @override
  bool get encloseTag => false;
}

class CaseAttribute extends StructuralAttribute {
  String _matcher;

  CaseAttribute(String value) {
    try {
      _matcher = extractInterpolation(value);
    } catch (_) {
      _matcher = "'$value'";
    }
  }

  @override
  String get openStructure => 'case $_matcher:';

  @override
  String get closeStructure => 'break;';
}

class SwitchDefaultAttribute extends StructuralAttribute {
  @override
  String get openStructure => 'default:';

  @override
  String get closeStructure => 'break;';
}
