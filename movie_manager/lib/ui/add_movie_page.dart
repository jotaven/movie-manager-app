import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:movie_manager/models/age_rating.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/controller/movie_controller.dart';

class AddMoviePage extends StatefulWidget {
  final MovieController movieController;

  const AddMoviePage({super.key, required this.movieController});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();

  AgeRating? _selectedAgeRating;
  double _rating = 0.0;

  bool _isSaving = false;

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate() && _selectedAgeRating != null) {
      final movie = Movie(
        title: _titleController.text,
        genre: _genreController.text,
        imageUrl: _imageUrlController.text,
        durationInMinutes: int.parse(_durationController.text),
        rating: _rating,
        description: _descriptionController.text,
        year: int.parse(_yearController.text),
        ageRating: _selectedAgeRating!,
      );

      setState(() {
        _isSaving = true;
      });

      try {
        final savedMovie = await widget.movieController.addMovie(movie);
        Navigator.pop(context, true);
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar filme: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Filme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Gênero'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o gênero' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a URL da imagem' : null,
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duração (min)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || int.tryParse(value) == null ? 'Informe uma duração válida' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Ano de Lançamento'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || int.tryParse(value) == null ? 'Informe um ano válido' : null,
              ),
              DropdownButtonFormField<AgeRating>(
                decoration: const InputDecoration(labelText: 'Classificação Indicativa'),
                items: AgeRating.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.displayValue),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAgeRating = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione a classificação indicativa' : null,
              ),
              const SizedBox(height: 16),
              const Text('Avaliação (0 a 5 estrelas):'),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32,
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => _rating = rating,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveMovie,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar Filme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}