class StudentModel {
  final int? id;
  final String studentId;
  final String studentName;
  final String fatherName;
  final String motherName;
  final String session;
  final String className;
  final String exam;
  final String roll;
  final String groupName;
  final String? mobile;
  final double gpa;

  const StudentModel({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.fatherName,
    required this.motherName,
    required this.session,
    required this.className,
    required this.exam,
    required this.roll,
    required this.groupName,
    this.mobile,
    required this.gpa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'father_name': fatherName,
      'mother_name': motherName,
      'session': session,
      'class_name': className,
      'exam': exam,
      'roll': roll,
      'group_name': groupName,
      'mobile': mobile,
      'gpa': gpa,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int?,
      studentId: map['student_id'] as String,
      studentName: map['student_name'] as String,
      fatherName: map['father_name'] as String,
      motherName: map['mother_name'] as String,
      session: map['session'] as String,
      className: map['class_name'] as String,
      exam: map['exam'] as String,
      roll: map['roll'] as String,
      groupName: map['group_name'] as String,
      mobile: map['mobile'] as String?,
      gpa: (map['gpa'] as num).toDouble(),
    );
  }

  StudentModel copyWith({
    int? id,
    String? studentId,
    String? studentName,
    String? fatherName,
    String? motherName,
    String? session,
    String? className,
    String? exam,
    String? roll,
    String? groupName,
    String? mobile,
    double? gpa,
  }) {
    return StudentModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      session: session ?? this.session,
      className: className ?? this.className,
      exam: exam ?? this.exam,
      roll: roll ?? this.roll,
      groupName: groupName ?? this.groupName,
      mobile: mobile ?? this.mobile,
      gpa: gpa ?? this.gpa,
    );
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, studentId: $studentId, studentName: $studentName)';
  }
}