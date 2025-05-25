import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {

  static const _databaseName = "MovieDatabase.db";
  static const _databaseVersion = 1;

  static const tableMovies = 'movies';

  static const columnId = 'id';
  static const columnImageUrl = 'imageUrl';
  static const columnTitle = 'title';
  static const columnGenre = 'genre';
  static const columnAgeRating = 'ageRating';
  static const columnDuration = 'duration';
  static const columnRating = 'rating';
  static const columnDescription = 'description';
  static const columnYear = 'year';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableMovies (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnImageUrl TEXT NOT NULL,
            $columnTitle TEXT NOT NULL,
            $columnGenre TEXT NOT NULL,
            $columnAgeRating TEXT NOT NULL,
            $columnDuration INTEGER NOT NULL,
            $columnRating REAL NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnYear INTEGER NOT NULL
          )
          ''');
  }
}