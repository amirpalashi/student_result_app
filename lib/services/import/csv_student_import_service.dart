import 'dart:io';

import 'package:csv/csv.dart';

import '../../models/student_model.dart';

class CsvStudentImportService {
  CsvStudentImportService._();

  static final CsvStudentImportService instance = CsvStudentImportService._();

  static const List<String> expectedHeader = [
    'student_id',
    'student_name',
    'father_name',
    'mother_name',
    'roll',
    'class_name',
    'group_name',
    'session',
    'exam',
    'mobile',
  ];

  /// Read CSV File
  Future<List<List<dynamic>>> readCsv(File file) async {
    final csvString = await file.readAsString();

    final rows = const CsvToListConverter(
      fieldDelimiter: ',',
      textDelimiter: '"',
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvString.replaceAll('\r\n', '\n'));

    return rows;
  }

  /// Validate CSV Header
  bool isValidHeader(List<dynamic> header) {
    if (header.length != expectedHeader.length) {
      return false;
    }

    for (int i = 0; i < expectedHeader.length; i++) {
      if (header[i].toString().trim().toLowerCase() != expectedHeader[i]) {
        return false;
      }
    }

    return true;
  }

  /// Convert CSV Rows to StudentModel List
  List<StudentModel> parseStudents(List<List<dynamic>> rows) {
    if (rows.isEmpty) {
      return [];
    }

    if (!isValidHeader(rows.first)) {
      throw Exception('Invalid CSV Header');
    }

    final students = <StudentModel>[];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length < 10) {
        continue;
      }

      students.add(
        StudentModel(
          id: null,
          studentId: row[0].toString().trim(),
          studentName: row[1].toString().trim(),
          fatherName: row[2].toString().trim(),
          motherName: row[3].toString().trim(),
          roll: row[4].toString().trim(),
          className: row[5].toString().trim(),
          groupName: row[6].toString().trim(),
          session: row[7].toString().trim(),
          exam: row[8].toString().trim(),
          mobile: row[9].toString().trim().isEmpty
              ? null
              : row[9].toString().trim(),
          gpa: 0.0,
        ),
      );
    }

    return students;
  }
}
