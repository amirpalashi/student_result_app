import 'dart:io';
import 'package:flutter/material.dart';
import '../models/school_settings_model.dart';
import '../services/school_settings_service.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Material(
            elevation: 8,
            shape: const CircleBorder(),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 90,
                height: 90,
                child:
                    settings?.logoPath != null && settings!.logoPath!.isNotEmpty
                    ? Image.file(File(settings!.logoPath!), fit: BoxFit.contain)
                    : Image.asset(
                        "assets/images/college_logo.png",
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Student Result Management",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            settings?.organizationName.isNotEmpty == true
                ? settings!.organizationName
                : "Your Institution Name",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (settings != null && settings!.address.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              settings!.address,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
