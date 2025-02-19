import 'code_generator.dart';

final _interpolationExtractor = RegExp(
  r'^\$\{(.+)\}$|^\$([a-z_$][a-z\d_$]*)?$',
  caseSensitive: false,
);

String extractInterpolation(String code) {
  var match = _interpolationExtractor.firstMatch(code);
  if (match == null) {
    throw GeneratorException('Invalid interpolation: $code');
  }
  return match.group(1) ?? match.group(2) ?? '';
}

String removeBang(String variable) {
  if (variable.endsWith('!')) {
    return variable.substring(0, variable.length - 1);
  }
  return variable;
}
