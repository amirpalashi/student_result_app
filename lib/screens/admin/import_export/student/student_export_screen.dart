import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/student_service.dart';
import '../../../../services/excel_service.dart';

class StudentExportScreen extends StatefulWidget {
  const StudentExportScreen({super.key});

  @override
  State<StudentExportScreen> createState() => _StudentExportScreenState();
}

class _StudentExportScreenState extends State<StudentExportScreen> {
  bool _isExporting = false;

  Future<void> _exportStudents() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final students = await StudentService.instance.getAllStudents();

      debugPrint('Total Students: ${students.length}');

      for (final s in students) {
        debugPrint('${s.studentId} - ${s.studentName}');
      }

      final file = await ExcelService.instance.exportStudents(students);

      await SharePlus.instance.share(
        ShareParams(text: 'Student List Export', files: [XFile(file.path)]),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Students exported successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }

    if (mounted) {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Students'), centerTitle: true),
      body: Center(
        child: _isExporting
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _exportStudents,
                icon: const Icon(Icons.download),
                label: const Text('Export Students'),
              ),
      ),
    );
  }
}
