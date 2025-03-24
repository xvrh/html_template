// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_literals.dart';

// **************************************************************************
// TemplateGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_function_declarations_over_variables
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unnecessary_string_interpolations
// ignore_for_file: unused_local_variable
@GenerateFor(_movieTemplate)
Future<TrustedHtml> movieTemplate() async {
  var $ = StringBuffer();

  $.writeln('<h1>My movies</h1>');

  var page = await fetchPage();
  if (!page.isLoggedIn) {
    $.writeln('<h2>Log in</h2>');
  } else {
    $.writeln('<ul>');

    for (var movie in page.myMovies) {
      $.write('<li${template.classAttribute({'favorite': movie.isFavorite})}>');
      $.write('${TrustedHtml.escape(movie)}');
      $.write('</li>');
    }
    $.writeln('</ul>');
  }
  $.writeln('<footer>Footer</footer>');

  return TrustedHtml($.toString());
}
