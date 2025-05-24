import 'package:flutter_test/flutter_test.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/models/age_rating.dart';

void main() {
  group('Movie', () {
    final movie = Movie(
      id: 1,
      imageUrl: 'https://example.com/image.jpg',
      title: 'Inception',
      genre: 'Sci-Fi',
      ageRating: AgeRating.fourteen,
      durationInMinutes: 148,
      rating: 4.5,
      description: 'A mind-bending thriller.',
      year: 2010,
    );

    test('displayDuration should format duration correctly', () {
      expect(movie.displayDuration, '2h 28min');
    });

    test('copyWith should create a copy with updated values', () {
      final copy = movie.copyWith(title: 'Interstellar');
      expect(copy.title, 'Interstellar');
      expect(copy.genre, movie.genre); // unchanged
    });

    test('toMap should convert Movie to Map correctly', () {
      final map = movie.toMap();
      expect(map['id'], 1);
      expect(map['imageUrl'], 'https://example.com/image.jpg');
      expect(map['title'], 'Inception');
      expect(map['genre'], 'Sci-Fi');
      expect(map['ageRating'], 'fourteen'); // ← enum.toDbValue
      expect(map['duration'], 148);
      expect(map['rating'], 4.5);
      expect(map['description'], 'A mind-bending thriller.');
      expect(map['year'], 2010);
    });

    test('fromMap should create Movie from Map correctly', () {
      final map = {
        'id': 1,
        'imageUrl': 'https://example.com/image.jpg',
        'title': 'Inception',
        'genre': 'Sci-Fi',
        'ageRating': 'fourteen', // ← dbValue usado no teste
        'duration': 148,
        'rating': 4.5,
        'description': 'A mind-bending thriller.',
        'year': 2010,
      };

      final fromMapMovie = Movie.fromMap(map);
      expect(fromMapMovie, movie); // relies on == operator
    });

    test('== operator should compare correctly', () {
      final anotherMovie = Movie(
        id: 1,
        imageUrl: 'https://example.com/image.jpg',
        title: 'Inception',
        genre: 'Sci-Fi',
        ageRating: AgeRating.fourteen,
        durationInMinutes: 148,
        rating: 4.5,
        description: 'A mind-bending thriller.',
        year: 2010,
      );

      expect(anotherMovie == movie, true);
    });
  });
}
