import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../models/subject_result_model.dart';

class ExcelService {
  ExcelService._();

  static final ExcelService instance = ExcelService._();

  Future<File> exportStudents(List<StudentModel> students) async {
    final excel = Excel.createExcel();

    final Sheet sheet = excel['Students'];

    sheet.appendRow([
      TextCellValue('Student ID'),
      TextCellValue('Roll'),
      TextCellValue('Student Name'),
      TextCellValue('Class'),
      TextCellValue('Session'),
    ]);

    for (final student in students) {
      sheet.appendRow([
        TextCellValue(student.studentId),
        TextCellValue(student.roll),
        TextCellValue(student.studentName),
        TextCellValue(student.className),
        TextCellValue(student.session),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/Students.xlsx');
    excel.delete('Sheet1');

    final bytes = excel.save();
    if (bytes == null) {
      throw Exception('Excel save() returned null.');
    }

    await file.writeAsBytes(bytes, flush: true);


    return file;
  }
  Future<File> exportSubjects(List<SubjectModel> subjects) async {
  final excel = Excel.createExcel();

  final Sheet sheet = excel['Subjects'];

  sheet.appendRow([
    TextCellValue('Class'),
    TextCellValue('Group'),
    TextCellValue('Subject'),
    TextCellValue('Full Marks'),
    TextCellValue('Pass Marks'),
  ]);

  for (final subject in subjects) {
    sheet.appendRow([
      TextCellValue(subject.className),
      TextCellValue(subject.groupName),
      TextCellValue(subject.subjectName),
      IntCellValue(subject.fullMarks),
      IntCellValue(subject.passMarks),
    ]);
  }

  final directory = await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/Subjects.xlsx');

  excel.delete('Sheet1');

  final bytes = excel.save();

  if (bytes == null) {
    throw Exception('Excel save() returned null.');
  }

  await file.writeAsBytes(bytes, flush: true);

  return file;
}
Future<File> exportResults(List<SubjectResultModel> results) async {
  final excel = Excel.createExcel();

  final Sheet sheet = excel['Results'];

  sheet.appendRow([
    TextCellValue('Student ID'),
    TextCellValue('Subject'),
    TextCellValue('Marks'),
    TextCellValue('Grade'),
    TextCellValue('Grade Point'),
  ]);

  for (final result in results) {
    sheet.appendRow([
      TextCellValue(result.studentId),
      TextCellValue(result.subjectName),
      IntCellValue(result.marks),
      TextCellValue(result.grade),
      DoubleCellValue(result.gradePoint),
    ]);
  }

  final directory = await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/Results.xlsx');

  excel.delete('Sheet1');

  final bytes = excel.save();

  if (bytes == null) {
    throw Exception('Excel save() returned null.');
  }

  await file.writeAsBytes(bytes, flush: true);

  return file;
}
}
