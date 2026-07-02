import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import 'widgets/result_header.dart';
import 'widgets/student_info_card.dart';
import 'widgets/gpa_card.dart';
import 'widgets/subject_result_card.dart';
import 'widgets/result_action_buttons.dart';

class ResultScreen extends StatelessWidget {
  final StudentModel student;

  const ResultScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Result"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ResultHeader(),

            const SizedBox(height: 20),

            StudentInfoCard(student: student),
            const SizedBox(height: 20),

            GpaCard(gpa: student.gpa),
            const SizedBox(height: 20),

            SubjectResultCard(studentId: student.studentId),
            const SizedBox(height: 20),

            const ResultActionButtons(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
