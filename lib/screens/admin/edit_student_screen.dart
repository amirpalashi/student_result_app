import 'package:flutter/material.dart';

import '../../models/student_model.dart';

class ResultScreen extends StatelessWidget {
  final StudentModel student;

  const ResultScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Result"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          student.studentName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}