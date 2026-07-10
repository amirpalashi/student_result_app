import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/subject_model.dart';
import '../../services/grade_service.dart';

class SubjectMarksCard extends StatefulWidget {
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
  State<SubjectMarksCard> createState() => _SubjectMarksCardState();
}

class _SubjectMarksCardState extends State<SubjectMarksCard> {
  @override
  Widget build(BuildContext context) {
    final marks = int.tryParse(widget.controller.text);

    String grade = '-';
    double gradePoint = 0.0;
    String? errorText;

    if (marks != null) {
      if (marks > widget.subject.fullMarks) {
        errorText = 'Marks cannot exceed ${widget.subject.fullMarks}';
      } else {
        grade = GradeService.calculateGrade(marks);
        gradePoint = GradeService.calculateGradePoint(marks);
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.subject.subjectName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Text("Full Marks : ${widget.subject.fullMarks}"),
                ),
                Expanded(
                  child: Text("Pass Marks : ${widget.subject.passMarks}"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: widget.controller,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {});
                widget.onChanged?.call();
              },
              decoration: InputDecoration(
                labelText: "Obtained Marks",
                prefixIcon: const Icon(Icons.edit),

                errorText: errorText,

                helperText: "Maximum ${widget.subject.fullMarks} marks",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Grade",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          grade,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "GPA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          gradePoint.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
