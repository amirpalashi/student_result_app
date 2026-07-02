import 'student_model.dart';
import 'subject_result_model.dart';

class StudentResultData {
  final StudentModel student;
  final List<SubjectResultModel> subjects;
  final double gpa;
  final String grade;

  const StudentResultData({
    required this.student,
    required this.subjects,
    required this.gpa,
    required this.grade,
  });
}