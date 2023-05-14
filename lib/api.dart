import 'dart:convert';
import 'dart:io';
import 'models/movie.dart';

class MovieApi {
  final httpClient = HttpClient();

  Future<List<Movie>> fetchMovies(String url) async {
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final jsonString = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final List<dynamic> results = json['results'];
      return results.map<Movie>((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Error fetching movies');
    }
  }

  Future<Movie> fetchMovieDetails(int id) async {
    final request = await httpClient.getUrl(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/movie?id=$id'));
    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final jsonString = await response.transform(utf8.decoder).join();
      final json = jsonDecode(jsonString);
      return Movie.fromJson(json);
    } else {
      throw Exception('Error fetching movie details');
    }
  }
}
