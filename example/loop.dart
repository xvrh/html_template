

import 'package:html_template/html_template.dart';

part 'loop.g.dart';

//====
@template
_myTemplate(List<MenuEntry> menu) {
  MenuEntry entry;
  '''
  <ul>
    <li *for="$entry in $menu">
      ${entry.title}
    </li>
  </ul>
  ''';
}
//=====

class MenuEntry {
  String get title => '';

  List<String> get icons => [];
}
