import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../services/student_service.dart';
import '../../widgets/app_selector.dart';
import '../../models/subject_model.dart';
import '../../services/subject_service.dart';
import '../../widgets/result/result_entry_student_card.dart';
import '../../widgets/result/subject_marks_card.dart';
import '../../models/subject_result_model.dart';
import '../../services/subject_result_service.dart';
import '../../services/grade_service.dart';
import '../../widgets/result/result_summary_card.dart';
import '../../core/constants/app_lists.dart';

class ResultEntryScreen extends StatefulWidget {
  const ResultEntryScreen({super.key});

  @override
  State<ResultEntryScreen> createState() => _ResultEntryScreenState();
}

class _ResultEntryScreenState extends State<ResultEntryScreen> {
  String? session;
  String? exam;
  String? studentClass;
  String? group;
  StudentModel? selectedStudent;
  int _currentStudentIndex = -1;
  List<StudentModel> students = [];

  final Map<int, TextEditingController> _controllers = {};

  StudentModel? _selectedStudent;
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  Future<void> _loadSubjects() async {
    if (_selectedStudent == null) {
      return;
    }

    final data = await SubjectService.instance.getSubjects(
      className: _selectedStudent!.className,
      groupName: _selectedStudent!.groupName,
    );

    if (!mounted) return;

    setState(() {
      _subjects = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> loadStudents() async {
    if (session == null || exam == null || studentClass == null) {
      return;
    }

    final bool hasGroup =
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

  Future<void> _loadStudents() async {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveResults() async {
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a student')));

      return;
    }

    // Local variable ব্যবহার করলে async warning হবে না
    final student = _selectedStudent!;

    final List<SubjectResultModel> results = [];

    for (final subject in _subjects) {
      final controller = _controllers[subject.id!];

      if (controller == null || controller.text.trim().isEmpty) {
        continue;
      }

      final marks = int.parse(controller.text);

      final existing = await SubjectResultService.instance.getSubjectResult(
        studentId: student.studentId,
        subjectName: subject.subjectName,
      );

      results.add(
        SubjectResultModel(
          id: existing?.id,
          studentId: student.studentId,
          subjectName: subject.subjectName,
          fullMarks: subject.fullMarks,
          passMarks: subject.passMarks,
          marks: marks,
          grade: GradeService.calculateGrade(marks),
          gradePoint: GradeService.calculateGradePoint(marks),
        ),
      );
    }

    if (results.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter marks first')));
      return;
    }

    await SubjectResultService.instance.insertAllResults(results);

    if (!mounted) return;

    if (_currentStudentIndex < students.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Results saved successfully. Moving to next student...',
          ),
          duration: Duration(seconds: 1),
        ),
      );

      if (!mounted) return;
      await _nextStudent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🎉 All students' results have been completed."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadSavedResults() async {
    if (_selectedStudent == null) return;

    final results = await SubjectResultService.instance.getSubjectResults(
      _selectedStudent!.studentId,
    );

    // পুরোনো Marks Clear
    for (final controller in _controllers.values) {
      controller.clear();
    }

    // Database থেকে পাওয়া Marks Controller-এ বসানো
    for (final result in results) {
      final subject = _subjects.firstWhere(
        (s) => s.subjectName == result.subjectName,
        orElse: () => SubjectModel(
          id: -1,
          className: '',
          groupName: '',
          subjectName: '',
          fullMarks: 0,
          passMarks: 0,
        ),
      );

      if (subject.id != -1) {
        _controllers.putIfAbsent(subject.id!, () => TextEditingController());

        _controllers[subject.id!]!.text = result.marks.toString();
      }
    }

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _nextStudent() async {
    if (_currentStudentIndex >= students.length - 1) {
      return;
    }

    final student = students[_currentStudentIndex + 1];

    setState(() {
      _currentStudentIndex++;
      selectedStudent = student;
      _selectedStudent = student;
    });

    await _loadSubjects();
    await _loadSavedResults();
  }

  Future<void> _previousStudent() async {
    if (_currentStudentIndex <= 0) {
      return;
    }

    final student = students[_currentStudentIndex - 1];

    setState(() {
      _currentStudentIndex--;
      selectedStudent = student;
      _selectedStudent = student;
    });

    await _loadSubjects();
    await _loadSavedResults();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _totalMarks {
    int total = 0;

    for (final controller in _controllers.values) {
      total += int.tryParse(controller.text) ?? 0;
    }

    return total;
  }

  double get _gpa {
    double total = 0;
    int count = 0;

    for (final controller in _controllers.values) {
      final marks = int.tryParse(controller.text);

      if (marks != null) {
        total += GradeService.calculateGradePoint(marks);
        count++;
      }
    }

    if (count == 0) return 0;

    return total / count;
  }

  String get _finalGrade {
    final gpa = _gpa;

    if (gpa >= 5.0) return 'A+';
    if (gpa >= 4.0) return 'A';
    if (gpa >= 3.5) return 'A-';
    if (gpa >= 3.0) return 'B';
    if (gpa >= 2.0) return 'C';
    if (gpa >= 1.0) return 'D';

    return 'F';
  }

  bool get _isPass {
    for (final subject in _subjects) {
      final controller = _controllers[subject.id!];

      if (controller == null || controller.text.isEmpty) {
        continue;
      }

      final marks = int.tryParse(controller.text);

      if (marks != null && marks < subject.passMarks) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Entry'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Student Selection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                AppSelector<String>(
                  label: "Session",
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
                  label: "Exam",
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
                  label: "Class",
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
                if (studentClass == "Class 9" ||
                    studentClass == "Class 10" ||
                    studentClass == "Class XI" ||
                    studentClass == "Class XII")
                  AppSelector<String>(
                    label: "Group",
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
                      _selectedStudent = student;
                      _currentStudentIndex = students.indexOf(student);
                    });

                    await _loadSubjects();
                    await _loadSavedResults();
                  },
                ),

                const SizedBox(height: 16),

                const SizedBox(height: 20),

                if (_selectedStudent != null)
                  ResultEntryStudentCard(student: _selectedStudent!),

                const SizedBox(height: 20),

                const Text(
                  'Subjects',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                if (_subjects.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('No Subject Found')),
                    ),
                  )
                else
                  ..._subjects.map((subject) {
                    _controllers.putIfAbsent(
                      subject.id!,
                      () => TextEditingController(),
                    );

                    return SubjectMarksCard(
                      subject: subject,
                      controller: _controllers[subject.id!]!,
                      onChanged: () {
                        setState(() {});
                      },
                    );
                  }),

                const SizedBox(height: 20),
                if (_selectedStudent != null && _subjects.isNotEmpty)
                  ResultSummaryCard(
                    totalSubjects: _subjects.length,
                    totalMarks: _totalMarks,
                    averageMarks: _subjects.isEmpty
                        ? 0
                        : _totalMarks / _subjects.length,
                    gpa: _gpa,
                    grade: _finalGrade,
                    isPass: _isPass,
                  ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _currentStudentIndex <= 0
                            ? null
                            : _previousStudent,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentStudentIndex >= students.length - 1
                            ? null
                            : _nextStudent,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: _saveResults,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Save Result',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
