import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'annotation.dart';
import 'code_generator.dart';

class TemplateGenerator extends GeneratorForAnnotation<TemplateAnnotation> {
  const TemplateGenerator();

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! FunctionElement || !element.isPrivate) {
      throw InvalidGenerationSourceError(
        '@Template() could only be applied on private functions',
        element: element,
      );
    }

    var functionDeclaration = _extractFunctionDeclaration(
      element.source.contents.data,
      functionName: element.name,
    );

    try {
      var code = generateCodeFromFunction(functionDeclaration);
      code = '''
// ignore_for_file: duplicate_ignore
// ignore_for_file: unused_local_variable
// ignore_for_file: unnecessary_string_interpolations
$code      
''';
      return code;
    } on GeneratorException catch (e) {
      throw InvalidGenerationSourceError(e.message, element: element);
    }
  }
}

FunctionDeclaration _extractFunctionDeclaration(
  String fileContent, {
  required String functionName,
}) {
  var parsed = parseString(content: fileContent);
  if (parsed.errors.isNotEmpty) {
    throw Exception(parsed.errors.toString());
  }
  var unit = parsed.unit;

  return unit.declarations.whereType<FunctionDeclaration>().firstWhere(
    (d) => d.name.toString() == functionName,
  );
}
