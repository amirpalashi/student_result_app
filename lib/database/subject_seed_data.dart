import '../models/subject_result_model.dart';

class SubjectSeedData {
  SubjectSeedData._();

  static const List<SubjectResultModel> subjects = [
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Bangla',
      marks: 85,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'English',
      marks: 82,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Mathematics',
      marks: 95,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Physics',
      marks: 88,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Chemistry',
      marks: 90,
      grade: 'A+',
      gradePoint: 5.0,
    ),
    SubjectResultModel(
      studentId: '1001',
      subjectName: 'Biology',
      marks: 86,
      grade: 'A+',
      gradePoint: 5.0,
    ),
  ];
}