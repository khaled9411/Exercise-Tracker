import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sets INTEGER NOT NULL,
        repetitions INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await instance.database;
    final workoutMaps = await db.query('workouts', orderBy: 'date DESC');
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Workout>> getWorkoutsByDate(DateTime date) async {
    final db = await instance.database;
    final workoutMaps = await db.query('workouts',
        where: 'date LIKE ?',
        whereArgs: ['${date.toIso8601String().split('T')[0]}%']);
    return workoutMaps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<Map<String, dynamic>> getWorkoutStats() async {
    final db = await instance.database;
    final totalWorkouts = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM workouts')) ??
        0;

    final totalSets = Sqflite.firstIntValue(
            await db.rawQuery('SELECT SUM(sets) FROM workouts')) ??
        0;

    final totalRepetitions = Sqflite.firstIntValue(
            await db.rawQuery('SELECT SUM(repetitions) FROM workouts')) ??
        0;

    return {
      'totalWorkouts': totalWorkouts,
      'totalSets': totalSets,
      'totalRepetitions': totalRepetitions
    };
  }
}
