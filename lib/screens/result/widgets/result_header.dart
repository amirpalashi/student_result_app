import 'package:flutter/material.dart';
import 'dart:io';

import '../../../models/school_settings_model.dart';
import '../../../services/school_settings_service.dart';

class ResultHeader extends StatefulWidget {
  const ResultHeader({super.key});

  @override
  State<ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<ResultHeader> {
  SchoolSettingsModel? _settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SchoolSettingsService.instance.getSettings();

    if (!mounted) return;

    setState(() {
      _settings = settings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage:
                  (_settings?.logoPath != null &&
                      _settings!.logoPath!.isNotEmpty)
                  ? FileImage(File(_settings!.logoPath!))
                  : null,
              child:
                  (_settings?.logoPath == null || _settings!.logoPath!.isEmpty)
                  ? const Icon(Icons.school, size: 38)
                  : null,
            ),

            const SizedBox(height: 16),

            Text(
              (_settings?.organizationName.isNotEmpty ?? false)
                  ? _settings!.organizationName
                  : 'ORGANIZATION NAME',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              (_settings?.address.isNotEmpty ?? false)
                  ? _settings!.address
                  : 'Palash, Narsingdi',
              style: TextStyle(color: Colors.grey.shade700),
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
