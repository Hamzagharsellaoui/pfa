import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();
  static const _profileImageKey = 'profile_image_url';

  static Future<String?> getProfileImageUrl() async {
    return await _storage.read(key: _profileImageKey);
  }

  static Future<void> setProfileImageUrl(String url) async {
    await _storage.write(key: _profileImageKey, value: url);
  }

  static Future<void> deleteProfileImageUrl() async {
    await _storage.delete(key: _profileImageKey);
  }

  static Future<bool> hasProfileImage() async {
    return await _storage.containsKey(key: _profileImageKey);
  }
}