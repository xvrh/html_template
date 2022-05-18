import 'package:html_template/html_template.dart';

part 'condition.g.dart';

// ignore_for_file: unnecessary_statements

//---simple
@template
void _conditionExample({required bool someCondition}) async {
  '''  
  <!-- Conditionally include the <h2> tag -->
  <h2 *if="$someCondition">Condition on a tag</h2>
  
  <!-- Include the 'disabled' attribute if the condition is true -->
  <input [disabled]="$someCondition"/>
  
  <!-- Add 'my-class' CSS class if the condition is true -->
  <input [class.my-class]="$someCondition">
  
    <!-- Use any Dart expression for the condition -->
  <hr *if="${(await fetchData()).isEmpty}"/>
  ''';
}
//----

//---alt
@template
void _conditionAlt({required bool showMenu}) {
  '<h1>Title</h1>';

  if (!showMenu) {
    '<h2>Sub title</h2>';
  }
}
//---

Future<String> fetchData() async => '';
