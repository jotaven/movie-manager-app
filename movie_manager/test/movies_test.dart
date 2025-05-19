import 'package:flutter_test/flutter_test.dart';
import 'package:movie_manager/models/movie.dart';

void main() {
  group('AgeRating', () {
    test('ageRatingToString retorna string correta', () {
      expect(Movie.ageRatingToString(AgeRating.livre), 'Livre');
      expect(Movie.ageRatingToString(AgeRating.age10), '10');
      expect(Movie.ageRatingToString(AgeRating.age12), '12');
      expect(Movie.ageRatingToString(AgeRating.age14), '14');
      expect(Movie.ageRatingToString(AgeRating.age16), '16');
      expect(Movie.ageRatingToString(AgeRating.age18), '18');
    });

    test('stringToAgeRating converte corretamente', () {
      expect(Movie.stringToAgeRating('Livre'), AgeRating.livre);
      expect(Movie.stringToAgeRating('10'), AgeRating.age10);
      expect(Movie.stringToAgeRating('12'), AgeRating.age12);
      expect(Movie.stringToAgeRating('14'), AgeRating.age14);
      expect(Movie.stringToAgeRating('16'), AgeRating.age16);
      expect(Movie.stringToAgeRating('18'), AgeRating.age18);
      expect(Movie.stringToAgeRating('invalid'), AgeRating.livre); // Teste default
    });
  });

  group('Movie', () {
    var mockMovie = Movie(
      id: 1,
      imageUrl: 'image.jpg',
      title: 'Title',
      genre: 'Action',
      ageRating: AgeRating.age12,
      duration: 120,
      rating: 4.5,
      description: 'Description',
      year: 2024,
    );

    test('construtor valida rating entre 0 e 5', () {
      expect(() => Movie(
        imageUrl: 'image.jpg',
        title: 'Title',
        genre: 'Action',
        ageRating: AgeRating.livre,
        duration: 120,
        rating: -0.1,
        description: 'Description',
        year: 2024,
      ), throwsA(isA<AssertionError>()));

      expect(() => Movie(
        imageUrl: 'image.jpg',
        title: 'Title',
        genre: 'Action',
        ageRating: AgeRating.livre,
        duration: 120,
        rating: 5.1,
        description: 'Description',
        year: 2024,
      ), throwsA(isA<AssertionError>()));
    });

    test('toMap converte corretamente', () {
      final map = mockMovie.toMap();

      expect(map, {
        'id': 1,
        'imageUrl': 'image.jpg',
        'title': 'Title',
        'genre': 'Action',
        'ageRating': '12',
        'duration': 120,
        'rating': 4.5,
        'description': 'Description',
        'year': 2024,
      });
    });

    test('fromMap reconstrói corretamente', () {
      final map = {
        'id': 2,
        'imageUrl': 'image2.jpg',
        'title': 'Title 2',
        'genre': 'Drama',
        'ageRating': '18',
        'duration': 150,
        'rating': 4.8,
        'description': 'Another description',
        'year': 2023,
      };

      final movie = Movie.fromMap(map);

      expect(movie.id, 2);
      expect(movie.imageUrl, 'image2.jpg');
      expect(movie.title, 'Title 2');
      expect(movie.genre, 'Drama');
      expect(movie.ageRating, AgeRating.age18);
      expect(movie.duration, 150);
      expect(movie.rating, 4.8);
      expect(movie.description, 'Another description');
      expect(movie.year, 2023);
    });

    test('fromMap com id nulo', () {
      final map = {
        'imageUrl': 'image3.jpg',
        'title': 'Title 3',
        'genre': 'Comedy',
        'ageRating': '14',
        'duration': 90,
        'rating': 3.7,
        'description': 'Comedy description',
        'year': 2022,
      };

      final movie = Movie.fromMap(map);

      expect(movie.id, isNull);
      expect(movie.ageRating, AgeRating.age14);
    });
  });
}