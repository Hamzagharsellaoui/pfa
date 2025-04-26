// lib/services/image_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../logic/auth/auth_bloc.dart';


class Imagerepo {
  static final Imagerepo _instance = Imagerepo._internal();
  factory Imagerepo() => _instance;
  Imagerepo._internal();

  static const String _baseUrl = "http://192.168.0.119:8081";
  final Map<String, File> _imageCache = {};

  Future<File?> getProfileImage() async {
    final userId = await AuthBloc.getIdFromToken();
    if (userId == null) return null;

    // Check cache first
    if (_imageCache.containsKey(userId)) {
      return _imageCache[userId];
    }

    // Check local storage
    final localFile = await _getLocalFile(userId);
    if (localFile != null && await localFile.exists()) {
      _imageCache[userId] = localFile;
      return localFile;
    }

    // Fetch from server
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/api/users/$userId/profile-image"),
        headers: {'Authorization': 'Bearer ${await AuthBloc.getToken()}'},
      );

      if (response.statusCode == 200) {
        final file = await _saveFile(response.bodyBytes, userId);
        _imageCache[userId] = file;
        return file;
      }
    } catch (e) {
      debugPrint("Error fetching profile image: $e");
    }
    return null;
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
}