import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_manager/controller/movie_controller.dart';
import 'package:movie_manager/data/dao/movie_dao_impl.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/service/movie_service.dart';
import 'movie_form.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color? subtleTextColor = Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieForm(
                    movieController: MovieController(
                      movieService: MovieService(movieDao: MovieDaoImpl()),
                    ),
                    movie: movie,
                  ),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true); // retorna com sinal de que foi editado
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  movie.imageUrl,
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200,
                    height: 300,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image_outlined,
                        size: 80, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie.genre,
                        style: textTheme.bodyLarge
                            ?.copyWith(color: subtleTextColor, fontSize: 15),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        movie.displayDuration,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: subtleTextColor, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      movie.year.toString(),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: subtleTextColor, fontSize: 15),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      movie.ageRating.displayValue,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: subtleTextColor, fontSize: 15),
                    ),
                    const SizedBox(height: 8.0),
                    RatingBarIndicator(
                      rating: movie.rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Text(
              'Sinopse',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              movie.description.isNotEmpty
                  ? movie.description
                  : 'Sem descrição disponível.',
              style: textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
