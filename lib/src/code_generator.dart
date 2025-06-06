import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/ast/to_source_visitor.dart';
import 'package:html/dom.dart' hide Comment;
import 'package:html/dom.dart' as html;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
// ignore: implementation_imports
import 'package:html/src/constants.dart';
import 'attributes.dart';
import 'utils.dart';

class Options {
  final bool skipWhitespaces;
  final bool addGenerateForAttribute;

  Options({bool? skipWhitespaces, bool? addGenerateForAttribute})
    : skipWhitespaces = skipWhitespaces ?? false,
      addGenerateForAttribute = addGenerateForAttribute ?? true;

  Options copyWith({bool? skipWhitespaces, bool? addGenerateForAttribute}) =>
      Options(
        skipWhitespaces: skipWhitespaces ?? this.skipWhitespaces,
        addGenerateForAttribute:
            addGenerateForAttribute ?? this.addGenerateForAttribute,
      );
}

class GeneratorException implements Exception {
  final String message;

  GeneratorException(this.message);

  @override
  String toString() => message;
}

String generateCodeFromFunction(
  FunctionDeclaration function, {
  Options? options,
}) {
  options ??= Options();
  var code = StringBuffer();

  if (!function.name.toString().startsWith('_')) {
    throw GeneratorException(
      'Template function must be private ${function.name.toString()}',
    );
  }
  var functionName = function.name.toString().substring(1);

  var returnType = 'TrustedHtml';
  if (function.returnType.toString().startsWith('Future') ||
      function.functionExpression.body.isAsynchronous) {
    returnType = 'Future<$returnType>';
  }

  if (options.addGenerateForAttribute) {
    code.writeln('@GenerateFor(${function.name.toString()})');
  }

  var parametersCode = StringBuffer();
  ToSourceVisitor(
    parametersCode,
  ).visitFormalParameterList(function.functionExpression.parameters!);
  code.writeln(
    '$returnType $functionName$parametersCode'
    '${function.functionExpression.body.isAsynchronous ? 'async' : ''} {',
  );
  code.writeln(r'var $ = StringBuffer();');
  code.writeln('');

  var body = function.functionExpression.body;
  var hasMaster = false;
  if (body is BlockFunctionBody) {
    var visitor = _Visitor(options);
    body.visitChildren(visitor);

    var bodyCode = StringBuffer();
    var printer = _Printer(bodyCode, visitor._replacements);
    body.block.visitChildren(printer);
    hasMaster = printer.hasMaster;

    code.writeln(bodyCode);
  } else if (body is ExpressionFunctionBody) {
    var expression = body.expression as StringLiteral;
    code.write(_handleStringLiteral(options, expression));
  } else {
    throw UnimplementedError();
  }

  code.writeln('');
  var bodyExpression = r'TrustedHtml($.toString())';
  if (hasMaster) {
    bodyExpression = '\$master($bodyExpression)';
  }

  code.writeln('return $bodyExpression;');
  code.write('}');

  return code.toString();
}

class _Visitor extends RecursiveAstVisitor<void> {
  final Options options;
  final List<_Replacement> _replacements = [];

  _Visitor(this.options);

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    super.visitExpressionStatement(node);

    var expression = node.expression;
    if (expression is StringLiteral) {
      var newCode = _handleStringLiteral(options, expression);

      _replacements.add(_Replacement(node, newCode));
    }
  }
}

class _Replacement {
  final ExpressionStatement source;
  final String newCode;

  _Replacement(this.source, this.newCode);
}

class _Printer extends ToSourceVisitor {
  final List<_Replacement> replacements;
  bool hasMaster = false;

  _Printer(super.sink, this.replacements);

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    var replacement = replacements.firstWhereOrNull((f) => f.source == node);
    if (replacement != null) {
      sink.writeln(replacement.newCode);
    } else {
      super.visitExpressionStatement(node);
    }
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    if (node.leftHandSide case PrefixedIdentifier prefixed) {
      if (prefixed.prefix.name == 'template' &&
          prefixed.identifier.name == 'master') {
        sink.writeln(
          'TrustedHtml Function(TrustedHtml) \$master = ${node.rightHandSide.toSource()}',
        );
        hasMaster = true;
        return;
      }
    }
    super.visitAssignmentExpression(node);
  }
}

String _handleStringLiteral(Options options, StringLiteral literal) {
  var content = literal.stringValue;
  var outputer = _CodeWriter(options);

  var hasInterpolation = false;
  if (content == null && literal is SingleStringLiteral) {
    var literalBuffer = StringBuffer();
    var interpolationEscaper = _InterpolationEscaper(
      literalBuffer,
      outputer.stringReplacements,
    );
    literal.accept(interpolationEscaper);
    var literalString = literalBuffer.toString();

    var openOffset = literal.contentsOffset - literal.offset;

    content = literalString.substring(
      openOffset,
      literalString.length - (literal.isMultiline ? 3 : 1),
    );
    hasInterpolation = interpolationEscaper.hasSeenInterpolation;
  } else if (literal is AdjacentStrings) {
    throw UnimplementedError();
  } else if (content == null) {
    throw UnimplementedError();
  }

  if (hasInterpolation) {
    var lowerContent = content.toLowerCase().trim();
    if (lowerContent.contains('<html ') || lowerContent.contains('<html>')) {
      var dom = parse(content);
      outputer.writeNode(dom);
    } else {
      var dom = parseFragment(content);
      outputer.writeNode(dom);
    }
  } else {
    outputer.writeLiteral(literal.toSource());
  }

  return outputer.output.toString();
}

