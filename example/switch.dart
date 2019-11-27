

import 'package:html_template/html_template.dart';

part 'switch.g.dart';

enum Season {spring, summer, autumn, winter}

@template
_myTemplate(Season season) {
  '''
<div *switch="$season">
  <span *case="${Season.summer}">Hot</span>
  <span *case="${Season.winter}">Cold</span>
  <div *default>Neutral</div>
</div>
  ''';
}
