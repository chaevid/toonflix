import 'package:flutter/material.dart';
import '../api.dart';
import '../models/movie.dart';
import './detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<List<Movie>> upcomingMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = MovieApi()
        .fetchMovies('https://movies-api.nomadcoders.workers.dev/popular');
    nowPlayingMovies = MovieApi()
        .fetchMovies('https://movies-api.nomadcoders.workers.dev/now-playing');
    upcomingMovies = MovieApi()
        .fetchMovies('https://movies-api.nomadcoders.workers.dev/coming-soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Intro App'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: popularMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildMovieList(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
              'https://image.tmdb.org/t/p/w500/' + movies[index].posterPath),
          title: Text(movies[index].title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(id: movies[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
