class CsvResultModel {
  final String studentId;
  final String subjectName;
  final int marks;

  const CsvResultModel({
    required this.studentId,
    required this.subjectName,
    required this.marks,
  });

  @override
  String toString() {
    return 'CsvResultModel(studentId: $studentId, subjectName: $subjectName, marks: $marks)';
  }
}