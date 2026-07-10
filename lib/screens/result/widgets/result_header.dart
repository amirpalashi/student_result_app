import 'package:flutter/material.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 35,
              child: Icon(
                Icons.school,
                size: 38,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'PALASH RESIDENTIAL MODEL COLLEGE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Palash, Narsingdi',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Academic Result Sheet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            const Divider(thickness: 1.2),
          ],
        ),
      ),
    );
  }
}