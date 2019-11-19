import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/generator.dart';

Builder templateBuilder(BuilderOptions options) {
  return SharedPartBuilder([
    TemplateGenerator(),
  ], 'template_builder');
}
