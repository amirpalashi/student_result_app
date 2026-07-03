import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/subject_model.dart';

class SubjectService {
  SubjectService._();

  static final SubjectService instance = SubjectService._();

  Future<int> insertSubject(SubjectModel subject) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.insert(
      DatabaseTables.subjectTable,
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubjectModel>> getSubjects({
    required String className,
    required String groupName,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.subjectTable,
      where: 'class_name = ? AND group_name = ?',
      whereArgs: [className, groupName],
      orderBy: 'subject_name ASC',
    );

    return result.map((e) => SubjectModel.fromMap(e)).toList();
  }

  Future<int> updateSubject(SubjectModel subject) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.update(
      DatabaseTables.subjectTable,
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<int> deleteSubject(int id) async {
    final Database db = await DatabaseHelper.instance.database;

    return db.delete(
      DatabaseTables.subjectTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> subjectExists({
    required String className,
    required String groupName,
    required String subjectName,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      DatabaseTables.subjectTable,
      where: '''
      class_name = ?
      AND group_name = ?
      AND LOWER(subject_name) = LOWER(?)
    ''',
      whereArgs: [className, groupName, subjectName.trim()],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}
