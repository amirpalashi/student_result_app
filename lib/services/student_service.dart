import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/student_model.dart';
import 'subject_result_service.dart';

class StudentService {
  StudentService._();

  static final StudentService instance = StudentService._();

  Future<int> insertStudent(StudentModel student) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.insert(
      DatabaseTables.studentTable,
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<StudentModel?> getStudentByStudentId(String studentId) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.studentTable,
      where: 'student_id = ?',
      whereArgs: [studentId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return StudentModel.fromMap(result.first);
  }

  Future<StudentModel?> searchStudent({
    required String studentId,
    required String session,
    required String className,
    required String exam,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.studentTable,
      where: '''
student_id = ?
AND session = ?
AND class_name = ?
AND exam = ?
''',
      whereArgs: [studentId, session, className, exam],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return StudentModel.fromMap(result.first);
  }

  Future<List<StudentModel>> getAllStudents() async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.studentTable,
      orderBy: 'student_name ASC',
    );

    return result.map(StudentModel.fromMap).toList();
  }

  Future<List<StudentModel>> getStudentsForResult({
    required String session,
    required String exam,
    required String className,
    required String groupName,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final bool hasGroup =
        className == 'Class 9' ||
        className == 'Class 10' ||
        className == 'Class XI' ||
        className == 'Class XII';

    final result = await db.query(
      DatabaseTables.studentTable,
      where: hasGroup
          ? '''
        session = ?
        AND exam = ?
        AND class_name = ?
        AND group_name = ?
      '''
          : '''
        session = ?
        AND exam = ?
        AND class_name = ?
      ''',
      whereArgs: hasGroup
          ? [session, exam, className, groupName]
          : [session, exam, className],
      orderBy: 'roll ASC',
    );

    return result.map((e) => StudentModel.fromMap(e)).toList();
  }

  Future<int> updateStudent(StudentModel student) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.update(
      DatabaseTables.studentTable,
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final Database db = await DatabaseHelper.instance.database;

    // প্রথমে Student ID বের করি
    final result = await db.query(
      DatabaseTables.studentTable,
      columns: ['student_id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final studentId = result.first['student_id'] as String;

      // ঐ Student-এর সব Result Delete
      await SubjectResultService.instance.deleteResultsByStudentId(studentId);
    }

    // এরপর Student Delete
    return await db.delete(
      DatabaseTables.studentTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertStudents(List<StudentModel> students) async {
    final Database db = await DatabaseHelper.instance.database;

    final batch = db.batch();

    for (final student in students) {
      batch.insert(
        DatabaseTables.studentTable,
        student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<int> deleteAllStudents() async {
    final Database db = await DatabaseHelper.instance.database;

    // আগে সব Result Delete
    await SubjectResultService.instance.deleteAllResults();

    // তারপর সব Student Delete
    return await db.delete(DatabaseTables.studentTable);
  }
}
