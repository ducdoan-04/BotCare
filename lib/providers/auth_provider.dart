import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../models/login_response.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider with ChangeNotifier {
  AuthState _state = AuthState.initial;
  String? _errorMessage;
  User? _user;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  AuthProvider() {
    // Automatically restore session when provider is initialized (helps F5/reload)
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await StorageService.read('accessToken');
      final userJson = await StorageService.read('user_profile');

      if (token != null && userJson != null) {
        _user = User.fromJson(jsonDecode(userJson));
        _state = AuthState.success;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error restoring auth session: $e');
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email, password);
      
      _user = response.user;
      _state = AuthState.success;

      // Save credentials/tokens to Safe Storage
      await StorageService.write('accessToken', response.accessToken);
      await StorageService.write('refreshToken', response.refreshToken);
      await StorageService.write('user_profile', jsonEncode(response.user.toJson()));
      
      // Save Remember Me states
      if (rememberMe) {
        await StorageService.write('remember_me', 'true');
        await StorageService.write('saved_email', email);
      } else {
        await StorageService.write('remember_me', 'false');
        await StorageService.delete('saved_email');
      }
      
      notifyListeners();
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _state = AuthState.initial;
    _user = null;
    
    // Clear tokens and profile, but preserve the saved_email if they checked remember_me
    final rememberMeStr = await StorageService.read('remember_me');
    final savedEmail = await StorageService.read('saved_email');
    
    await StorageService.clear();
    
    if (rememberMeStr == 'true' && savedEmail != null) {
      await StorageService.write('remember_me', 'true');
      await StorageService.write('saved_email', savedEmail);
    }
    
    notifyListeners();
  }

  void resetState() {
    _state = AuthState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
