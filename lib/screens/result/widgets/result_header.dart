import 'package:flutter/material.dart';

import '../../../core/constants/app_lists.dart';


class ResultHeader extends StatelessWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/college_logo.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.school,
                    size: 40,
                    color: Colors.blue,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            AppLists.collegeName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Official Student Result",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}