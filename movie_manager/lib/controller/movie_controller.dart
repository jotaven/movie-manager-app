import '../../models/movie.dart';
import '../service/movie_service.dart';

class MovieController {
  final MovieService movieService;

  MovieController({required this.movieService});

  Future<Movie?> addMovie(Movie movie) async {
    return await movieService.addMovie(movie);
  }

  Future<List<Movie>> getAllMovies() async {
    return await movieService.listMovies();
  }

  Future<void> deleteMovie(int id) async {
    await movieService.deleteMovie(id);
  }

}


