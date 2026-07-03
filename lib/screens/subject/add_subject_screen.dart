import 'package:flutter/material.dart';
import '../../models/subject_model.dart';
import '../../services/subject_service.dart';

class AddSubjectScreen extends StatefulWidget {
  final String className;
  final String groupName;
  final SubjectModel? subject;

  const AddSubjectScreen({
    super.key,
    required this.className,
    required this.groupName,
    this.subject,
  });

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _fullMarksController = TextEditingController(text: '100');
  final _passMarksController = TextEditingController(text: '33');
  @override
  void initState() {
    super.initState();

    if (widget.subject != null) {
      _subjectController.text = widget.subject!.subjectName;
      _fullMarksController.text = widget.subject!.fullMarks.toString();
      _passMarksController.text = widget.subject!.passMarks.toString();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _fullMarksController.dispose();
    _passMarksController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final subject = SubjectModel(
      id: widget.subject?.id,
      className: widget.className,
      groupName: widget.groupName,
      subjectName: _subjectController.text.trim(),
      fullMarks: int.parse(_fullMarksController.text),
      passMarks: int.parse(_passMarksController.text),
    );

    if (widget.subject == null) {
      await SubjectService.instance.insertSubject(subject);
    } else {
      await SubjectService.instance.updateSubject(subject);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.subject == null
              ? 'Subject added successfully'
              : 'Subject updated successfully',
        ),
      ),
    );

    Navigator.pop(context, true);
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subject == null ? 'Add Subject' : 'Edit Subject',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.className,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Class',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: widget.groupName,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Group',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter subject name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _fullMarksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Full Marks',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passMarksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pass Marks',
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSubject,
                  child: Text(
                    widget.subject == null
                        ? 'Save Subject'
                        : 'Update Subject',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
