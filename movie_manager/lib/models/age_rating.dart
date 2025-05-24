import 'package:flutter/foundation.dart';

enum AgeRating {
  LIVRE("Livre", 0),
  DEZ("10+", 10),
  DOZE("12+", 12),
  CATORZE("14+", 14),
  DEZESSEIS("16+", 16),
  DEZOITO("18+", 18);

  final String displayValue; // how appears in UI
  final int minimumAge;     // minimum age that correspond

  const AgeRating(this.displayValue, this.minimumAge);

  // method to convert a string (from db) to a enum | use later
  static AgeRating fromDbValue(String dbValue) {
    for (var rating in values) {
      if (rating.displayValue.toLowerCase() == dbValue.toLowerCase() ||
          rating.name.toLowerCase() == dbValue.toLowerCase()) {
        return rating;
      }
    }
    debugPrint("Valor de AgeRating não reconhecido do DB: '$dbValue'. Usando LIVRE como padrão.");
    return AgeRating.LIVRE;
  }

  // get the value to be stored into db
  String get toDbValue => name;
}