class ResultSummaryModel {
  final int totalSubjects;
  final int totalMarks;
  final double averageMarks;
  final double gpa;
  final String grade;
  final bool isPass;

  const ResultSummaryModel({
    required this.totalSubjects,
    required this.totalMarks,
    required this.averageMarks,
    required this.gpa,
    required this.grade,
    required this.isPass,
  });
}