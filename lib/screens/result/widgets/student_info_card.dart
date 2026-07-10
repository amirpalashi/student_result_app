import 'package:flutter/material.dart';

import '../../../models/student_model.dart';

class StudentInfoCard extends StatelessWidget {
  final StudentModel student;

  const StudentInfoCard({
    super.key,
    required this.student,
  });

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 35,
              child: Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 16),

            Text(
              student.studentName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _buildRow('Student ID', student.studentId),
            _buildRow('Roll', student.roll),
            _buildRow('Class', student.className),
            _buildRow('Group', student.groupName),
            _buildRow('Session', student.session),
            _buildRow('Exam', student.exam),
          ],
        ),
      ),
    );
  }
}