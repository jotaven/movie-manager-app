import 'package:flutter/material.dart';
import 'package:movie_manager/view/movies_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes',
      debugShowCheckedModeBanner: false,
      home: const MoviesPage(),
    );
  }
}