import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../services/subject_result_service.dart';

import 'widgets/result_header.dart';
import 'widgets/student_info_card.dart';
import '../../widgets/result/result_summary_card.dart';
import 'widgets/result_action_buttons.dart';
import '../../models/result_summary_model.dart';
import '../../widgets/result/result_subjects_card.dart';
import '../../models/subject_result_model.dart';

class ResultViewScreen extends StatefulWidget {
  final StudentModel student;

  const ResultViewScreen({super.key, required this.student});

  @override
  State<ResultViewScreen> createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  List<SubjectResultModel> _results = [];
  ResultSummaryModel? _summary;

  bool _isLoading = true;

  int _totalMarks = 0;
  int _totalSubjects = 0;

  double _averageMarks = 0;

  double _gpa = 0;

  String _grade = 'F';

  bool _isPass = false;

  @override
  void initState() {
    super.initState();
    _loadResultSummary();
  }

  Future<void> _loadResultSummary() async {
    final results = await SubjectResultService.instance.getSubjectResults(
      widget.student.studentId,
    );

    final summary = await SubjectResultService.instance.getResultSummary(
      widget.student.studentId,
    );

    if (!mounted) return;

    setState(() {
      _results = results;
      _summary = summary;

      _totalSubjects = summary.totalSubjects;
      _totalMarks = summary.totalMarks;
      _averageMarks = summary.averageMarks;
      _gpa = summary.gpa;
      _grade = summary.grade;
      _isPass = summary.isPass;

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Marksheet'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const ResultHeader(),

                  const SizedBox(height: 20),

                  StudentInfoCard(student: widget.student),

                  const SizedBox(height: 20),

                  ResultSubjectsCard(results: _results),

                  const SizedBox(height: 20),

                  ResultSummaryCard(
                    totalSubjects: _totalSubjects,
                    totalMarks: _totalMarks,
                    averageMarks: _averageMarks,
                    gpa: _gpa,
                    grade: _grade,
                    isPass: _isPass,
                  ),

                  const SizedBox(height: 20),

                
                  if (_summary != null)
                    ResultActionButtons(
                      student: widget.student,
                      results: _results,
                      summary: _summary!,
                    ),
                ],
              ),
            ),
    );
  }
}
