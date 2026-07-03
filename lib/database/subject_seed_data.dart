import '../models/subject_result_model.dart';

class SubjectSeedData {
  SubjectSeedData._();

  static const List<SubjectResultModel> subjects = [
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Bangla',
      fullMarks: 100,
      passMarks: 33,
      marks: 85,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'English',
      fullMarks: 100,
      passMarks: 33,
      marks: 82,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Mathematics',
      fullMarks: 100,
      passMarks: 33,
      marks: 95,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Physics',
      fullMarks: 100,
      passMarks: 33,
      marks: 88,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Chemistry',
      fullMarks: 100,
      passMarks: 33,
      marks: 90,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Biology',
      fullMarks: 100,
      passMarks: 33,
      marks: 86,
      grade: 'A+',
      gradePoint: 5.0,
    ),
  ];
}