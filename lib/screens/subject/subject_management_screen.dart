import 'package:flutter/material.dart';

import '../../core/constants/app_classes.dart';
import '../../models/subject_model.dart';
import '../../services/subject_service.dart';
import '../../widgets/app_selector.dart';
import 'add_subject_screen.dart';
import '../../core/utils/education_helper.dart';

class SubjectManagementScreen extends StatefulWidget {
  const SubjectManagementScreen({super.key});

  @override
  State<SubjectManagementScreen> createState() =>
      _SubjectManagementScreenState();
}

class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
  String? _selectedClass;
  String? _selectedGroup;

  List<SubjectModel> _subjects = [];

  bool _isLoading = false;

  Future<void> _loadSubjects() async {
    if (_selectedClass == null || _selectedGroup == null) {
      setState(() {
        _subjects = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = await SubjectService.instance.getSubjects(
      className: _selectedClass!,
      groupName: _selectedGroup!,
    );

    setState(() {
      _subjects = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteSubject(SubjectModel subject) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: Text(
            'Are you sure you want to delete "${subject.subjectName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await SubjectService.instance.deleteSubject(subject.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subject deleted successfully')),
    );

    await _loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Management'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          if (_selectedClass == null || _selectedGroup == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select Class and Group first.'),
              ),
            );
            return;
          }

          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddSubjectScreen(
                className: _selectedClass!,
                groupName: _selectedGroup!,
              ),
            ),
          );

          if (result == true) {
            await _loadSubjects();
          }
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSelector<String>(
              label: 'Class',
              icon: Icons.school,
              value: _selectedClass,
              items: AppClasses.values,
              itemLabel: (item) => item,
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;

                  if (!EducationHelper.hasGroup(value)) {
                    _selectedGroup = 'General';
                  } else {
                    _selectedGroup = null;
                  }
                });

                _loadSubjects();
              },
            ),

            const SizedBox(height: 16),

            if (EducationHelper.hasGroup(_selectedClass))
              AppSelector<String>(
                label: 'Group',
                icon: Icons.groups,
                value: _selectedGroup,
                items: EducationHelper.availableGroups(_selectedClass),
                itemLabel: (item) => item,
                onChanged: (value) {
                  setState(() {
                    _selectedGroup = value;
                  });

                  _loadSubjects();
                },
              ),

            SizedBox(height: EducationHelper.hasGroup(_selectedClass) ? 20 : 0),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _subjects.isEmpty
                  ? const Center(
                      child: Text(
                        'No Subject Found',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _subjects.length,
                      itemBuilder: (context, index) {
                        final subject = _subjects[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.menu_book),
                            ),
                            title: Text(
                              subject.subjectName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Full Marks: ${subject.fullMarks}   |   Pass Marks: ${subject.passMarks}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddSubjectScreen(
                                          className: subject.className,
                                          groupName: subject.groupName,
                                          subject: subject,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      await _loadSubjects();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteSubject(subject);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
