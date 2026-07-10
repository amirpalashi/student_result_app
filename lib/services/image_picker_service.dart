import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._();

  static final ImagePickerService instance = ImagePickerService._();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }
}