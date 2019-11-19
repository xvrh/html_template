import 'package:analyzer/dart/ast/ast.dart';
import 'code_generator.dart';

import 'package:analyzer/src/dart/ast/to_source_visitor.dart';

final _interpolationExtractor =
    RegExp(r'^\$\{(.+)\}$|^\$([a-z_\$][a-z0-9_\$]*)?$', caseSensitive: false);

String extractInterpolation(String code) {
  var match = _interpolationExtractor.firstMatch(code);
  if (match == null) {
    throw GeneratorException('Invalid interpolation: $code');
  }
  return match.group(1) ?? match.group(2);
}

/*
String escapeInterpolation(String outputCode,
    {bool isAttribute = false, bool isSingleQuote = false}) {
  var codeToParse = 'var _ = """$outputCode\n""";';

  var parsedCode = parseString(content: codeToParse, throwIfDiagnostics: false);
  if (parsedCode.errors.isNotEmpty) {
    throw throw GeneratorException(
        'Invalid code for: $outputCode\n ${parsedCode.errors}');
  }
  var unit = parsedCode.unit;
  var variableDeclaration =
      unit.declarations.first as TopLevelVariableDeclaration;

  var stringLiteral = variableDeclaration.variables.variables.first.initializer
      as SingleStringLiteral;

  if (stringLiteral.stringValue != null) {
    var code = stringLiteral.toString();
    return code.substring(3, code.length - 4).replaceAll("'", r"\'");
  } else {
    String escapeFunction = 'TrustedHtml.escape';
    if (isAttribute) {
      escapeFunction += '.attribute${isSingleQuote ? 'SingleQuote' : ''}';
    }

    var outputBuffer = StringBuffer();
    var printer = _Printer(outputBuffer, escapeFunction);
    stringLiteral.visitChildren(printer);

    var code = outputBuffer.toString();
    return code.substring(3, code.length - 4);
  }
}
*/
class _Printer extends ToSourceVisitor {
  final String escapeFunction;

  _Printer(StringSink sink, this.escapeFunction) : super(sink);

  @override
  void visitInterpolationExpression(InterpolationExpression node) {
    sink.write("\${");
    sink.write('$escapeFunction(');
    safelyVisitNode(node.expression);
    sink.write(")}");
  }

  void visitInterpolationString(InterpolationString node) {
    var content = node.contents.lexeme.replaceAll("'", r"\'");
    sink.write(content);
  }
}
