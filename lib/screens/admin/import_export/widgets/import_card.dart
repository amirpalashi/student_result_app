import 'package:flutter/material.dart';

class ImportCard extends StatelessWidget {
  const ImportCard ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Card'),
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