import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class StudentInfoCard extends StatelessWidget {
  final StudentModel student;

  const StudentInfoCard({
    super.key,
    required this.student,
  });

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            _buildRow("Student ID", student.studentId),
            _buildRow("Name", student.studentName),
            _buildRow("Roll", student.roll),
            _buildRow("Class", student.className),
            _buildRow("Session", student.session),
            _buildRow("Exam", student.exam),

            if (student.groupName.isNotEmpty &&
                student.groupName != "General")
              _buildRow("Group", student.groupName),
          ],
        ),
      ),
    );
  }
}