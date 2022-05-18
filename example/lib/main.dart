import 'package:html_template/html_template.dart';
import 'package:shelf/shelf.dart';

part 'main.g.dart';

// ignore_for_file: unnecessary_statements

//---- full_example
//+import 'package:html_template/html_template.dart';

//+part 'main.g.dart';

@template
void _productTemplate(Product product) {
  '''
  <img *if="${product.icon != null}" src="${product.icon}" />
  <h1 [class.new]="${product.isNew}">$product</h1>
  ''';
}

@template
void _pageTemplate(Product product, {List<String>? scripts}) {
  var script = '';
  '<!doctype html>';
  '''
<html lang="${Language.current}">
  <head>
    <title>${product.name} - My site</title>
    <script *for="$script in $scripts" src="$script" async></script>
  </head>
  <body>
    ${productTemplate(product)}
  </body>
</html>
  ''';
}
//-----

class Product {
  bool get isNew => false;
  String? get icon => '';
  String get name => '';
}

class Language {
  static String get current => '';
}

String escapeAttribute(String s) => '';
String escapeHtml(String s) => '';

final Router router = Router();
final Database database = Database();
Object params(dynamic request, dynamic id) => '';
//---- usage
void main() {
  router.get('/products/<id>', (request) async {
    var product = await database.findProduct(params(request, 'id'));

    // Create the html for the response from the Product of your database
    var html = pageTemplate(product);

    return Response.ok(html, headers: {'content-type': 'text/html'});
  });
}
//----

class Router {
  void get(String route, Future<dynamic> Function(Object) callback) {}
}

class Database {
  Future<Product> findProduct(Object o) async => Product();
}
