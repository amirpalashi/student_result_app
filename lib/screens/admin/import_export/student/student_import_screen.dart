import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../models/student_model.dart';
import '../../../../services/import/csv_student_import_service.dart';
import '../../../../services/student_service.dart';

class StudentImportScreen extends StatefulWidget {
  const StudentImportScreen({super.key});

  @override
  State<StudentImportScreen> createState() => _StudentImportScreenState();
}

class _StudentImportScreenState extends State<StudentImportScreen> {
  //==================================================
  // Variables
  //==================================================

  File? selectedFile;
  String? selectedFileName;

  List<StudentModel> students = [];

  bool isImporting = false;

  //==================================================
  // Pick CSV File
  //==================================================

  Future<void> selectCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    final path = result.files.single.path;

    if (path == null) return;

    final file = File(path);

    try {
      final rows = await CsvStudentImportService.instance.readCsv(file);

      final parsedStudents = CsvStudentImportService.instance.parseStudents(
        rows,
      );

      setState(() {
        selectedFile = file;
        selectedFileName = result.files.single.name;
        students = parsedStudents;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //==================================================
  // Import Students
  //==================================================

  Future<void> importStudents() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a CSV file first.')),
      );
      return;
    }

    if (students.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No student found in CSV.')));
      return;
    }

    setState(() {
      isImporting = true;
    });

    try {
      await StudentService.instance.insertStudents(students);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Import Successful"),
            content: Text("${students.length} students imported successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  setState(() {
                    selectedFile = null;
                    selectedFileName = null;
                    students.clear();
                  });
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      isImporting = false;
    });
  }

  //==================================================
  // Header
  //==================================================

  Widget buildHeader() {
    return Column(
      children: const [
        Icon(Icons.upload_file, size: 80, color: Colors.blue),
        SizedBox(height: 20),
        Text(
          'Import Students',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Import Student Information from CSV File',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //==================================================
  // File Card
  //==================================================

  Widget buildFileCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedFileName ?? "No CSV File Selected",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            if (students.isNotEmpty) ...[
              const Divider(height: 30),

              Row(
                children: [
                  const Icon(Icons.people, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    "Students Found : ${students.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  //==================================================
  // Select Button
  //==================================================

  Widget buildSelectButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isImporting ? null : selectCsvFile,
        icon: const Icon(Icons.folder_open),
        label: const Text("Choose CSV File"),
      ),
    );
  }

  //==================================================
  // Import Button
  //==================================================

  Widget buildImportButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isImporting ? null : importStudents,
        icon: isImporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.upload),
        label: Text(isImporting ? "Importing..." : "Import Students"),
      ),
    );
  }

  Widget buildDeleteButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.delete_forever, color: Colors.red),
        label: const Text(
          'Delete All Students',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Delete All Students'),
              content: const Text(
                'This will permanently delete all students and their results.\n\nContinue?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirm != true) return;

          await StudentService.instance.deleteAllStudents();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All students deleted successfully.')),
          );

          setState(() {
            selectedFile = null;
            selectedFileName = null;
          });
        },
      ),
    );
  }

  //==================================================
  // UI
  //==================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Import Students"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildHeader(),

          const SizedBox(height: 30),

          buildFileCard(),

          const SizedBox(height: 30),

          buildSelectButton(),

          const SizedBox(height: 16),

          buildImportButton(),

          const SizedBox(height: 16),

          buildDeleteButton(), // 👈 নতুন লাইন
        ],
      ),
    );
  }
}
