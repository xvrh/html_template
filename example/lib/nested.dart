import 'package:html_template/html_template.dart';

part 'nested.g.dart';

// ignore_for_file: unnecessary_statements

//---nested
@template
void _myTemplate() {
  '''
  <h1>Images</h1>
  ${img('landscape.png')}
  ''';
}

@template
void _img(String url) {
  '<img src="$url">';
}

//----
