import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/subject_result_model.dart';

class SubjectResultService {
  SubjectResultService._();

  static final SubjectResultService instance = SubjectResultService._();

  Future<int> insertSubjectResult(SubjectResultModel subject) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.insert(
      DatabaseTables.subjectResultTable,
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubjectResultModel>> getSubjectResults(String studentId) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.subjectResultTable,
      where: 'student_id = ?',
      whereArgs: [studentId],
      orderBy: 'subject_name ASC',
    );

    return result.map(SubjectResultModel.fromMap).toList();
  }

  Future<int> updateSubjectResult(SubjectResultModel subject) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.update(
      DatabaseTables.subjectResultTable,
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<int> deleteSubjectResult(int id) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.delete(
      DatabaseTables.subjectResultTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> calculateGpa(String studentId) async {
    final subjects = await getSubjectResults(studentId);

    if (subjects.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final subject in subjects) {
      total += subject.gradePoint;
    }

    return total / subjects.length;
  }

  Future<String> calculateGrade(String studentId) async {
    final gpa = await calculateGpa(studentId);

    if (gpa >= 5.0) return "A+";
    if (gpa >= 4.0) return "A";
    if (gpa >= 3.5) return "A-";
    if (gpa >= 3.0) return "B";
    if (gpa >= 2.0) return "C";
    if (gpa >= 1.0) return "D";

    return "F";
  }
}
