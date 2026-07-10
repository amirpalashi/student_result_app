import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/excel_service.dart';
import '../../../../services/subject_service.dart';

class SubjectExportScreen extends StatefulWidget {
  const SubjectExportScreen({super.key});

  @override
  State<SubjectExportScreen> createState() => _SubjectExportScreenState();
}

class _SubjectExportScreenState extends State<SubjectExportScreen> {
  bool _isExporting = false;

  Future<void> _exportSubjects() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final subjects = await SubjectService.instance.getAllSubjects();

      debugPrint('Total Subjects: ${subjects.length}');

      final file = await ExcelService.instance.exportSubjects(subjects);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Subject List Export',
          files: [XFile(file.path)],
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subjects exported successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
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
      appBar: AppBar(
        title: const Text('Export Subjects'),
        centerTitle: true,
      ),
      body: Center(
        child: _isExporting
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _exportSubjects,
                icon: const Icon(Icons.download),
                label: const Text('Export Subjects'),
              ),
      ),
    );
  }
}