import 'package:flutter/material.dart';
import 'package:movie_manager/data/dao/movie_dao_impl.dart';
import 'package:movie_manager/service/movie_service.dart';
import 'package:movie_manager/ui/add_movie_page.dart';
import 'package:movie_manager/controller/movie_controller.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late final MovieController _movieController;

  @override
  void initState() {
    super.initState();
    _movieController = MovieController( movieService: MovieService(movieDao: MovieDaoImpl()));
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

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Filme inserido com sucesso')),
      );
    }
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
      body: const Center(
        child: Text('Cards...'),
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