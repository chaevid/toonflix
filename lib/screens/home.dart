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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadlineText(headlineText: 'Popular Movies'),
              FutureBuilder<List<Movie>>(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HorizontalMovieList(
                      movies: snapshot.data!,
                      showTitle: false,
                      widthFactor: 0.8,
                      aspectRatio: 4 / 3,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const HeadlineText(headlineText: 'Now in Cinemas'),
              FutureBuilder<List<Movie>>(
                future: nowPlayingMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HorizontalMovieList(
                      movies: snapshot.data!,
                      showTitle: true,
                      widthFactor: 0.4,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const HeadlineText(headlineText: 'Coming Soon'),
              FutureBuilder<List<Movie>>(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HorizontalMovieList(
                      movies: snapshot.data!,
                      showTitle: true,
                      widthFactor: 0.4,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadlineText extends StatelessWidget {
  final String headlineText;

  const HeadlineText({
    super.key,
    required this.headlineText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          headlineText,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;
  final bool showTitle;
  final double widthFactor;
  final double? aspectRatio;

  const HorizontalMovieList({
    super.key,
    required this.movies,
    required this.showTitle,
    required this.widthFactor,
    this.aspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: movies.map((movie) {
          return Container(
            padding: const EdgeInsets.only(right: 16),
            width: MediaQuery.of(context).size.width * widthFactor,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(id: movie.id),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: aspectRatio!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  showTitle
                      ? Text(
                          movie.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
