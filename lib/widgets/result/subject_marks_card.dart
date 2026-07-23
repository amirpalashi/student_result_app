import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/subject_model.dart';

class SubjectMarksCard extends StatelessWidget {
  final SubjectModel subject;
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const SubjectMarksCard({
    super.key,
    required this.subject,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final marks = int.tryParse(controller.text);

    String? errorText;

    if (marks != null && marks > subject.fullMarks) {
      errorText = "Maximum ${subject.fullMarks}";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  subject.subjectName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(
                width: 85,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: "0",
                    isDense: true,
                    errorText: errorText,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) {
                    onChanged?.call();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
