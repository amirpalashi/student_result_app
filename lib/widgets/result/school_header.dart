import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/school_settings_model.dart';
import '../../services/school_settings_service.dart';

class SchoolHeader extends StatefulWidget {
  final String schoolName;
  final String title;

  const SchoolHeader({
    super.key,
    required this.schoolName,
    this.title = 'Academic Transcript',
  });

  @override
  State<SchoolHeader> createState() => _SchoolHeaderState();
}

class _SchoolHeaderState extends State<SchoolHeader> {
  SchoolSettingsModel? settings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    settings = await SchoolSettingsService.instance.getSettings();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade100,
              child: settings?.logoPath != null &&
                      settings!.logoPath!.isNotEmpty
                  ? ClipOval(
                      child: Image.file(
                        File(settings!.logoPath!),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.school,
                      size: 36,
                    ),
            ),

            const SizedBox(height: 12),

            Text(
              settings?.organizationName.isNotEmpty == true
                  ? settings!.organizationName
                  : widget.schoolName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (settings != null && settings!.address.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                settings!.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],

            if (settings != null &&
                (settings!.phone.isNotEmpty || settings!.eiin.isNotEmpty)) ...[
              const SizedBox(height: 4),
              Text(
                'Phone: ${settings!.phone}    EIIN: ${settings!.eiin}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ],

            if (settings != null && settings!.website.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                settings!.website,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 13,
                ),
              ),
            ],

            const SizedBox(height: 10),

            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}