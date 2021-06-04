import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/ast/to_source_visitor.dart';

class ToSourceVisitor2 extends ToSourceVisitor {
  ToSourceVisitor2(StringSink sink) : super(sink);

  @override
  void visitDefaultFormalParameter(DefaultFormalParameter node) {
    safelyVisitNode(node.parameter);
    if (node.separator != null) {
      if (node.separator!.lexeme != ":") {
        sink.write(" ");
      }
      sink.write(node.separator!.lexeme);
      safelyVisitNodeWithPrefix(" ", node.defaultValue);
    }
  }

  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    safelyVisitNodeListWithSeparatorAndSuffix(node.metadata, ' ', ' ');
    if (node.isRequiredNamed) {
      sink.write('required ');
    }
    safelyVisitTokenWithSuffix(node.covariantKeyword, ' ');
    safelyVisitTokenWithSuffix(node.keyword, " ");
    safelyVisitNode(node.type);
    if (node.type != null && node.identifier != null) {
      sink.write(' ');
    }
    safelyVisitNode(node.identifier);
  }
}
