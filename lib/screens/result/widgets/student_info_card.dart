import 'package:flutter/material.dart';

import '../../../models/student_model.dart';

class StudentInfoCard extends StatelessWidget {
  final StudentModel student;

  const StudentInfoCard({
    super.key,
    required this.student,
  });

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(": "),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 45,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              student.studentName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            _buildInfoRow("Student ID", student.studentId),
            _buildInfoRow("Roll", student.roll),
            _buildInfoRow("Class", student.className),
            _buildInfoRow("Group", student.groupName),
            _buildInfoRow("Session", student.session),
            _buildInfoRow("Exam", student.exam),
            _buildInfoRow("Father", student.fatherName),
            _buildInfoRow("Mother", student.motherName),
            _buildInfoRow("Mobile", student.mobile),
          ],
        ),
      ),
    );
  }
}