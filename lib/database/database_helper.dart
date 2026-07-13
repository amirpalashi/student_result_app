import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'student_result.db');

    return openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseTables.createStudentTable);
    await db.execute(DatabaseTables.createSubjectResultTable);
    await db.execute(DatabaseTables.createSubjectTable);
    await db.execute(DatabaseTables.createSchoolSettingsTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      ALTER TABLE subject_results
      ADD COLUMN full_marks INTEGER NOT NULL DEFAULT 100
    ''');

      await db.execute('''
      ALTER TABLE subject_results
      ADD COLUMN pass_marks INTEGER NOT NULL DEFAULT 33
    ''');
    }

    if (oldVersion < 4) {
      await db.execute(DatabaseTables.createSubjectTable);
    }

    if (oldVersion < 5) {
      await db.execute(DatabaseTables.createSchoolSettingsTable);
    }
  }

  Future<void> resetDatabase() async {
    final db = await database;

    await db.delete(DatabaseTables.subjectResultTable);

    await db.delete(DatabaseTables.studentTable);
  }

  
}
