import 'package:flutter/material.dart';

import '../../core/constants/app_lists.dart';
import '../../models/student_model.dart';
import '../../services/student_service.dart';

import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final studentIdController = TextEditingController();
  final studentNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final rollController = TextEditingController();
  final groupController = TextEditingController();
  final mobileController = TextEditingController();

  String? session;
  String? studentClass;
  String? exam;

  bool _isSaving = false;

  @override
  void dispose() {
    studentIdController.dispose();
    studentNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    rollController.dispose();
    groupController.dispose();
    mobileController.dispose();
    super.dispose();
  }
    Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final student = StudentModel(
      studentId: studentIdController.text.trim(),
      studentName: studentNameController.text.trim(),
      fatherName: fatherNameController.text.trim(),
      motherName: motherNameController.text.trim(),
      session: session!,
      className: studentClass!,
      exam: exam!,
      roll: rollController.text.trim(),
      groupName: groupController.text.trim(),
      mobile: mobileController.text.trim(),
      gpa: 0.0,
    );

    await StudentService.instance.insertStudent(student);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student added successfully."),
      ),
    );

    Navigator.pop(context);
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              CustomTextField(
                label: "Student ID",
                controller: studentIdController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Student Name",
                controller: studentNameController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Father Name",
                controller: fatherNameController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Mother Name",
                controller: motherNameController,
              ),

              const SizedBox(height: 16),

              CustomDropdown<String>(
                label: "Academic Session",
                value: session,
                prefixIcon: Icons.calendar_today,
                entries: AppLists.academicSessions
                    .map(
                      (e) => DropdownMenuEntry(
                        value: e,
                        label: e,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  setState(() => session = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Select Session";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomDropdown<String>(
                label: "Class",
                value: studentClass,
                prefixIcon: Icons.school,
                entries: AppLists.classes
                    .map(
                      (e) => DropdownMenuEntry(
                        value: e,
                        label: e,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  setState(() => studentClass = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Select Class";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomDropdown<String>(
                label: "Exam",
                value: exam,
                prefixIcon: Icons.assignment,
                entries: AppLists.exams
                    .map(
                      (e) => DropdownMenuEntry(
                        value: e,
                        label: e,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  setState(() => exam = value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Select Exam";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Roll",
                controller: rollController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Group",
                controller: groupController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Mobile",
                controller: mobileController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: _isSaving ? "Saving..." : "Save Student",
                icon: _isSaving
                    ? Icons.hourglass_top
                    : Icons.save,
                onPressed: _isSaving
                    ? () {}
                    : _saveStudent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}