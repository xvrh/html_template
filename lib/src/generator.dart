import 'code_generator.dart';

import 'annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:meta/meta.dart';

class TemplateGenerator extends GeneratorForAnnotation<TemplateAnnotation> {
  const TemplateGenerator();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! FunctionElement || !element.isPrivate) {
      throw InvalidGenerationSourceError(
          '@Template() could only be applied on private functions',
          element: element);
    }

    FunctionElement function = element;
    var functionDeclaration = _extractFunctionDeclaration(
        function.source.contents.data,
        functionName: function.name);

    try {
      return generateCodeFromFunction(functionDeclaration);
    } on GeneratorException catch (e) {
      throw InvalidGenerationSourceError(e.message, element: element);
    }
  }
}

FunctionDeclaration _extractFunctionDeclaration(String fileContent,
    {@required String functionName, String className}) {
  var parsed = parseString(content: fileContent);
  if (parsed.errors.isNotEmpty) {
    throw Exception(parsed.errors.toString());
  }
  var unit = parsed.unit;

  // TODO(xha): trouver dans les classes imbriquées

  return unit.declarations
      .whereType<FunctionDeclaration>()
      .firstWhere((d) => d.name.name == functionName);
}
