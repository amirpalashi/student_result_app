import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  Future<void> _openWebsite() async {
    final uri = Uri.parse('https://islamidesign.com');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'info@islamidesign.com');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                const Icon(Icons.school, size: 80, color: Colors.indigo),

                const SizedBox(height: 16),

                const Text(
                  "Student Result Management",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Version 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                _buildSectionCard(
                  icon: Icons.info_outline_rounded,
                  title: "About",
                  child: const Text(
                    "Student Result Management is a modern, secure, and user-friendly application designed to simplify academic result management for schools, colleges, and educational institutions.\n\n"
                    "The application enables institutions to efficiently manage student information, academic sessions, subjects, examinations, result processing, GPA calculation, and professional marksheet generation with accuracy and ease.\n\n"
                    "Built with Flutter and Material Design 3, the app provides a fast, responsive, and reliable experience for educational organizations.",
                    style: TextStyle(height: 1.6, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.star_outline_rounded,
                  title: "Key Features",
                  child: const Column(
                    children: [
                      FeatureTile(
                        icon: Icons.person_outline,
                        title: "Student Management",
                      ),
                      FeatureTile(
                        icon: Icons.menu_book_outlined,
                        title: "Subject Management",
                      ),
                      FeatureTile(
                        icon: Icons.edit_document,
                        title: "Result Entry",
                      ),
                      FeatureTile(
                        icon: Icons.calculate_outlined,
                        title: "Automatic GPA & Grade Calculation",
                      ),
                      FeatureTile(
                        icon: Icons.description_outlined,
                        title: "Professional Digital Marksheet",
                      ),
                      FeatureTile(
                        icon: Icons.picture_as_pdf_outlined,
                        title: "PDF Export",
                      ),
                      FeatureTile(
                        icon: Icons.print_outlined,
                        title: "Print Support",
                      ),
                      FeatureTile(
                        icon: Icons.share_outlined,
                        title: "Share Marksheet",
                      ),
                      FeatureTile(
                        icon: Icons.apartment_outlined,
                        title: "School Information Management",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.design_services_outlined,
                  title: "Our Services",
                  child: const Column(
                    children: [
                      FeatureTile(
                        icon: Icons.android,
                        title: "Android App Development",
                      ),
                      FeatureTile(
                        icon: Icons.language,
                        title: "Website Development",
                      ),
                      FeatureTile(
                        icon: Icons.school_outlined,
                        title: "School & College ERP Solutions",
                      ),
                      FeatureTile(
                        icon: Icons.business_center_outlined,
                        title: "Business Management Software",
                      ),
                      FeatureTile(
                        icon: Icons.palette_outlined,
                        title: "Graphic Design & Branding",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _buildSectionCard(
                  icon: Icons.business_center_outlined,
                  title: "Developed By",
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Islami Design",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Professional Software Solutions",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.person_outline_rounded,
                  title: "Lead Developer",
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amirul Islam",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.contact_mail_outlined,
                  title: "Contact",
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.language,
                          color: Colors.indigo,
                        ),
                        title: const Text("Website"),
                        subtitle: const Text("https://islamidesign.com"),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: _openWebsite,
                      ),

                      const Divider(),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.email_outlined,
                          color: Colors.indigo,
                        ),
                        title: const Text("Email"),
                        subtitle: const Text("info@islamidesign.com"),
                        trailing: const Icon(Icons.send),
                        onTap: _sendEmail,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _buildSectionCard(
                  icon: Icons.favorite_outline_rounded,
                  title: "Thank You",
                  child: const Text(
                    "Thank you for choosing Student Result Management.\n\n"
                    "We sincerely appreciate your trust and support.\n\n"
                    "Our mission is to build reliable, user-friendly, and professional software solutions for educational institutions.\n\n"
                    "Your valuable feedback inspires us to continuously improve our applications.",
                    style: TextStyle(height: 1.6, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 24),

                const Divider(),

                const SizedBox(height: 16),

                const Text(
                  "Version 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text("© 2026 Islami Design", textAlign: TextAlign.center),

                const SizedBox(height: 4),

                const Text(
                  "Lead Developer: Amirul Islam",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                const Text(
                  "All Rights Reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
