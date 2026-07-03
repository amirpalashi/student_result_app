import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../repositories/student_repository.dart';
import '../../widgets/admin/student_card.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<StudentModel> students = [];

  bool isLoading = true;
  Future<void> loadStudents() async {
    final data = await StudentRepository.instance.getAllStudents();

    if (!mounted) return;

    setState(() {
      students = data;
      isLoading = false;
    });
  }

  Future<void> _deleteStudent(StudentModel student) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 40,
          ),
          title: const Text("Delete Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This action cannot be undone!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text("Are you sure you want to delete this student?"),
              const SizedBox(height: 16),
              Text(
                "Name: ${student.studentName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("ID: ${student.studentId}"),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    if (confirm != true) return;

    await StudentRepository.instance.deleteStudent(student.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Student deleted successfully.")),
    );

    loadStudents();
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student List"), centerTitle: true),

      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return StudentCard(
            student: student,
            onEdit: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddStudentScreen(student: student),
                ),
              );

              loadStudents();
            },
            onDelete: () {
              _deleteStudent(student);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
          Future<void> loadStudents() async {
            final data = await StudentRepository.instance.getAllStudents();

            debugPrint("===== TOTAL STUDENTS =====");
            debugPrint(data.length.toString());

            if (!mounted) return;

            setState(() {
              students = data;
              isLoading = false;
            });
          }

          // Add Student Screen থেকে ফিরে এলে List Refresh হবে
          loadStudents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
