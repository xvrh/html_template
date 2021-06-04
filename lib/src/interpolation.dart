import 'code_generator.dart';

final _interpolationExtractor =
    RegExp(r'^\$\{(.+)\}$|^\$([a-z_\$][a-z0-9_\$]*)?$', caseSensitive: false);

String extractInterpolation(String code) {
  var match = _interpolationExtractor.firstMatch(code);
  if (match == null) {
    throw GeneratorException('Invalid interpolation: $code');
  }
  return match.group(1) ?? match.group(2) ?? '';
}
