class GradeService {
  GradeService._();

  static String calculateGrade(int marks) {
    if (marks >= 80) return 'A+';
    if (marks >= 70) return 'A';
    if (marks >= 60) return 'A-';
    if (marks >= 50) return 'B';
    if (marks >= 40) return 'C';
    if (marks >= 33) return 'D';

    return 'F';
  }

  static double calculateGradePoint(int marks) {
    if (marks >= 80) return 5.0;
    if (marks >= 70) return 4.0;
    if (marks >= 60) return 3.5;
    if (marks >= 50) return 3.0;
    if (marks >= 40) return 2.0;
    if (marks >= 33) return 1.0;

    return 0.0;
  }
}