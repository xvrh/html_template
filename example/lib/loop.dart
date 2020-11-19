import 'package:html_template/html_template.dart';

part 'loop.g.dart';

// ignore_for_file: unnecessary_statements

//---loop
@template
void _simpleLoop(List<MenuItem> menu) {
  MenuItem item;
  '''
  <ul>
    <li *for="$item in $menu">
      ${item.title}
    </li>
  </ul>
  ''';
}
//----

//---loop_alt
@template
void _alternativeLoop(List<MenuItem> menu) {
  '<ul>';
  for (var item in menu) {
    '<li>${item.title}</li>';
  }
  '</ul>';
}
//----

class MenuItem {
  String get title => '';

  List<String> get icons => [];
}
