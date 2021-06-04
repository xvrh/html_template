import 'package:html_template/html_template.dart';

part 'css_classes.g.dart';

// ignore_for_file: unnecessary_statements

//---classes
@template
void _cssClassesExample(List<Data> data, {bool showMenu = false}) {
  // Add classes based on condition
  '<li [class.active]="$showMenu" [class.enabled]="${data.isNotEmpty}">Actif</li>';

  // We can pass a Map<String, bool> to the [classes] attribute
  var myClasses = {'enabled': showMenu};
  '<a type="text" [classes]="$myClasses"></a>';
}
//----

class Data {
  String name = '';
}
