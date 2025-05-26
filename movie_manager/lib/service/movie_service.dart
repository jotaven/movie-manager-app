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

  Future<List<Movie>> listMovies() async {
    return await movieDao.getAllMovies();
  }
}
