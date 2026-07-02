import 'package:flutter/material.dart';

class GpaCard extends StatelessWidget {
  final double gpa;

  const GpaCard({
    super.key,
    required this.gpa,
  });

  String get grade {
    if (gpa >= 5.0) return "A+";
    if (gpa >= 4.0) return "A";
    if (gpa >= 3.5) return "A-";
    if (gpa >= 3.0) return "B";
    if (gpa >= 2.0) return "C";
    if (gpa >= 1.0) return "D";
    return "F";
  }

  Color get statusColor {
    return gpa > 0 ? Colors.green : Colors.red;
  }

  String get status {
    return gpa > 0 ? "PASSED" : "FAILED";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Result Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              gpa.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Grade : $grade",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Chip(
              backgroundColor: statusColor.withValues(alpha: 0.12),
              label: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}