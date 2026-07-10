import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../models/subject_model.dart';
import '../../../../services/import/csv_subject_import_service.dart';
import '../../../../services/subject_service.dart';

class SubjectImportScreen extends StatefulWidget {
  const SubjectImportScreen({super.key});

  @override
  State<SubjectImportScreen> createState() => _SubjectImportScreenState();
}

class _SubjectImportScreenState extends State<SubjectImportScreen> {
  //==================================================
  // Variables
  //==================================================

  File? selectedFile;
  String? selectedFileName;

  List<SubjectModel> subjects = [];

  bool isImporting = false;
  bool deleteExistingSubjects = true;
  //==================================================
  // Select CSV File
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
      final rows = await CsvSubjectImportService.instance.readCsv(file);

      final parsed = CsvSubjectImportService.instance.parseSubjects(rows);

      setState(() {
        selectedFile = file;
        selectedFileName = result.files.single.name;
        subjects = parsed;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  //==================================================
  // Import Subjects
  //==================================================

  Future<void> importSubjects() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a CSV file first.')),
      );
      return;
    }

    if (subjects.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No subject found in CSV.')));
      return;
    }

    setState(() {
      isImporting = true;
    });

    try {
      if (deleteExistingSubjects) {
        await SubjectService.instance.deleteAllSubjects();
      }
      await SubjectService.instance.insertSubjects(subjects);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Import Successful'),
          content: Text('${subjects.length} subjects imported successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  selectedFile = null;
                  selectedFileName = null;
                  subjects.clear();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
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

  Widget buildHeader() {
    return Column(
      children: const [
        Icon(Icons.menu_book, size: 80, color: Colors.orange),
        SizedBox(height: 20),
        Text(
          'Import Subjects',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Import Subject Information from CSV File',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildFileCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedFileName ?? 'No CSV File Selected',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            if (subjects.isNotEmpty) ...[
              const Divider(height: 30),

              Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    'Subjects Found : ${subjects.length}',
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

  Widget buildSelectButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isImporting ? null : selectCsvFile,
        icon: const Icon(Icons.folder_open),
        label: const Text('Choose CSV File'),
      ),
    );
  }

  Widget buildImportButton() {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isImporting ? null : importSubjects,
        icon: isImporting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.upload),
        label: Text(isImporting ? 'Importing...' : 'Import Subjects'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Subjects'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          buildHeader(),

          const SizedBox(height: 30),

          buildFileCard(),
          Card(
            elevation: 3,
            child: CheckboxListTile(
              value: deleteExistingSubjects,
              title: const Text('Delete existing subjects before import'),
              subtitle: const Text('Recommended to avoid duplicate subjects.'),
              onChanged: (value) {
                setState(() {
                  deleteExistingSubjects = value ?? false;
                });
              },
            ),
          ),

          const SizedBox(height: 30),

          buildSelectButton(),

          const SizedBox(height: 16),

          buildImportButton(),
        ],
      ),
    );
  }
}
