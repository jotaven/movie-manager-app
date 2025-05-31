import '../../models/movie.dart';
import '../data/dao/movie_dao.dart';

class MovieService {
  final MovieDao movieDao;

  MovieService({required this.movieDao});

  Future<Movie?> addMovie(Movie movie) async {
    if (movie.title.isEmpty) {
      throw Exception('Título não pode ser vazio');
    }

    if (movie.durationInMinutes <= 0) {
      throw Exception('Duração deve ser maior que zero');
    }

    return await movieDao.insertMovie(movie);
  }

  Future<Movie?> updateMovie(Movie movie) async {
    if (movie.id == null) {
      throw Exception('ID do filme não pode ser nulo');
    }

    if (movie.title.isEmpty) {
      throw Exception('Título não pode ser vazio');
    }

    if (movie.durationInMinutes <= 0) {
      throw Exception('Duração deve ser maior que zero');
    }

    return await movieDao.updateMovie(movie);
  }

  Future<List<Movie>> listMovies() async {
    return await movieDao.getAllMovies();
  }

  Future<void> deleteMovie(int id) async {
    await movieDao.deleteMovie(id);
  }
}
