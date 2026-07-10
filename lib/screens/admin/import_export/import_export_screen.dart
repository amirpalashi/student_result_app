import 'package:flutter/material.dart';

import 'widgets/action_card.dart';

import 'student/student_import_screen.dart';
import 'student/student_export_screen.dart';

import 'subject/subject_import_screen.dart';
import 'subject/subject_export_screen.dart';

import 'result/result_import_screen.dart';
import 'result/result_export_screen.dart';

import 'template/template_download_screen.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Import & Export"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ActionCard(
            icon: Icons.person_add_alt_1,
            title: "Import Students",
            subtitle: "Import students from Excel",
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentImportScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          ActionCard(
            icon: Icons.menu_book,
            title: "Import Subjects",
            subtitle: "Import subjects from Excel",
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectImportScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          ActionCard(
            icon: Icons.assignment,
            title: "Import Results",
            subtitle: "Import marks from Excel",
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResultImportScreen()),
              );
            },
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 20),

          ActionCard(
            icon: Icons.download,
            title: "Export Students",
            subtitle: "Export student list",
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentExportScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          ActionCard(
            icon: Icons.download,
            title: "Export Subjects",
            subtitle: "Export subject list",
            color: Colors.deepOrange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectExportScreen()),
              );
            },
          ),

          const SizedBox(height: 12),

          ActionCard(
            icon: Icons.download,
            title: "Export Results",
            subtitle: "Export result sheet",
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResultExportScreen()),
              );
            },
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 20),

          ActionCard(
            icon: Icons.description,
            title: "Download Templates",
            subtitle: "Excel templates for import",
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TemplateDownloadScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
