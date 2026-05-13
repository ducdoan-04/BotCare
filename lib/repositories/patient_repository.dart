import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../services/storage_service.dart';

class PatientRepository {
  static String get baseUrl {
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty && host != 'localhost') {
        return 'http://$host:3000/api/v1/patients';
      }
    }
    return 'http://192.168.1.8:3000/api/v1/patients';
  }

  // GET /api/v1/patients
  Future<Map<String, dynamic>> fetchPatients({String? search, String? date}) async {
    try {
      final token = await StorageService.read('accessToken');
      final Map<String, String> queryParams = {};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (date != null && date.isNotEmpty) queryParams['date'] = date;

      final queryString = Uri(queryParameters: queryParams).query;
      final uri = Uri.parse(queryString.isEmpty ? baseUrl : '$baseUrl?$queryString');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          final data = resData['data'] ?? {};
          final List list = data['patients'] ?? [];
          final patients = list.map((item) => Patient.fromJson(item)).toList();
          return {
            'patients': patients,
            'stats': data['stats'] ?? {},
          };
        } else {
          throw Exception(resData['error'] ?? 'Failed to fetch patients');
        }
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patients: $e');
      rethrow;
    }
  }

  // POST /api/v1/patients (Multipart)
  Future<Patient> createPatient(
    Patient patient,
    String? avatarPath,
    Uint8List? avatarBytes,
  ) async {
    try {
      final token = await StorageService.read('accessToken');
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      
      request.headers['Authorization'] = 'Bearer $token';

      // Basic fields
      request.fields['full_name'] = patient.fullName;
      request.fields['email'] = patient.email ?? '';
      request.fields['phone'] = patient.phone ?? '';
      request.fields['address'] = patient.address ?? '';
      request.fields['country'] = patient.country ?? '';
      request.fields['state'] = patient.state ?? '';
      request.fields['city'] = patient.city ?? '';
      
      // Medical fields
      request.fields['blood_type'] = patient.bloodType ?? '';
      request.fields['allergies'] = patient.allergies ?? '';
      request.fields['status'] = patient.status;
      request.fields['specialist_department'] = patient.specialistDepartment ?? '';
      if (patient.assignedDoctorId != null) {
        request.fields['assigned_doctor_id'] = patient.assignedDoctorId!;
      }

      // Avatar
      if (kIsWeb && avatarBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          avatarBytes,
          filename: 'avatar.jpg',
        ));
      } else if (avatarPath != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', avatarPath));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          return Patient.fromJson(resData['data']);
        } else {
          throw Exception(resData['error'] ?? 'Failed to create patient');
        }
      } else {
        final resData = jsonDecode(response.body);
        throw Exception(resData['error'] ?? 'Server error ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating patient: $e');
      rethrow;
    }
  }

  Future<bool> updatePatient(String id, Map<String, dynamic> data, {Uint8List? avatarBytes}) async {
    try {
      final token = await StorageService.read('accessToken');
      var request = http.MultipartRequest('PUT', Uri.parse('http://192.168.1.8:3000/api/v1/patients/$id'));
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add fields
      data.forEach((key, value) {
        if (value != null) {
          if (value is DateTime) {
            request.fields[key] = value.toIso8601String();
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Add file if present
      if (avatarBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'avatar',
          avatarBytes,
          filename: 'update_avatar.jpg',
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        final resData = jsonDecode(response.body);
        throw Exception(resData['error'] ?? 'Update patient failed');
      }
    } catch (e) {
      print('Error updating patient: $e');
      rethrow;
    }
  }
}
