// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_literals.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

@GenerateFor(_movieTemplate)
Future<TrustedHtml> movieTemplate() async {
  var $ = StringBuffer();

  $.write('<h1>');
  $.write('My movies');
  $.write('</h1>');
  var page = await fetchPage();
  if (!page.isLoggedIn) {
    $.write('<h2>');
    $.write('Log in');
    $.write('</h2>');
  } else {
    $.write('<ul>');
    $.write('</ul>');
    for (var movie in page.myMovies) {
      $.write('<li${template.classAttribute({'favorite': movie.isFavorite})}>');
      $.write('${TrustedHtml.escape(movie)}');
      $.write('</li>');
    }
  }
  $.write('<footer>');
  $.write('Footer');
  $.write('</footer>');

  return TrustedHtml($.toString());
}
