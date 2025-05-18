enum AgeRating {
  livre,
  age10,
  age12,
  age14,
  age16,
  age18,
}

class Movie {
  final int? id;
  final String imageUrl;
  final String title;
  final String genre;
  final AgeRating ageRating;
  final int duration;
  final double rating;
  final String description;
  final int year;

  Movie({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.genre,
    required this.ageRating,
    required this.duration,
    required this.rating,
    required this.description,
    required this.year,
  }) : assert(rating >= 0 && rating <= 5, 'Avaliação deve ser entre 0 e 5');

  static String _ageRatingToString(AgeRating rating) {
    switch(rating) {
      case AgeRating.livre: return 'Livre';
      case AgeRating.age10: return '10';
      case AgeRating.age12: return '12';
      case AgeRating.age14: return '14';
      case AgeRating.age16: return '16';
      case AgeRating.age18: return '18';
    }
  }

  static AgeRating _stringToAgeRating(String str) {
    return AgeRating.values.firstWhere(
      (e) => _ageRatingToString(e) == str,
      orElse: () => AgeRating.livre,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'genre': genre,
      'ageRating': _ageRatingToString(ageRating),
      'duration': duration,
      'rating': rating,
      'description': description,
      'year': year,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      imageUrl: map['imageUrl'],
      title: map['title'],
      genre: map['genre'],
      ageRating: _stringToAgeRating(map['ageRating']),
      duration: map['duration'],
      rating: map['rating'],
      description: map['description'],
      year: map['year'],
    );
  }
}