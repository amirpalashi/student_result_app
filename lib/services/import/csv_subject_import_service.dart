import 'dart:io';

import 'package:csv/csv.dart';

import '../../models/subject_model.dart';

class CsvSubjectImportService {
  CsvSubjectImportService._();

  static final CsvSubjectImportService instance =
      CsvSubjectImportService._();

  static const List<String> expectedHeader = [
    'class_name',
    'group_name',
    'subject_name',
    'full_marks',
    'pass_marks',
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
    ).convert(csvString.replaceAll('\r\n', '\n'));

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

  List<SubjectModel> parseSubjects(
    List<List<dynamic>> rows,
  ) {
    if (rows.isEmpty) {
      return [];
    }

    if (!isValidHeader(rows.first)) {
      throw Exception('Invalid CSV Header');
    }

    final subjects = <SubjectModel>[];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.length < 5) {
        continue;
      }

      subjects.add(
        SubjectModel(
          id: null,
          className: row[0].toString().trim(),
          groupName: row[1].toString().trim(),
          subjectName: row[2].toString().trim(),
          fullMarks: int.parse(row[3].toString()),
          passMarks: int.parse(row[4].toString()),
        ),
      );
    }

    return subjects;
  }
}