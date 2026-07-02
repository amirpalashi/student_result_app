import '../models/student_model.dart';

class SeedData {
  SeedData._();

  static List<StudentModel> students = [
    StudentModel(
      studentId: '1001',
      studentName: 'Rahim Uddin',
      fatherName: 'Karim Uddin',
      motherName: 'Amena Begum',
      session: '2025-26',
      className: 'Class XI',
      exam: 'Final',
      roll: '01',
      groupName: 'Science',
      mobile: '01711111111',
      gpa: 5.00,
    ),
    StudentModel(
      studentId: '1002',
      studentName: 'Hasan Mahmud',
      fatherName: 'Abdul Jalil',
      motherName: 'Rokeya Begum',
      session: '2025-26',
      className: 'Class XI',
      exam: 'Final',
      roll: '02',
      groupName: 'Science',
      mobile: '01722222222',
      gpa: 4.80,
    ),
    StudentModel(
      studentId: '1003',
      studentName: 'Nusrat Jahan',
      fatherName: 'Habibur Rahman',
      motherName: 'Shirin Akter',
      session: '2025-26',
      className: 'Class XII',
      exam: 'Final',
      roll: '03',
      groupName: 'Business Studies',
      mobile: '01733333333',
      gpa: 4.95,
    ),
  ];
}