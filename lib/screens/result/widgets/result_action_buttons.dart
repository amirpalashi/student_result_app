import 'package:flutter/material.dart';

import '../../../models/student_model.dart';
import '../../../models/subject_result_model.dart';
import '../../../models/result_summary_model.dart';
import '../../../services/pdf/marksheet_pdf_service.dart';

class ResultActionButtons extends StatelessWidget {
  final StudentModel student;
  final List<SubjectResultModel> results;
  final ResultSummaryModel summary;

  const ResultActionButtons({
    super.key,
    required this.student,
    required this.results,
    required this.summary,
  });

  Future<void> _print() async {
    await MarksheetPdfService.print(
      student: student,
      results: results,
      summary: summary,
    );
  }

  Future<void> _share() async {
    await MarksheetPdfService.share(
      student: student,
      results: results,
      summary: summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _print,
              icon: const Icon(Icons.print),
              label: const Text('Print Result'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.share),
              label: const Text('Share Result'),
            ),
          ],
        ),
      ),
    );
  }
}