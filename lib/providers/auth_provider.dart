import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../models/login_response.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  AuthState _state = AuthState.initial;
  String? _errorMessage;
  User? _user;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String email, String password, bool rememberMe) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email, password);
      
      _user = response.user;
      _state = AuthState.success;

      // Save token if remember me is checked
      if (rememberMe) {
        await _storage.write(key: 'accessToken', value: response.accessToken);
        await _storage.write(key: 'refreshToken', value: response.refreshToken);
      }
      
      notifyListeners();
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void resetState() {
    _state = AuthState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
