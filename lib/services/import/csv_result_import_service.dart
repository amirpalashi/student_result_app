import 'dart:io';

import 'package:csv/csv.dart';

class CsvResultImportModel {
  final String studentId;
  final String subjectName;
  final int marks;

  const CsvResultImportModel({
    required this.studentId,
    required this.subjectName,
    required this.marks,
  });
}

class CsvResultImportService {
  CsvResultImportService._();

  static final CsvResultImportService instance =
      CsvResultImportService._();

  static const List<String> expectedHeader = [
    'student_id',
    'subject_name',
    'marks',
  ];

  //=========================================
  // Read CSV
  //=========================================

  Future<List<List<dynamic>>> readCsv(File file) async {
    final csvString = await file.readAsString();

    final rows = const CsvToListConverter(
      fieldDelimiter: ',',
      textDelimiter: '"',
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(
      csvString.replaceAll('\r\n', '\n'),
    );

    return rows;
  }

  //=========================================
  // Validate Header
  //=========================================

  bool isValidHeader(List<dynamic> header) {
    if (header.length != expectedHeader.length) {
      return false;
    }

    for (int i = 0; i < expectedHeader.length; i++) {
      if (header[i].toString().trim().toLowerCase() !=
          expectedHeader[i]) {
        return false;
      }
    }

    return true;
  }

  //=========================================
  // Parse CSV
  //=========================================

  List<CsvResultImportModel> parseResults(
    List<List<dynamic>> rows,
  ) {
    if (rows.isEmpty) {
      return [];
    }

    if (!isValidHeader(rows.first)) {
      throw Exception('Invalid CSV Header');
    }

    final results = <CsvResultImportModel>[];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length < 3) {
        continue;
      }

      final studentId = row[0].toString().trim();
      final subjectName = row[1].toString().trim();

      final marks =
          int.tryParse(row[2].toString().trim());

      if (studentId.isEmpty ||
          subjectName.isEmpty ||
          marks == null) {
        continue;
      }

      results.add(
        CsvResultImportModel(
          studentId: studentId,
          subjectName: subjectName,
          marks: marks,
        ),
      );
    }

    return results;
  }
}