import 'add_student_screen.dart';
import 'package:flutter/material.dart';
import 'student_list_screen.dart';
import '../subject/subject_management_screen.dart';
import '../result/result_entry_screen.dart';
import 'import_export/import_export_screen.dart';
import '../result/student_marksheet_screen.dart';
import '../settings/school_settings_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              icon: Icons.person_add,
              title: "Add Student",
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStudentScreen()),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.people,
              title: "Student List",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentListScreen()),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.menu_book,
              title: "Subject Management",
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubjectManagementScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.assignment,
              title: "Result Entry",
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResultEntryScreen()),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.import_export,
              title: "Import & Export",
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImportExportScreen()),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.description,
              title: "Student Marksheet",
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentMarksheetScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.school,
              title: "School Settings",
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SchoolSettingsScreen(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              icon: Icons.info,
              title: "About",
              color: Colors.grey,
              onTap: () {
                // পরে করব
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
