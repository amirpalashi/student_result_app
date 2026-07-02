import '../models/student_model.dart';
import '../models/subject_result_model.dart';
import '../services/student_service.dart';
import '../services/subject_result_service.dart';
import '../models/student_result_data.dart';

class StudentRepository {
  StudentRepository._();

  static final StudentRepository instance = StudentRepository._();

  Future<StudentModel?> searchStudent({
    required String studentId,
    required String session,
    required String className,
    required String exam,
  }) {
    return StudentService.instance.searchStudent(
      studentId: studentId,
      session: session,
      className: className,
      exam: exam,
    );
  }

  Future<List<SubjectResultModel>> getSubjectResults(
    String studentId,
  ) {
    return SubjectResultService.instance.getSubjectResults(studentId);
  }

  Future<double> calculateGpa(
    String studentId,
  ) {
    return SubjectResultService.instance.calculateGpa(studentId);
  }

  Future<String> calculateGrade(
    String studentId,
  ) {
    return SubjectResultService.instance.calculateGrade(studentId);
  }
  Future<StudentResultData?> getStudentResult({
  required String studentId,
  required String session,
  required String className,
  required String exam,
}) async {
  final student = await searchStudent(
    studentId: studentId,
    session: session,
    className: className,
    exam: exam,
  );

  if (student == null) {
    return null;
  }

  final subjects = await getSubjectResults(student.studentId);

  final gpa = await calculateGpa(student.studentId);

  final grade = await calculateGrade(student.studentId);

  return StudentResultData(
    student: student,
    subjects: subjects,
    gpa: gpa,
    grade: grade,
  );
}
}