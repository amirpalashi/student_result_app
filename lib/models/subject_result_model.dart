class SubjectResultModel {
  final int? id;
  final String studentId;
  final String subjectName;
  final int marks;
  final String grade;
  final double gradePoint;

  const SubjectResultModel({
    this.id,
    required this.studentId,
    required this.subjectName,
    required this.marks,
    required this.grade,
    required this.gradePoint,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_name': subjectName,
      'marks': marks,
      'grade': grade,
      'grade_point': gradePoint,
    };
  }

  factory SubjectResultModel.fromMap(Map<String, dynamic> map) {
    return SubjectResultModel(
      id: map['id'] as int?,
      studentId: map['student_id'] as String,
      subjectName: map['subject_name'] as String,
      marks: map['marks'] as int,
      grade: map['grade'] as String,
      gradePoint: (map['grade_point'] as num).toDouble(),
    );
  }

  SubjectResultModel copyWith({
    int? id,
    String? studentId,
    String? subjectName,
    int? marks,
    String? grade,
    double? gradePoint,
  }) {
    return SubjectResultModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectName: subjectName ?? this.subjectName,
      marks: marks ?? this.marks,
      grade: grade ?? this.grade,
      gradePoint: gradePoint ?? this.gradePoint,
    );
  }
}