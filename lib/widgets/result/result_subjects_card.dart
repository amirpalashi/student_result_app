import 'package:flutter/material.dart';

import '../../models/subject_result_model.dart';

class ResultSubjectsCard extends StatelessWidget {
  final List<SubjectResultModel> results;

  const ResultSubjectsCard({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Subject Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            DataTable(
              columns: const [
                DataColumn(label: Text('Subject')),
                DataColumn(label: Text('Marks')),
                DataColumn(label: Text('Grade')),
              ],
              rows: results
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.subjectName)),
                        DataCell(Text(e.marks.toString())),
                        DataCell(Text(e.grade)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}