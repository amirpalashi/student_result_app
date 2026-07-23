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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Table(
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2.8),
                  1: FlexColumnWidth(1.1),
                  2: FlexColumnWidth(1.1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                    ),
                    children: const [
                      _HeaderCell("Subject"),
                      _HeaderCell("Marks"),
                      _HeaderCell("Grade"),
                    ],
                  ),

                  ...results.map(
                    (e) => TableRow(
                      children: [
                        _SubjectCell(e.subjectName),
                        _CenterCell(e.marks.toString()),
                        _GradeCell(
                          grade: e.grade,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _SubjectCell extends StatelessWidget {
  final String text;

  const _SubjectCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CenterCell extends StatelessWidget {
  final String text;

  const _CenterCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GradeCell extends StatelessWidget {
  final String grade;
  final Color color;

  const _GradeCell({
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 4,
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            grade,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}