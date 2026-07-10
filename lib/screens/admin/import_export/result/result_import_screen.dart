import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../services/import/csv_result_import_service.dart';
import '../../../../models/subject_result_model.dart';

import '../../../../services/student_service.dart';
import '../../../../services/subject_service.dart';
import '../../../../services/subject_result_service.dart';
import '../../../../services/grade_service.dart';
import '../../../../models/subject_model.dart';

class ResultImportScreen extends StatefulWidget {
  const ResultImportScreen({super.key});

  @override
  State<ResultImportScreen> createState() => _ResultImportScreenState();
}

class _ResultImportScreenState extends State<ResultImportScreen> {
  File? selectedFile;
  String? selectedFileName;
  bool isImporting = false;

  Future<void> selectCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    final path = result.files.single.path;

    if (path == null) return;

    setState(() {
      selectedFile = File(path);
      selectedFileName = result.files.single.name;
    });
  }

  Future<void> importResults() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a CSV file first.')),
      );
      return;
    }

    setState(() {
      isImporting = true;
    });

    try {
      final rows = await CsvResultImportService.instance.readCsv(selectedFile!);

      final results = CsvResultImportService.instance.parseResults(rows);
      int imported = 0;
      int skipped = 0;

      for (final item in results) {
        final student = await StudentService.instance.getStudentByStudentId(
          item.studentId,
        );

        if (student == null) {
          skipped++;
          continue;
        }

        final subjects = await SubjectService.instance.getSubjects(
          className: student.className,
          groupName: student.groupName,
        );

        SubjectModel? subject;

        try {
          subject = subjects.firstWhere(
            (e) =>
                e.subjectName.trim().toLowerCase() ==
                item.subjectName.trim().toLowerCase(),
          );
        } catch (_) {
          skipped++;
          continue;
        }

        final result = SubjectResultModel(
          id: null,
          studentId: item.studentId,
          subjectName: subject.subjectName,
          fullMarks: subject.fullMarks,
          passMarks: subject.passMarks,
          marks: item.marks,
          grade: GradeService.calculateGrade(item.marks),
          gradePoint: GradeService.calculateGradePoint(item.marks),
        );

        await SubjectResultService.instance.upsertSubjectResult(result);

        imported++;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Import Completed\nImported: $imported | Skipped: $skipped',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      // পরবর্তী Step-এ এখান থেকেই Database Save হবে
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Results'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.assignment, size: 80, color: Colors.green),

          const SizedBox(height: 20),

          const Text(
            'Import Results from CSV',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            'Select the official Result CSV Template and import student marks.',
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.description),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(selectedFileName ?? 'No CSV file selected'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isImporting ? null : selectCsvFile,
              icon: const Icon(Icons.folder_open),
              label: const Text('Select CSV'),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isImporting ? null : importResults,
              icon: const Icon(Icons.upload),
              label: Text(isImporting ? 'Importing...' : 'Import Results'),
            ),
          ),
          const SizedBox(height: 16),
          buildDeleteButton(),
        ],
      ),
    );
  }
  Widget buildDeleteButton() {
  return SizedBox(
    height: 50,
    child: OutlinedButton.icon(
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      label: const Text(
        'Delete All Results',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete All Results'),
            content: const Text(
              'This will permanently delete all student results.\n\nContinue?',
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

        if (confirm != true || !mounted) return;

        await SubjectResultService.instance.deleteAllResults();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All results deleted successfully.'),
          ),
        );

        setState(() {
          selectedFile = null;
          selectedFileName = null;
        });
      },
    ),
  );
}
}
