import 'package:html_template/html_template.dart';

part 'switch.g.dart';

// ignore_for_file: unnecessary_statements

enum Season { spring, summer, autumn, winter }

//--- switch
@template
void _switchExample(Season season) {
  '''
<div *switch="$season">
  <span *case="${Season.summer}">Hot</span>
  <span *case="${Season.winter}">Cold</span>
  <div *default>Pleasant</div>
</div>
  ''';
}
//----
