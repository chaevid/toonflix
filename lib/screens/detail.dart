import 'package:flutter/material.dart';

import '../api.dart';
import '../models/movie.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  final api = MovieApi();

  DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: api.fetchMovieDetails(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Movie movie = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(movie.title),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: 200,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < movie.voteAverage ~/ 2
                              ? Colors.yellow
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(movie.overview),
                    SizedBox(height: 16.0),
                    Text(
                      'Genres: ' +
                          movie.genres.map((genre) => genre.name).join(', '),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
