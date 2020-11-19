import 'package:html_template/html_template.dart';

part 'multiple_literals.g.dart';

// ignore_for_file: unnecessary_statements

//---complex
@template
void _myTemplate() async {
  '<h1>Title</h1>';

  var myPage = buildPage();
  if (!myPage.hasData) {
    '<h2>Sub title</h2>';
  } else {
    var data = await fetchData();
    Data item;
    '''
    <ul>
      <li *for="$item in $data">$item</li>
    </ul>
    ''';
  }
  '<footer>Footer</footer>';
}
//----

class Data {}

class Data2 {
  bool get hasData => false;
}

Data2 buildPage() => Data2();

Future<List<Data>> fetchData() => null;
