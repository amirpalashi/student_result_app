import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../services/student_service.dart';
import 'database_tables.dart';
import 'seed_data.dart';
import '../database/subject_seed_data.dart';
import '../services/subject_result_service.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    await _seedDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'student_result.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseTables.createStudentTable);

    await db.execute(DatabaseTables.createSubjectResultTable);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(DatabaseTables.createSubjectResultTable);
    }
  }

  Future<void> resetDatabase() async {
    final db = await database;

    await db.delete(DatabaseTables.subjectResultTable);

    await db.delete(DatabaseTables.studentTable);
  }

  Future<void> _seedDatabase() async {
    // Students
    final students = await StudentService.instance.getAllStudents();

    if (students.isEmpty) {
      for (final student in SeedData.students) {
        await StudentService.instance.insertStudent(student);
      }
    }

    // Subjects
    final subjects = await SubjectResultService.instance.getSubjectResults(
      '1001',
    );

    if (subjects.isEmpty) {
      for (final subject in SubjectSeedData.subjects) {
        await SubjectResultService.instance.insertSubjectResult(subject);
      }
    }
  }
}
