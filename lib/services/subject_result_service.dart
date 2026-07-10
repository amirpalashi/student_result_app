import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/subject_result_model.dart';
import '../models/result_summary_model.dart';

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

  Future<void> insertAllResults(List<SubjectResultModel> results) async {
    final db = await DatabaseHelper.instance.database;

    final batch = db.batch();

    for (final result in results) {
      if (result.id == null) {
        batch.insert(
          DatabaseTables.subjectResultTable,
          result.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        batch.update(
          DatabaseTables.subjectResultTable,
          result.toMap(),
          where: 'id = ?',
          whereArgs: [result.id],
        );
      }
    }

    await batch.commit(noResult: true);
  }

  Future<SubjectResultModel?> getSubjectResult({
    required String studentId,
    required String subjectName,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.subjectResultTable,
      where: 'student_id = ? AND subject_name = ?',
      whereArgs: [studentId, subjectName],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return SubjectResultModel.fromMap(result.first);
  }

  Future<ResultSummaryModel> getResultSummary(String studentId) async {
    final results = await getSubjectResults(studentId);

    if (results.isEmpty) {
      return const ResultSummaryModel(
        totalSubjects: 0,
        totalMarks: 0,
        averageMarks: 0,
        gpa: 0,
        grade: 'F',
        isPass: false,
      );
    }

    int totalMarks = 0;
    double totalGradePoint = 0;
    bool isPass = true;

    for (final result in results) {
      totalMarks += result.marks;
      totalGradePoint += result.gradePoint;

      if (result.grade == 'F') {
        isPass = false;
      }
    }

    final totalSubjects = results.length;
    final averageMarks = totalMarks / totalSubjects;
    final gpa = totalGradePoint / totalSubjects;

    String grade;

    if (gpa >= 5.0) {
      grade = 'A+';
    } else if (gpa >= 4.0) {
      grade = 'A';
    } else if (gpa >= 3.5) {
      grade = 'A-';
    } else if (gpa >= 3.0) {
      grade = 'B';
    } else if (gpa >= 2.0) {
      grade = 'C';
    } else if (gpa >= 1.0) {
      grade = 'D';
    } else {
      grade = 'F';
    }

    return ResultSummaryModel(
      totalSubjects: totalSubjects,
      totalMarks: totalMarks,
      averageMarks: averageMarks,
      gpa: gpa,
      grade: grade,
      isPass: isPass,
    );
  }

  Future<int> deleteResultsByStudentId(String studentId) async {
    final Database db = await DatabaseHelper.instance.database;

    return await db.delete(
      DatabaseTables.subjectResultTable,
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
  }

  Future<List<SubjectResultModel>> getAllResults() async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.subjectResultTable,
      orderBy: 'student_id ASC, subject_name ASC',
    );

    return result.map((e) => SubjectResultModel.fromMap(e)).toList();
  }

  Future<void> upsertSubjectResult(SubjectResultModel result) async {
    final Database db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      DatabaseTables.subjectResultTable,
      where: 'student_id = ? AND subject_name = ?',
      whereArgs: [result.studentId, result.subjectName],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert(
        DatabaseTables.subjectResultTable,
        result.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        DatabaseTables.subjectResultTable,
        result.toMap(),
        where: 'student_id = ? AND subject_name = ?',
        whereArgs: [result.studentId, result.subjectName],
      );
    }
  }
  //=========================================
  // Delete All Results
  //=========================================

  Future<void> deleteAllResults() async {
    final Database db = await DatabaseHelper.instance.database;

    await db.delete(DatabaseTables.subjectResultTable);
  }
  //=========================================
  // Bulk Upsert Results
  //=========================================

  Future<void> upsertAllResults(List<SubjectResultModel> results) async {
    for (final result in results) {
      await upsertSubjectResult(result);
    }
  }

}
