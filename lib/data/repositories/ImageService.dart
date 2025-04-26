import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pfa_flutter/logic/auth/auth_bloc.dart';

class Imagerepo {
  static final Imagerepo _instance = Imagerepo._internal();
  factory Imagerepo() => _instance;
  Imagerepo._internal();

  static const String _baseUrl = "http://192.168.1.25:8081";
  final Map<String, File> _imageCache = {};
  final _imageUpdateController = StreamController<String>.broadcast();

  Stream<String> get imageUpdateStream => _imageUpdateController.stream;

  Future<File?> getProfileImage(String userId) async {
    if (userId.isEmpty) {
      debugPrint("Error: Empty user ID provided for fetching profile image");
      return null;
    }

    // Always try to fetch from server first
    try {
      debugPrint("Fetching profile image from: $_baseUrl/api/users/$userId/profile-image");
      final response = await http.get(
        Uri.parse("$_baseUrl/api/users/$userId/profile-image"),
        headers: {'Authorization': 'Bearer ${await AuthBloc.getToken()}'},
      );

      if (response.statusCode == 200) {
        debugPrint("Profile image fetched successfully for userId: $userId");
        final file = await _saveFile(response.bodyBytes, userId);
        _imageCache[userId] = file; // Update cache with latest image
        return file;
      } else {
        debugPrint("Failed to fetch profile image: Status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching profile image for userId: $userId: $e");
    }

    // Fallback to cache if server fetch fails
    if (_imageCache.containsKey(userId)) {
      debugPrint("Returning cached profile image for userId: $userId");
      return _imageCache[userId];
    }

    // Fallback to local storage if cache is empty
    final localFile = await _getLocalFile(userId);
    if (localFile != null && await localFile.exists()) {
      debugPrint("Returning local profile image for userId: $userId");
      _imageCache[userId] = localFile;
      return localFile;
    }

    debugPrint("No profile image available for userId: $userId");
    return null;
  }

  Future<bool> uploadProfileImage(File imageFile) async {
    final userId = await AuthBloc.getIdFromToken();
    if (userId == null) {
      debugPrint("Error: No user ID available for upload");
      return false;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$_baseUrl/api/users/$userId/upload-profile-image"),
      );
      request.headers['Authorization'] = 'Bearer ${await AuthBloc.getToken()}';
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      debugPrint("Sending upload request to: $_baseUrl/api/users/$userId/upload-profile-image");
      final response = await request.send();

      if (response.statusCode == 200) {
        debugPrint("Profile image uploaded successfully");
        // Clear cache and local storage to force server fetch
        await clearProfileImageCache(userId);
        // Fetch the new image from the server
        final newImage = await getProfileImage(userId);
        if (newImage != null) {
          _imageCache[userId] = newImage; // Update cache
        }
        _imageUpdateController.add(userId); // Notify listeners
        return true;
      } else {
        debugPrint("Upload failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      return false;
    }
  }

  Future<void> clearProfileImageCache(String userId) async {
    _imageCache.remove(userId);
    final localFile = await _getLocalFile(userId);
    if (localFile != null && await localFile.exists()) {
      await localFile.delete();
      debugPrint("Cleared local profile image for userId: $userId");
    }
    debugPrint("Cleared profile image cache for userId: $userId");
  }

  Future<File?> _getLocalFile(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_$userId.jpg');
    return await file.exists() ? file : null;
  }

  Future<File> _saveFile(List<int> bytes, String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_$userId.jpg');
    await file.writeAsBytes(bytes);
    return file;
  }

  void dispose() {
    _imageUpdateController.close();
  }
}