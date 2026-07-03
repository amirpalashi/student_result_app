class SubjectModel {
  final int? id;
  final String className;
  final String groupName;
  final String subjectName;
  final int fullMarks;
  final int passMarks;

  const SubjectModel({
    this.id,
    required this.className,
    required this.groupName,
    required this.subjectName,
    required this.fullMarks,
    required this.passMarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'class_name': className,
      'group_name': groupName,
      'subject_name': subjectName,
      'full_marks': fullMarks,
      'pass_marks': passMarks,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int?,
      className: map['class_name'] as String,
      groupName: map['group_name'] as String,
      subjectName: map['subject_name'] as String,
      fullMarks: map['full_marks'] as int,
      passMarks: map['pass_marks'] as int,
    );
  }

  SubjectModel copyWith({
    int? id,
    String? className,
    String? groupName,
    String? subjectName,
    int? fullMarks,
    int? passMarks,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      className: className ?? this.className,
      groupName: groupName ?? this.groupName,
      subjectName: subjectName ?? this.subjectName,
      fullMarks: fullMarks ?? this.fullMarks,
      passMarks: passMarks ?? this.passMarks,
    );
  }

  @override
  String toString() {
    return 'SubjectModel(id: $id, subjectName: $subjectName)';
  }
}