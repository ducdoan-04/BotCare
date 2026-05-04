import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // Use your local IP or appropriate base URL
  static const String baseUrl = 'http://localhost:3000/api/auth';
  
  // 1. Email Login
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    return _postRequest('$baseUrl/login', {
      'email': email,
      'password': password,
    });
  }

  // 2. Email Register
  Future<Map<String, dynamic>> registerWithEmail(String name, String email, String password) async {
    return _postRequest('$baseUrl/register', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // 3. Google Login
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    return _postRequest('$baseUrl/google-login', {
      'idToken': idToken,
    });
  }

  // 4. Apple Login
  Future<Map<String, dynamic>> loginWithApple(String appleId, String? email, String? name) async {
    return _postRequest('$baseUrl/apple-login', {
      'appleId': appleId,
      'email': email,
      'name': name,
    });
  }

  // Helper method
  Future<Map<String, dynamic>> _postRequest(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Request failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
