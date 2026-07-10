import 'package:flutter/material.dart';

class ResultSummaryCard extends StatelessWidget {
  final int totalSubjects;
  final int totalMarks;
  final double averageMarks;
  final double gpa;
  final String grade;
  final bool isPass;

  const ResultSummaryCard({
    super.key,
    required this.totalSubjects,
    required this.totalMarks,
    required this.averageMarks,
    required this.gpa,
    required this.grade,
    required this.isPass,
  });

  Widget _buildRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = isPass ? Colors.green : Colors.red;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Result Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildRow('Total Subjects', totalSubjects.toString()),
            _buildRow('Total Marks', totalMarks.toString()),
            _buildRow('Average', averageMarks.toStringAsFixed(2)),
            _buildRow('GPA', gpa.toStringAsFixed(2)),
            _buildRow('Grade', grade, valueColor: Colors.indigo,),

            _buildRow('Status', isPass ? 'PASS' : 'FAIL', valueColor: statusColor,),
            
          ],
        ),
      ),
    );
  }
}
