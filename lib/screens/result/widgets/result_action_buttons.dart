import 'package:flutter/material.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key});

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
              onPressed: () {},
              icon: const Icon(Icons.print),
              label: const Text('Print Result'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('Share Result'),
            ),
          ],
        ),
      ),
    );
  }
}