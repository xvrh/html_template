import 'package:html_template/html_template.dart';
import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';

part 'main.g.dart';

class Product {
  bool get isNew => false;
  String get icon => '';
}

class Language {
  static String get current => '';
}

String escapeAttribute( s) => '';
String escapeHtml( s) => '';

//==== 1
@template
void _productTemplate(Product product) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <h1 [class.new]="${product.isNew}">$product</h1>
  ''';
}

@template
void _masterTemplate({@required TrustedHtml body, String title, List<String> scripts}) {
  String script;
  '''
<!doctype html>
<html language="${Language.current}">
  <head>
    <title>$title - My site</title>
    <script *for="$script in $scripts" async></script>
  </head>
  <body>
    $body
  </body>
</html>
  ''';
}
//====== 1

final router = null;
final database = null;
params(request, id) => null;
//===== 2
main() {
  router.get('/products/<id>', (request) async {
    var product = await database.findProduct(params(request, 'id'));

    // Create the html for the response from the Product of your database
    var html = masterTemplate(body: productTemplate(product), title: product.name);

    return Response.ok(html, headers: {'content-type': 'text/html'});
  });
}
//===== 2