class _InterpolationEscaper extends ToSourceVisitor {
  final Map<String, String> stringReplacements;
  int _index = 0;

  _InterpolationEscaper(super.sink, this.stringReplacements);

  @override
  void visitInterpolationExpression(InterpolationExpression node) {
    var original = StringBuffer();
    node.expression.accept(ToSourceVisitor(original));

    var alias = 'escapehtmltag${_index++}thisstringcannothappeninrealcode';

    stringReplacements[alias] = original.toString();
    sink.write(alias);
  }

  bool get hasSeenInterpolation => _index > 0;
}

class _CodeWriter {
  static final _hasNonWhitespace = RegExp(r'\S');
  final stringReplacements = <String, String>{};
  final Options options;
  final output = StringBuffer();

  _CodeWriter(this.options);

  void writeNode(Node node, {bool? skipEmptyText}) {
    if (node is Text) {
      _writeText(node, skipEmptyText: skipEmptyText);
    } else if (node is DocumentType) {
      _writeDocumentType(node);
    } else if (node is Document) {
      _writeDocument(node);
    } else if (node is DocumentFragment) {
      _writeDocumentFragment(node);
    } else if (node is html.Comment) {
      _writeComment(node);
    } else if (node is Element) {
      _writeElement(node);
    } else {
      assert(false, 'Unknown type ${node.runtimeType}');
    }
  }

  void writeLiteral(String content) {
    output.writeln("\$.writeln($content);");
  }

  String _withInterpolation(
    String data, {
    String Function(String)? transformer,
  }) {
    for (var replacementEntry in stringReplacements.entries) {
      var replacement = replacementEntry.value;
      if (transformer != null) {
        replacement = transformer(replacement);
      }
      data = data.replaceAllMapped(
        replacementEntry.key,
        (_) => '\${$replacement}',
      );
    }
    return data;
  }

  void _writeText(Text node, {bool? skipEmptyText}) {
    skipEmptyText ??= false;

    var shouldEscape = true;
    final parent = node.parentNode;
    if (parent is Element) {
      var tag = parent.localName;
      if (rcdataElements.contains(tag) || tag == 'plaintext') {
        shouldEscape = false;
      }
    }

    var text = node.data;
    if ((skipEmptyText || options.skipWhitespaces) &&
        !_hasNonWhitespace.hasMatch(text)) {
      return;
    }
    var quote = "'";
    if (text.contains('\n')) {
      if (_hasNonWhitespace.hasMatch(text)) {
        quote = "'''";
      } else {
        text = text.replaceAll('\n', '\\n').replaceAll('\r', '\\r');
      }
    }

    if (shouldEscape) {
      text = htmlSerializeEscape(text);
    }
    if (quote == "'") {
      text = text.replaceAll("'", r"\'");
    }

    text = _withInterpolation(
      text,
      transformer: shouldEscape ? (s) => 'TrustedHtml.escape($s)' : null,
    );

    output.writeln('\$.write($quote$text$quote);');
  }

  void _writeComment(html.Comment comment) {
    output.writeln(
      "\$.writeln('''<!-- ${_withInterpolation(comment.data ?? '', transformer: (s) => 'TrustedHtml.escape($s)')} -->''');",
    );
  }

  void _writeDocumentType(DocumentType documentType) {
    output.write(
      "\$.writeln('${_withInterpolation(documentType.toString())}');",
    );
  }

  void _writeDocumentFragment(DocumentFragment documentFragment) {
    for (var child in documentFragment.nodes) {
      writeNode(child);
    }
  }

  void _writeDocument(Document document) {
    for (var child in document.nodes) {
      writeNode(child);
    }
  }

  void _writeElement(Element element) {
    var attributes = Attributes(
      element.attributes.cast<Object, String>(),
      stringReplacements: stringReplacements,
    );

    var isText = element.localName == 'text';

    var open =
        '<${_getSerializationPrefix(element.namespaceUri)}${_withInterpolation(element.localName ?? 'unknown')}${attributes.toCode()}>';

    Iterable<StructuralAttribute> structurals({bool enclose = true}) =>
        attributes.structurals.where((s) => s.encloseTag == enclose);

    structurals(enclose: true).forEach((a) => output.writeln(a.openStructure));

    if (!isText) {
      output.writeln("\$.write('$open');");
    }

    structurals(enclose: false).forEach((a) => output.writeln(a.openStructure));

    if (element.nodes.isNotEmpty) {
      if (const ['pre', 'textarea', 'listing'].contains(element.localName)) {
        final first = element.nodes[0];
        if (first is Text && first.data.startsWith('\n')) {
          // These nodes will remove a leading \n at parse time, so if we still
          // have one, it means we started with two. Add it back.
          output.write("\$.write('\\n');");
        }
      }

      var isSwitch = attributes.structurals.any((a) => a is SwitchAttribute);
      for (var child in element.nodes) {
        writeNode(child, skipEmptyText: isSwitch);
      }
    }

    structurals(
      enclose: false,
    ).forEach((a) => output.writeln(a.closeStructure));

    if (!isText && !isVoidElement(element.localName)) {
      output.write(
        "\$.write('</${_withInterpolation(element.localName ?? 'unknown')}>');",
      );
    }

    structurals(enclose: true).forEach((a) => output.writeln(a.closeStructure));
  }
}

String _getSerializationPrefix(String? uri) {
  if (uri == null ||
      uri == Namespaces.html ||
      uri == Namespaces.mathml ||
      uri == Namespaces.svg) {
    return '';
  }
  var prefix = Namespaces.getPrefix(uri);
  return prefix == null ? '' : '$prefix:';
}
