import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../data/repositories/imageRepo.dart';
import '../../logic/auth/auth_bloc.dart';
import '../widgets/ProfileImageWidget.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final success = await Imagerepo().uploadProfileImage(imageFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Profile image uploaded successfully'
              : 'Failed to upload profile image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: AuthBloc.getIdFromToken(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ProfileImageWidget(userId: snapshot.data!, borderColor: Colors.white);
                }
                return CircleAvatar(radius: 40.0, child: Icon(Icons.person));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickAndUploadImage(context),
              child: Text('Change Profile Image'),
            ),
          ],
        ),
      ),
    );
  }
}