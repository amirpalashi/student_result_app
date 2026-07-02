import 'package:flutter/material.dart';

import '../custom_dropdown.dart';
import '../custom_textfield.dart';
import '../primary_button.dart';
import '../../core/constants/app_lists.dart';

class ResultSearchForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final String? session;
  final String? studentClass;
  final String? exam;

  final TextEditingController studentIdController;

  final ValueChanged<String?> onSessionChanged;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onExamChanged;

  final VoidCallback onSearch;
  final bool isLoading;

  const ResultSearchForm({
    super.key,
    required this.formKey,
    required this.session,
    required this.studentClass,
    required this.exam,
    required this.studentIdController,
    required this.onSessionChanged,
    required this.onClassChanged,
    required this.onExamChanged,
    required this.onSearch,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.manage_search_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find Student Result",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Select session, class, exam and enter the student ID to search the result.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            "Select the required information below.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 30),

          CustomDropdown<String>(
            label: "Academic Session",
            value: session,
            prefixIcon: Icons.calendar_today,
            entries: AppLists.academicSessions
                .map(
                  (session) =>
                      DropdownMenuEntry<String>(value: session, label: session),
                )
                .toList(),
            onSelected: onSessionChanged,
            validator: (value) {
              if (value == null) {
                return "Please select academic session";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          CustomDropdown<String>(
            label: "Class",
            value: studentClass,
            prefixIcon: Icons.school,
            entries: AppLists.classes
                .map(
                  (item) => DropdownMenuEntry<String>(value: item, label: item),
                )
                .toList(),
            onSelected: onClassChanged,
            validator: (value) {
              if (value == null) {
                return "Please select class";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          CustomDropdown<String>(
            label: "Exam",
            value: exam,
            prefixIcon: Icons.assignment,
            entries: AppLists.exams
                .map(
                  (item) => DropdownMenuEntry<String>(value: item, label: item),
                )
                .toList(),
            onSelected: onExamChanged,
            validator: (value) {
              if (value == null) {
                return "Please select exam";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: "Student ID",
            controller: studentIdController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.badge,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter Student ID";
              }

              if (int.tryParse(value.trim()) == null) {
                return "Student ID must be numeric";
              }

              return null;
            },
          ),

          const SizedBox(height: 30),

  
          PrimaryButton(
            text: isLoading ? "Searching..." : "Search Result",
            icon: isLoading ? Icons.hourglass_top : Icons.search,
            onPressed: isLoading ? null : onSearch,
          ),
        ],
      ),
    );
  }
}
