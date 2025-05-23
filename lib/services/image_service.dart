import 'dart:io';
import 'package:flutter/material.dart';

class ImageService {
  static const List<String> _sampleImageUrls = [
    'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300',
    'https://images.unsplash.com/photo-1518843875459-f738682238a6?w=300',
    'https://images.unsplash.com/photo-1566385101042-1a0aa0c1268c?w=300',
    'https://images.unsplash.com/photo-1574316071802-0d684e3b543e?w=300',
    'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=300',
    'https://images.unsplash.com/photo-1607472586736-7b807d5f93dc?w=300',
    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=300',
    'https://images.unsplash.com/photo-1561758033-48d52648ae8b?w=300',
  ];

  // Simulate image picking from camera
  static Future<List<String>> pickImageFromCamera() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing time

    // Return a random sample image URL
    final randomIndex = DateTime.now().millisecond % _sampleImageUrls.length;
    return [_sampleImageUrls[randomIndex]];
  }

  // Simulate image picking from gallery
  static Future<List<String>> pickImageFromGallery({bool multiple = false}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing time

    if (multiple) {
      // Return 2-3 random images for multiple selection
      final count = 2 + (DateTime.now().millisecond % 2);
      return _sampleImageUrls.take(count).toList();
    } else {
      // Return a single random image
      final randomIndex = DateTime.now().millisecond % _sampleImageUrls.length;
      return [_sampleImageUrls[randomIndex]];
    }
  }

  // Simulate image upload to Firebase Storage
  static Future<String> uploadImage(File imageFile, String productId) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate upload time

    // Return a sample image URL
    final randomIndex = DateTime.now().millisecond % _sampleImageUrls.length;
    return _sampleImageUrls[randomIndex];
  }

  // Simulate multiple image upload
  static Future<List<String>> uploadMultipleImages(
      List<File> imageFiles,
      String productId
      ) async {
    List<String> uploadedUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      final randomIndex = (DateTime.now().millisecond + i) % _sampleImageUrls.length;
      uploadedUrls.add(_sampleImageUrls[randomIndex]);
    }

    return uploadedUrls;
  }

  // Simulate image deletion from Firebase Storage
  static Future<bool> deleteImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Simulate successful deletion
  }

  // Show image picker options dialog
  static Future<List<String>?> showImagePickerOptions(
      BuildContext context, {
        bool allowMultiple = false,
      }) async {
    return showModalBottomSheet<List<String>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await pickImageFromCamera();
                    Navigator.pop(context, images);
                  },
                ),
                _buildImageSourceOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () async {
                    Navigator.pop(context);
                    final images = await pickImageFromGallery(multiple: allowMultiple);
                    Navigator.pop(context, images);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo Mode: Sample images will be used for demonstration',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compress image (placeholder)
  static Future<File> compressImage(File imageFile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return imageFile; // Return original file in demo
  }

  // Validate image (placeholder)
  static bool validateImage(File imageFile) {
    // Add validation logic here (file size, format, etc.)
    return true;
  }

  // Get image file size
  static Future<int> getImageSize(File imageFile) async {
    return await imageFile.length();
  }

  // Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = (bytes.bitLength - 1) ~/ 10;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

// TODO: Implement actual image picker functionality
// Add these dependencies to pubspec.yaml:
// image_picker: ^1.0.4
// firebase_storage: ^11.5.6
// image: ^4.1.3  (for image compression)

/*
Future implementation with actual image picker:

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<List<String>> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      return [image.path];
    }
    return [];
  }

  static Future<List<String>> pickImageFromGallery({bool multiple = false}) async {
    if (multiple) {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return images.map((e) => e.path).toList();
    } else {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return [image.path];
      }
      return [];
    }
  }

  static Future<String> uploadImage(File imageFile, String productId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('products/$productId/$fileName');

    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
*/