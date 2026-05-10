import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> write(String key, String value) async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString(key, value);
      return;
    }

    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      debugPrint('Secure Storage write failed, falling back to SharedPreferences: $e');
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString(key, value);
    }
  }

  static Future<String?> read(String key) async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs!.getString(key);
    }

    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      debugPrint('Secure Storage read failed, falling back to SharedPreferences: $e');
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs!.getString(key);
    }
  }

  static Future<void> delete(String key) async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.remove(key);
      return;
    }

    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      debugPrint('Secure Storage delete failed, falling back to SharedPreferences: $e');
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.remove(key);
    }
  }

  static Future<void> clear() async {
    if (kIsWeb) {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.clear();
      return;
    }

    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Secure Storage clear failed, falling back to SharedPreferences: $e');
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.clear();
    }
  }
}
