import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../repositories/student_repository.dart';
import '../../widgets/admin/student_card.dart';
import 'add_student_screen.dart';
import '../../widgets/app_selector.dart';
import '../../core/utils/education_helper.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<StudentModel> students = [];
  String? selectedClass;
  String? selectedGroup;

  final List<String> classList = const [
    'Play',
    'Nursery',
    'KG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class XI',
    'Class XII',
  ];

  bool isLoading = true;
  Future<void> loadStudents() async {
    final data = await StudentRepository.instance.getAllStudents();

    if (!mounted) return;

    setState(() {
      students = data;
      isLoading = false;
    });
  }

  Future<void> loadStudentsByClass() async {
    if (selectedClass == null) return;

    // Class 9-12 হলে Group নির্বাচন না করা পর্যন্ত Load হবে না
    if (EducationHelper.hasGroup(selectedClass) && selectedGroup == null) {
      setState(() {
        students = [];
      });
      return;
    }

    final data = await StudentRepository.instance.getStudentsByClass(
      className: selectedClass!,
      groupName: selectedGroup,
    );

    if (!mounted) return;

    setState(() {
      students = data;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student List"), centerTitle: true),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSelector<String>(
              label: "Class",
              icon: Icons.school,
              value: selectedClass,
              items: classList,
              itemLabel: (item) => item,
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });

                loadStudentsByClass();
              },
            ),
          ),
          if (EducationHelper.hasGroup(selectedClass))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSelector<String>(
                label: "Group",
                icon: Icons.groups,
                value: selectedGroup,
                items: EducationHelper.availableGroups(selectedClass),
                itemLabel: (item) => item,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });

                  loadStudentsByClass();
                },
              ),
            ),
          if (selectedClass != null)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        EducationHelper.hasGroup(selectedClass)
                            ? '$selectedClass (${selectedGroup ?? "Select Group"})'
                            : selectedClass!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Total: ${students.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        

          Expanded(
            child: students.isEmpty
                ? const Center(
                    child: Text(
                      "Please select a class",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return StudentCard(
                        student: student,
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddStudentScreen(student: student),
                            ),
                          );

                          if (selectedClass == null) {
                            loadStudents();
                          } else {
                            loadStudentsByClass();
                          }
                        },
                        onDelete: () {
                          _deleteStudent(student);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );

          if (selectedClass == null) {
            loadStudents();
          } else {
            loadStudentsByClass();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
