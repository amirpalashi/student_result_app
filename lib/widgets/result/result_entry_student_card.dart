import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class ResultEntryStudentCard extends StatelessWidget {
  final StudentModel student;

  const ResultEntryStudentCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    student.studentName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            _infoRow(
              Icons.badge,
              "Student ID",
              student.studentId,
            ),

            _infoRow(
              Icons.confirmation_number,
              "Roll",
              student.roll,
            ),

            _infoRow(
              Icons.school,
              "Class",
              student.className,
            ),

            if (student.groupName != 'General')
              _infoRow(
                Icons.groups,
                "Group",
                student.groupName,
              ),

            _infoRow(
              Icons.assignment,
              "Exam",
              student.exam,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.blue,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 85,
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
}