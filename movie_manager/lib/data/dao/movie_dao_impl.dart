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
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableMovies, orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  @override
  Future<Movie?> getMovieById(int id) async {
    throw UnimplementedError("getMovieById() is not implemented");
  }

  @override
  Future<Movie?> updateMovie(Movie movie) async {
    final db = await dbHelper.database;

    try {
      final rowsAffected = await db.update(
        DatabaseHelper.tableMovies,
        movie.toMap(),
        where: 'id = ?',
        whereArgs: [movie.id],
      );

      if (rowsAffected > 0) {
        return movie;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao atualizar filme: $e');
      return null;
    }
  }

  @override
  Future<int> deleteMovie(int id) async {
    final db = await dbHelper.database;

    try {
      return await db.delete(
        DatabaseHelper.tableMovies,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Erro ao deletar filme: $e');
      return 0;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    throw UnimplementedError("searchMovies() is not implemented");
  }
}
