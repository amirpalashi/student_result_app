import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../services/student_service.dart';

import '../../widgets/app_selector.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';

import '../../core/constants/app_lists.dart';
import 'package:flutter/services.dart';

class AddStudentScreen extends StatefulWidget {
  final StudentModel? student;

  const AddStudentScreen({super.key, this.student});

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
  final mobileController = TextEditingController();

  String? session;
  String? studentClass;
  String? exam;
  String? group;

  bool _isSaving = false;

  bool get isEdit => widget.student != null;
  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final student = widget.student!;

      studentIdController.text = student.studentId;
      studentNameController.text = student.studentName;
      fatherNameController.text = student.fatherName;
      motherNameController.text = student.motherName;
      rollController.text = student.roll;
      mobileController.text = student.mobile ?? "";

      session = student.session;
      studentClass = student.className;
      exam = student.exam;
      group = student.groupName;
    }
  }

  @override
  void dispose() {
    studentIdController.dispose();
    studentNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    rollController.dispose();
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
      groupName: group ?? '',
      mobile: mobileController.text.trim(),
      gpa: 0.0,
    );

    if (isEdit) {
      await StudentService.instance.updateStudent(
        student.copyWith(id: widget.student!.id),
      );
    } else {
      await StudentService.instance.insertStudent(student);
    }
    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? "Student updated successfully."
              : "Student added successfully.",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Student" : "Add Student"),
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

              AppSelector<String>(
                label: "Academic Session",
                icon: Icons.calendar_today,
                value: session,
                items: AppLists.academicSessions,
                itemLabel: (item) => item,
                onChanged: (value) {
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

              AppSelector<String>(
                label: "Class",
                icon: Icons.school,
                value: studentClass,
                items: AppLists.classes,
                itemLabel: (item) => item,
                onChanged: (value) {
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

              AppSelector<String>(
                label: "Exam",
                icon: Icons.assignment,
                value: exam,
                items: AppLists.exams,
                itemLabel: (item) => item,
                onChanged: (value) {
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

              CustomTextField(label: "Roll", controller: rollController),

              const SizedBox(height: 16),

              if (studentClass == "Class 9" ||
                  studentClass == "Class 10" ||
                  studentClass == "Class XI" ||
                  studentClass == "Class XII")
                Column(
                  children: [
                    AppSelector<String>(
                      label: "Group",
                      icon: Icons.groups,
                      value: group,
                      items: AppLists.groups,
                      itemLabel: (item) => item,
                      onChanged: (value) {
                        setState(() => group = value);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Mobile",
                controller: mobileController,
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) {
                  final mobile = value?.trim() ?? '';

                  // Mobile না দিলেও হবে
                  if (mobile.isEmpty) {
                    return null;
                  }

                  // অবশ্যই 01 দিয়ে শুরু এবং ১১ ডিজিট হতে হবে
                  if (!RegExp(r'^01\d{9}$').hasMatch(mobile)) {
                    return 'Enter a valid 11-digit mobile number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: _isSaving
                    ? "Saving..."
                    : isEdit
                    ? "Update Student"
                    : "Save Student",
                icon: _isSaving ? Icons.hourglass_top : Icons.save,
                onPressed: _isSaving ? () {} : _saveStudent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
