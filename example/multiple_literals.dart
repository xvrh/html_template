
import 'package:html_template/html_template.dart';

part 'multiple_literals.g.dart';

@template
_myTemplate(List<Data> data, {bool showMenu}) {
  '<h1>Title</h1>';

  if (!showMenu) {
    '<h2>Sub title</h2>';
  } else {
    Data item;
    '''
    <ul>
      <li *for="$item in $data">$item</li>
    </ul>
    ''';
  }
  '<footer>Footer</footer>';
}

class Data {}
