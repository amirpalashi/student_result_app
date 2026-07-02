import 'package:flutter/material.dart';

import '../../../models/subject_result_model.dart';
import '../../../services/subject_result_service.dart';

class SubjectResultCard extends StatelessWidget {
  final String studentId;

  const SubjectResultCard({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SubjectResultModel>>(
      future: SubjectResultService.instance.getSubjectResults(studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Error: ${snapshot.error}",
              ),
            ),
          );
        }

        final subjects = snapshot.data ?? [];

        if (subjects.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text("No subject result found."),
              ),
            ),
          );
        }

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Subject-wise Result",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.2),
                  },
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Subject",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Marks",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Grade",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    ...subjects.map(
                      (subject) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(subject.subjectName),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              subject.marks.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              subject.grade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}