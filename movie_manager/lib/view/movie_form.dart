import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:movie_manager/models/age_rating.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/controller/movie_controller.dart';

class MovieForm extends StatefulWidget {
  final MovieController movieController;
  final Movie? movie;

  const MovieForm({
    super.key,
    required this.movieController,
    this.movie,
  });

  @override
  State<MovieForm> createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final movie = widget.movie;

    if (movie != null) {
      _titleController.text = movie.title;
      _genreController.text = movie.genre;
      _imageUrlController.text = movie.imageUrl;
      _durationController.text = movie.durationInMinutes.toString();
      _descriptionController.text = movie.description;
      _yearController.text = movie.year.toString();
      _selectedAgeRating = movie.ageRating;
      _rating = movie.rating;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _genreController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _selectYear() async {
    final currentYear = DateTime.now().year;
    final years = List.generate(150, (index) => currentYear + 5 - index); // 1900 até ano atual + 5

    final selectedYear = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: years.length,
          itemBuilder: (context, index) {
            final year = years[index];
            return ListTile(
              title: Text(year.toString()),
              onTap: () {
                Navigator.pop(context, year);
              },
            );
          },
        );
      },
    );

    if (selectedYear != null) {
      setState(() {
        _yearController.text = selectedYear.toString();
      });
    }
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate() && _selectedAgeRating != null) {
      final editedMovie = Movie(
        id: widget.movie?.id,
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
        if (widget.movie != null) {
          await widget.movieController.updateMovie(editedMovie);
        } else {
          await widget.movieController.addMovie(editedMovie);
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar filme: $e')),
          );
        }
      }
    } else if (_selectedAgeRating == null &&
        mounted &&
        _formKey.currentState?.validate() == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a classificação indicativa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie != null ? 'Editar Filme' : 'Cadastrar Filme'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                  value == null || value.isEmpty || int.tryParse(value) == null ? 'Informe uma duração válida' : null,
                ),
                GestureDetector(
                  onTap: _selectYear,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Ano de Lançamento'),
                      validator: (value) =>
                      value == null || value.isEmpty || int.tryParse(value) == null
                          ? 'Informe um ano válido'
                          : null,
                    ),
                  ),
                ),
                DropdownButtonFormField<AgeRating>(
                  decoration: const InputDecoration(labelText: 'Classificação Indicativa'),
                  value: _selectedAgeRating,
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
                    initialRating: _rating,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 32,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    }
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
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0),
                  )
                      : const Text('Salvar Filme'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
