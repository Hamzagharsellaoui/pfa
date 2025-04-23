import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pfa_flutter/logic/auth/auth_bloc.dart'; // For MediaType

class ProfileImageUploader extends StatefulWidget {
  final String userId;
  const ProfileImageUploader({super.key, required this.userId});

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  File? _image;
  final picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Reduce image quality if needed
      );

      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
        await _uploadImage(_image!);
      }
    } catch (e) {
      _showError("Image selection failed: ${e.toString()}");
      debugPrint("Image picker error: $e");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUploading = true);

    try {
      // 1. Get and verify token
      final token = await AuthBloc.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No authentication token found");
      }

      // 2. Create request
      final uri = Uri.parse("http://192.168.0.153:8081/api/users/${widget.userId}/upload-profile-image");
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('===== RESPONSE =====');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: $responseBody');

      if (response.statusCode == 201) {
        _showSuccess("Profile image updated successfully!");
      } else {
        throw Exception("Server returned ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      _showError("Upload failed: ${e.toString()}");
      debugPrint('Error details: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isUploading ? null : _pickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            backgroundColor: Colors.grey[300],
            child: _isUploading
                ? const CircularProgressIndicator(color: Colors.white)
                : _image == null
                ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        if (_isUploading)
          const Text(
            "Uploading...",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}