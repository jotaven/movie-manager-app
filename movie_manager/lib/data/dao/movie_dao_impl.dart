import '../../models/movie.dart';
import '../database_helper.dart';
import 'movie_dao.dart';
import 'package:flutter/foundation.dart';

class MovieDaoImpl implements MovieDao {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<Movie?> insertMovie(Movie movie) async {
    final db = await dbHelper.database;

    try {
      final id = await db.insert(
        DatabaseHelper.tableMovies,
        movie.toMap()..remove('id'),
      );

      return movie.copyWith(id: id);
    } catch (e) {
      debugPrint('Erro ao inserir filme: $e');
      return null;
    }
  }

  @override
  Future<List<Movie>> getAllMovies() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableMovies);

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  @override
  Future<Movie?> getMovieById(int id) async {
    throw UnimplementedError("getMovieById() is not implemented");
  }

  @override
  Future<int> updateMovie(Movie movie) async {
    throw UnimplementedError("updateMovie() is not implemented");
  }

  @override
  Future<int> deleteMovie(int id) async {
    throw UnimplementedError("deleteMovie() is not implemented");

  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    throw UnimplementedError("searchMovies() is not implemented");

  }
}
