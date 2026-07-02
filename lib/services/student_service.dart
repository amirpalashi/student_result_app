import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/student_model.dart';

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

    final result = await db.query(DatabaseTables.studentTable);

    return result.map(StudentModel.fromMap).toList();
  }

  Future<int> updateStudent(StudentModel student) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.update(
      DatabaseTables.studentTable,
      student.toMap(),
      where: 'student_id = ?',
      whereArgs: [student.studentId],
    );
  }

  Future<int> deleteStudent(String studentId) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.delete(
      DatabaseTables.studentTable,
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
  }
}
