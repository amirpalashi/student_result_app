import 'package:flutter/material.dart';

class TemplateDownloadScreen extends StatelessWidget {
  const TemplateDownloadScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Template'),
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