import 'dart:io';

import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
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
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
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
                width: 82,
                height: 82,
                child: settings?.logoPath != null &&
                        settings!.logoPath!.isNotEmpty
                    ? Image.file(
                        File(settings!.logoPath!),
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/images/college_logo.png",
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            settings?.organizationName.isNotEmpty == true
                ? settings!.organizationName
                : AppStrings.collegeName,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Student Result Management System",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),

          if (settings != null && settings!.address.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              settings!.address,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white24,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  "Academic Result Portal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}