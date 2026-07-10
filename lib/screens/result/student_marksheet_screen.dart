import 'package:flutter/material.dart';
import '../../services/pdf/marksheet_pdf_service.dart';

import '../../models/student_model.dart';
import '../../services/student_service.dart';
import '../../widgets/app_selector.dart';
import '../../core/constants/app_lists.dart';
import '../../widgets/result/student_info_card.dart';
import '../../models/subject_result_model.dart';
import '../../services/subject_result_service.dart';
import '../../widgets/result/school_header.dart';
import '../../widgets/result/result_subjects_card.dart';
import '../../models/result_summary_model.dart';
import '../../widgets/result/result_summary_card.dart';

class StudentMarksheetScreen extends StatefulWidget {
  const StudentMarksheetScreen({super.key});

  @override
  State<StudentMarksheetScreen> createState() => _StudentMarksheetScreenState();
}

class _StudentMarksheetScreenState extends State<StudentMarksheetScreen> {
  String? session;
  String? exam;
  String? studentClass;
  String? group;

  List<StudentModel> students = [];
  StudentModel? selectedStudent;
  List<SubjectResultModel> subjectResults = [];
  ResultSummaryModel? summary;

  Future<void> loadResults() async {
    if (selectedStudent == null) {
      return;
    }

    final results = await SubjectResultService.instance.getSubjectResults(
      selectedStudent!.studentId,
    );

    final resultSummary = await SubjectResultService.instance.getResultSummary(
      selectedStudent!.studentId,
    );

    if (!mounted) return;

    setState(() {
      subjectResults = results;
      summary = resultSummary;
    });
  }

  Future<void> _shareMarksheet() async {
    if (selectedStudent == null || summary == null) {
      return;
    }

    await MarksheetPdfService.share(
      student: selectedStudent!,
      results: subjectResults,
      summary: summary!,
    );
  }

  Future<void> _printMarksheet() async {
    if (selectedStudent == null || summary == null) {
      return;
    }

    await MarksheetPdfService.print(
      student: selectedStudent!,
      results: subjectResults,
      summary: summary!,
    );
  }

  Future<void> loadStudents() async {
    if (session == null || exam == null || studentClass == null) {
      return;
    }

    final hasGroup =
        studentClass == 'Class 9' ||
        studentClass == 'Class 10' ||
        studentClass == 'Class XI' ||
        studentClass == 'Class XII';

    if (hasGroup && group == null) {
      return;
    }

    final result = await StudentService.instance.getStudentsForResult(
      session: session!,
      exam: exam!,
      className: studentClass!,
      groupName: group ?? '',
    );

    if (!mounted) return;

    setState(() {
      students = result;
      selectedStudent = null;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Marksheet'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SchoolHeader(schoolName: AppLists.collegeName),

          const SizedBox(height: 20),

          AppSelector<String>(
            label: 'Session',
            icon: Icons.calendar_today,
            value: session,
            items: AppLists.academicSessions,
            itemLabel: (item) => item,
            onChanged: (value) async {
              setState(() {
                session = value;
                selectedStudent = null;
                students.clear();
              });

              await loadStudents();
            },
          ),

          const SizedBox(height: 16),

          AppSelector<String>(
            label: 'Exam',
            icon: Icons.assignment,
            value: exam,
            items: AppLists.exams,
            itemLabel: (item) => item,
            onChanged: (value) async {
              setState(() {
                exam = value;
                selectedStudent = null;
                students.clear();
              });

              await loadStudents();
            },
          ),

          const SizedBox(height: 16),

          AppSelector<String>(
            label: 'Class',
            icon: Icons.school,
            value: studentClass,
            items: AppLists.classes,
            itemLabel: (item) => item,
            onChanged: (value) async {
              setState(() {
                studentClass = value;
                group = null;
                selectedStudent = null;
                students.clear();
              });

              await loadStudents();
            },
          ),

          if (studentClass == 'Class 9' ||
              studentClass == 'Class 10' ||
              studentClass == 'Class XI' ||
              studentClass == 'Class XII') ...[
            const SizedBox(height: 16),

            AppSelector<String>(
              label: 'Group',
              icon: Icons.groups,
              value: group,
              items: AppLists.groups,
              itemLabel: (item) => item,
              onChanged: (value) async {
                setState(() {
                  group = value;
                  selectedStudent = null;
                  students.clear();
                });

                await loadStudents();
              },
            ),
          ],

          const SizedBox(height: 16),

          AppSelector<StudentModel>(
            label: 'Student',
            icon: Icons.person,
            value: selectedStudent,
            items: students,
            itemLabel: (student) =>
                '${student.roll} - ${student.studentName} (${student.studentId})',
            onChanged: (student) async {
              setState(() {
                selectedStudent = student;
              });

              await loadResults();
            },
          ),

          const SizedBox(height: 20),

          if (selectedStudent != null)
            StudentInfoCard(student: selectedStudent!),

          if (subjectResults.isNotEmpty) ...[
            const SizedBox(height: 20),
            ResultSubjectsCard(results: subjectResults),
          ],

          if (summary != null) ...[
            const SizedBox(height: 20),
            ResultSummaryCard(
              totalSubjects: summary!.totalSubjects,
              totalMarks: summary!.totalMarks,
              averageMarks: summary!.averageMarks,
              gpa: summary!.gpa,
              grade: summary!.grade,
              isPass: summary!.isPass,
            ),
          ],
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _printMarksheet,
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _shareMarksheet,
                icon: const Icon(Icons.share),
                label: const Text('Share PDF'),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
