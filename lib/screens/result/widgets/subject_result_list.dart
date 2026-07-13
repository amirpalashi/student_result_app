import 'package:flutter/material.dart';

import '../../../models/subject_result_model.dart';
import '../../../services/subject_result_service.dart';

class SubjectResultList extends StatefulWidget {
  final String studentId;

  const SubjectResultList({super.key, required this.studentId});

  @override
  State<SubjectResultList> createState() => _SubjectResultListState();
}

class _SubjectResultListState extends State<SubjectResultList> {
  Future<List<SubjectResultModel>> _loadResults() {
    return SubjectResultService.instance.getSubjectResults(widget.studentId);
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green;

      case 'A':
        return Colors.green;

      case 'A-':
        return Colors.lightGreen;

      case 'B':
        return Colors.blue;

      case 'C':
        return Colors.orange;

      case 'D':
        return Colors.deepOrange;

      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubjectResultModel>>(
      future: _loadResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No Result Found')),
            ),
          );
        }

        final results = snapshot.data!;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Subject Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStatePropertyAll(
                      Colors.blue.shade50,
                    ),
                    columns: const [
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Marks')),
                      DataColumn(label: Text('Grade')),
                    ],
                    rows: results.map((result) {
                      return DataRow(
                        cells: [
                          DataCell(Text(result.subjectName)),
                          DataCell(
                            Text(
                              result.marks.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              result.grade,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _gradeColor(result.grade),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
