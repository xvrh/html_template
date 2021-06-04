import 'package:html_template/html_template.dart';

part 'multiple_literals.g.dart';

// ignore_for_file: unnecessary_statements

//---complex
@template
void _movieTemplate() async {
  '<h1>My movies</h1>';

  var page = await fetchPage();
  if (!page.isLoggedIn) {
    '<h2>Log in</h2>';
  } else {
    '<ul>';
    for (var movie in page.myMovies) {
      '<li [class.favorite]="${movie.isFavorite}">$movie</li>';
    }
    '</ul>';
  }
  '<footer>Footer</footer>';
}
//----

class Data {
  bool get isFavorite => false;
}

class Data2 {
  bool get isLoggedIn => false;
  List<Data> get myMovies => [];
}

Future<Data2> fetchPage() async => Data2();

Future<List<Data>> fetchData() async => [];
