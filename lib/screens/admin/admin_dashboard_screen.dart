import 'package:flutter/material.dart';
import 'add_student_screen.dart';

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
                // Step 13.2
              },
            ),
            _buildCard(
              context,
              icon: Icons.menu_book,
              title: "Subject Marks",
              color: Colors.orange,
              onTap: () {
                // Step 13.5
              },
            ),
            _buildCard(
              context,
              icon: Icons.analytics,
              title: "Reports",
              color: Colors.purple,
              onTap: () {},
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
