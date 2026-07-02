import 'package:flutter/material.dart';

class ResultActionButtons extends StatelessWidget {
  const ResultActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("PDF Export coming soon"),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("PDF"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Print feature coming soon"),
                ),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text("Print"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Share feature coming soon"),
                ),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text("Share"),
          ),
        ),
      ],
    );
  }
}