import 'dart:developer';

import 'package:flutter/material.dart';

import '../api.dart';
import '../models/movie.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  final api = MovieApi();

  DetailScreen({Key? key, required this.id}) : super(key: key);

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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text('Back to list'),
              titleTextStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 0.95],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 140),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star_rounded,
                            color: index < movie.voteAverage ~/ 2
                                ? Colors.yellow
                                : Colors.white54,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          const Text(
                            '2h 14min | ',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          Text(
                            movie.genres.map((genre) => genre.name).join(', '),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Storyline',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(movie.overview,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 24,
                  right: 24,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.yellow[600],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        log('Button : Buy Ticket');
                      },
                      child: const Text(
                        'Buy Ticket',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
