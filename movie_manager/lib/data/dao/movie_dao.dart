import '../../models/movie.dart';

abstract class MovieDao {
  Future<Movie?> insertMovie(Movie movie);
  Future<List<Movie>> getAllMovies();
  Future<Movie?> getMovieById(int id);
  Future<Movie?> updateMovie(Movie movie);
  Future<int> deleteMovie(int id);
  Future<List<Movie>> searchMovies(String query);
}