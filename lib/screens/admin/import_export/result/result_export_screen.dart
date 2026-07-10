import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/excel_service.dart';
import '../../../../services/subject_result_service.dart';

class ResultExportScreen extends StatefulWidget {
  const ResultExportScreen({super.key});

  @override
  State<ResultExportScreen> createState() => _ResultExportScreenState();
}

class _ResultExportScreenState extends State<ResultExportScreen> {
  bool _isExporting = false;

  Future<void> _exportResults() async {
    setState(() {
      _isExporting = true;
    });

    try {
      final results = await SubjectResultService.instance.getAllResults();

      debugPrint('Total Results: ${results.length}');

      final file = await ExcelService.instance.exportResults(results);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Student Result Export',
          files: [XFile(file.path)],
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Results exported successfully.'),
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
        title: const Text('Export Results'),
        centerTitle: true,
      ),
      body: Center(
        child: _isExporting
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _exportResults,
                icon: const Icon(Icons.download),
                label: const Text('Export Results'),
              ),
      ),
    );
  }
}