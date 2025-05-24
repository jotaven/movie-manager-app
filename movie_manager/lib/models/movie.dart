import 'package:flutter/foundation.dart';
import 'age_rating.dart';

@immutable // sim, imutavel a instância não pode ter seus campos alterados durante uma operação do CRUD.
class Movie {
  final int? id; // `?` pq voce pode ou não precisar informar o id dependendo da operação do CRUD.
  final String imageUrl;
  final String title;
  final String genre;
  final AgeRating ageRating; // usa o Enum
  final int durationInMinutes;
  final double rating;
  final String description;
  final int year;

  const Movie({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.genre,
    required this.ageRating,
    required this.durationInMinutes,
    required this.rating,
    required this.description,
    required this.year,
  }) : assert(durationInMinutes >= 0, 'Duração não pode ser negativa'),
        assert(rating >= 0 && rating <= 5, 'Score deve estar entre 0 e 10');

  String get displayDuration {
    final int hours = durationInMinutes ~/ 60;
    final int minutes = durationInMinutes % 60;
    if (hours > 0) {
      if (minutes > 0) {
        return "${hours}h ${minutes}min";
      }
      return "${hours}h";
    }
    return "${minutes}min";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'genre': genre,
      'ageRating': ageRating.toDbValue,
      'duration': durationInMinutes,
      'rating': rating,
      'description': description,
      'year': year,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int?,
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      genre: map['genre'] as String,
      ageRating: AgeRating.fromDbValue(map['ageRating'] as String),
      durationInMinutes: map['duration'] as int,
      rating: map['rating'] as double,
      description: map['description'] as String,
      year: map['year'] as int,
    );
  }

  Movie copyWith({
    int? id,
    String? imageUrl,
    String? title,
    String? genre,
    AgeRating? ageRating,
    int? durationInMinutes,
    double? rating,
    String? description,
    int? year,
  }) {
    return Movie(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      ageRating: ageRating ?? this.ageRating,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      year: year ?? this.year,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Movie &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title && 
              imageUrl == other.imageUrl &&
              genre == other.genre &&
              ageRating == other.ageRating &&
              durationInMinutes == other.durationInMinutes &&
              rating == other.rating &&
              description == other.description &&
              year == other.year;


  @override
  int get hashCode => Object.hash(
    id,
    imageUrl,
    title,
    genre,
    ageRating,
    durationInMinutes,
    rating,
    description,
    year,
  );

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, year: $year, ageRating: ${ageRating.displayValue}, duration: $displayDuration, rating: $rating}';
  }
}