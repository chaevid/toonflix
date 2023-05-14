import 'package:flutter/material.dart';
import 'package:toonflix/screens/home.dart';

void main() {
  runApp(const MovieIntroApp());
}

class MovieIntroApp extends StatelessWidget {
  const MovieIntroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Intro App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: HomeScreen(),
    );
  }
}
