import 'package:flutter/material.dart';

class ExportCard extends StatelessWidget {
  const ExportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Card'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Coming Soon...',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}