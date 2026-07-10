import 'package:flutter/material.dart';
import '../../models/school_settings_model.dart';
import '../../services/school_settings_service.dart';
import 'dart:io';

import '../../services/image_picker_service.dart';

class SchoolSettingsScreen extends StatefulWidget {
  const SchoolSettingsScreen({super.key});

  @override
  State<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends State<SchoolSettingsScreen> {
  File? _logoFile;

  final _formKey = GlobalKey<FormState>();

  // Organization
  final _organizationController = TextEditingController();
  final _eiinController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  // Principal
  final _principalNameController = TextEditingController();
  final _principalDesignationController = TextEditingController();
  Future<void> _pickLogo() async {
    final file = await ImagePickerService.instance.pickImageFromGallery();

    if (file == null) return;

    setState(() {
      _logoFile = file;
    });
  }

  Future<void> _saveSettings() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final settings = SchoolSettingsModel(
        organizationName: _organizationController.text.trim(),
        eiin: _eiinController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
        principalName: _principalNameController.text.trim(),
        principalDesignation: _principalDesignationController.text.trim(),
        logoPath: _logoFile?.path,
        principalPhotoPath: null,
        principalSignaturePath: null,
      );

      await SchoolSettingsService.instance.saveSettings(settings);

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            title: const Text('Success', textAlign: TextAlign.center),
            content: const Text(
              'School Settings have been saved successfully.',
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {debugPrint(e.toString());}
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SchoolSettingsService.instance.getSettings();

    if (settings == null) return;

    if (settings.logoPath != null && settings.logoPath!.isNotEmpty) {
      _logoFile = File(settings.logoPath!);
    }

    _organizationController.text = settings.organizationName;
    _eiinController.text = settings.eiin;
    _addressController.text = settings.address;
    _phoneController.text = settings.phone;
    _emailController.text = settings.email;
    _websiteController.text = settings.website;
    _principalNameController.text = settings.principalName;
    _principalDesignationController.text = settings.principalDesignation;

    setState(() {});
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _eiinController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _principalNameController.dispose();
    _principalDesignationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('School Settings')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'School Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'These settings will be used in Home Screen, Marksheet, PDF, Print and Share.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'School Logo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _logoFile != null
                          ? FileImage(_logoFile!)
                          : null,
                      child: _logoFile == null
                          ? const Icon(Icons.school, size: 50)
                          : null,
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: _pickLogo,
                      icon: const Icon(Icons.photo),
                      label: const Text("Select Logo"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Organization Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _organizationController,
                decoration: const InputDecoration(
                  labelText: 'Organization Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Organization Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _eiinController,
                decoration: const InputDecoration(
                  labelText: 'EIIN (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _websiteController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Principal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _principalNameController,
                decoration: const InputDecoration(
                  labelText: 'Principal Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Principal Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _principalDesignationController,
                decoration: const InputDecoration(
                  labelText: 'Designation *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Designation is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _saveSettings,
                  child: const Text('SAVE SETTINGS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
