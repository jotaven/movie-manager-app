import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_manager/data/dao/movie_dao_impl.dart';
import 'package:movie_manager/service/movie_service.dart';
import 'package:movie_manager/controller/movie_controller.dart';
import 'package:movie_manager/models/movie.dart';

import 'add_movie_page.dart';
import 'movie_details_page.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late final MovieController _movieController;
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _movieController = MovieController(
      movieService: MovieService(movieDao: MovieDaoImpl()),
    );
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movies = await _movieController.getAllMovies();
    setState(() {
      _movies = movies;
    });
  }

  void _showTeamModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Equipe:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Gustavo Targino'),
              const Text('João Pedro Soares'),
              const Text('João Victor Nunes'),
              const Text('Luiz Filipe'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _goToAddMovie() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoviePage(movieController: _movieController),
      ),
    );
    if (!mounted) return;

    if (result == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Filme inserido com sucesso')),
      );
      _loadMovies();
    }
  }

  Widget _buildMovieCard(Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsPage(movie: movie),
          ),
        );
      },
      child: SizedBox(
        width: 400,
        height: 200,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    movie.imageUrl,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 80),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.genre,
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${movie.durationInMinutes} min',
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Spacer(),
                      RatingBarIndicator(
                        rating: movie.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 28.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Filmes', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.info_outline, size: 18, color: Colors.deepPurple),
            ),
            onPressed: () => _showTeamModal(context),
            tooltip: 'Sobre a equipe',
          ),
        ],
      ),
      body: _movies.isEmpty
          ? const Center(child: Text('Nenhum filme cadastrado'))
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return Dismissible(
            key: Key(movie.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) async {
              final messenger = ScaffoldMessenger.of(context);
              await _movieController.deleteMovie(movie.id!);
              if (!mounted) return;
              messenger.showSnackBar(
                SnackBar(content: Text('Filme "${movie.title}" deletado')),
              );
              _loadMovies();
            },
            child: _buildMovieCard(movie),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddMovie,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        tooltip: 'Adicionar Filme',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}