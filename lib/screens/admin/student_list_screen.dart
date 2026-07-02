import 'package:flutter/material.dart';

import '../../widgets/home_header.dart';
import '../../widgets/home/result_search_form.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';
import '../result/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  String? session;
  String? studentClass;
  String? exam;

  final TextEditingController studentIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    studentIdController.dispose();
    super.dispose();
  }

  Future<void> _searchStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (session == null || studentClass == null || exam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Session, Class and Exam.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final StudentModel? student = await StudentService.instance.searchStudent(
      studentId: studentIdController.text.trim(),
      session: session!,
      className: studentClass!,
      exam: exam!,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (student == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Student not found.")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(student: student)),
    );

    // Result Screen Navigation
    // Step 10
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),

              Transform.translate(
                offset: const Offset(0, -40),
                child: Transform.translate(
                  offset: const Offset(0, -45),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(28),
                              child: ResultSearchForm(
                                formKey: _formKey,
                                session: session,
                                studentClass: studentClass,
                                exam: exam,
                                studentIdController: studentIdController,
                                isLoading: _isLoading,
                                onSessionChanged: (value) {
                                  setState(() => session = value);
                                },
                                onClassChanged: (value) {
                                  setState(() => studentClass = value);
                                },
                                onExamChanged: (value) {
                                  setState(() => exam = value);
                                },
                                onSearch: _searchStudent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "© 2026 Student Result App",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
