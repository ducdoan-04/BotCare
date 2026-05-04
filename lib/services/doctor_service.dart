import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DoctorService {
  static const String baseUrl = 'http://localhost:3000/api/doctors';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));

  Future<List<dynamic>> getAllDoctors() async {
    try {
      final res = await _dio.get('/');
      if (res.statusCode == 200 && res.data['success'] == true) {
        return res.data['data'] ?? [];
      }
      debugPrint('getAllDoctors: ${res.data}');
    } on DioException catch (e) {
      debugPrint('getAllDoctors error: ${e.message} | ${e.response?.data}');
    }
    return [];
  }

  Future<Map<String, dynamic>?> getDoctorById(String id) async {
    try {
      final res = await _dio.get('/$id');
      if (res.statusCode == 200 && res.data['success'] == true) {
        return Map<String, dynamic>.from(res.data['data']);
      }
    } on DioException catch (e) {
      debugPrint('getDoctorById error: ${e.message}');
    }
    return null;
  }

  Future<bool> createDoctor(Map<String, dynamic> data) async {
    try {
      debugPrint('createDoctor → ${data['name']} | ${data['specialty']}');
      final res = await _dio.post('/', data: data);
      debugPrint('createDoctor ← ${res.statusCode}: ${res.data}');
      return res.statusCode == 201 && res.data['success'] == true;
    } on DioException catch (e) {
      debugPrint('createDoctor error: ${e.message} | ${e.response?.data}');
    }
    return false;
  }

  Future<bool> updateDoctor(String id, Map<String, dynamic> data) async {
    try {
      final res = await _dio.put('/$id', data: data);
      debugPrint('updateDoctor ← ${res.statusCode}: ${res.data}');
      return res.statusCode == 200 && res.data['success'] == true;
    } on DioException catch (e) {
      debugPrint('updateDoctor error: ${e.message} | ${e.response?.data}');
    }
    return false;
  }

  Future<bool> deleteDoctor(String id) async {
    try {
      final res = await _dio.delete('/$id');
      return res.statusCode == 200 && res.data['success'] == true;
    } on DioException catch (e) {
      debugPrint('deleteDoctor error: ${e.message}');
    }
    return false;
  }
}
