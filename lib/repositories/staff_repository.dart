import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/staff_model.dart';
import '../services/storage_service.dart';

class StaffRepository {
  static String get _baseUrl {
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty) {
        return 'http://$host:3000/api/v1/staff';
      }
    }
    return 'http://192.168.1.8:3000/api/v1/staff';
  }

  Future<List<Staff>> fetchStaff({String? role}) async {
    try {
      final token = await StorageService.read('accessToken');
      var uri = Uri.parse(_baseUrl);
      if (role != null && role != 'All') {
        uri = uri.replace(queryParameters: {'role': role});
      }

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List).map((e) => Staff.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching staff: $e');
      return [];
    }
  }

  Future<Staff?> fetchStaffDetail(String id) async {
    try {
      final token = await StorageService.read('accessToken');
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Staff.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching staff detail: $e');
      return null;
    }
  }

  Future<StaffSummary?> fetchStaffSummary(String id) async {
    try {
      final token = await StorageService.read('accessToken');
      final response = await http.get(
        Uri.parse('$_baseUrl/$id/summary'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StaffSummary.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching staff summary: $e');
      return null;
    }
  }

  Future<StaffTimetable?> fetchStaffTimetable(String id) async {
    try {
      final token = await StorageService.read('accessToken');
      final response = await http.get(
        Uri.parse('$_baseUrl/$id/timetable'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StaffTimetable.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print('Error fetching staff timetable: $e');
      return null;
    }
  }

  Future<bool> deleteStaff(String id) async {
    try {
      final token = await StorageService.read('accessToken');
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting staff: $e');
      return false;
    }
  }

  Future<bool> createStaff(Map<String, dynamic> data, {String? avatarPath, Uint8List? avatarBytes}) async {
    try {
      final token = await StorageService.read('accessToken');
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.headers['Authorization'] = 'Bearer $token';

      data.forEach((key, value) {
        if (value != null) request.fields[key] = value.toString();
      });

      if (avatarBytes != null) {
        request.files.add(http.MultipartFile.fromBytes('avatar', avatarBytes, filename: 'avatar.jpg'));
      } else if (avatarPath != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
      }

      final response = await http.Response.fromStream(await request.send());
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating staff: $e');
      return false;
    }
  }

  Future<bool> updateStaff(String id, Map<String, dynamic> data, {String? avatarPath, Uint8List? avatarBytes}) async {
    try {
      final token = await StorageService.read('accessToken');
      var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/$id'));
      request.headers['Authorization'] = 'Bearer $token';

      data.forEach((key, value) {
        if (value != null) request.fields[key] = value.toString();
      });

      if (avatarBytes != null) {
        request.files.add(http.MultipartFile.fromBytes('avatar', avatarBytes, filename: 'avatar.jpg'));
      } else if (avatarPath != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
      }

      final response = await http.Response.fromStream(await request.send());
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating staff: $e');
      return false;
    }
  }
}
