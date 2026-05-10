import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../services/storage_service.dart';
import '../models/dashboard_data.dart';

class DashboardRepository {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // Set to true to test the frontend UI with fake data from assets/json/dashboard_mock.json!
  static const bool useMockData = true;

  Future<DashboardData> fetchDashboardData({String period = 'week'}) async {
    if (useMockData) {
      // Simulate a small network delay for a realistic loading state
      await Future.delayed(const Duration(milliseconds: 800));
      return await getMockDashboardData(period);
    }

    try {
      final token = await StorageService.read('accessToken');

      if (token == null) {
        throw Exception('User is not authenticated. Token is missing.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/dashboard?period=$period'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return DashboardData.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['error'] ?? 'Failed to load dashboard data');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch dashboard: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<DashboardData> getMockDashboardData(String period) async {
    try {
      // Load and parse the dynamic JSON asset file
      final String jsonString = await rootBundle.loadString('assets/json/dashboard_mock.json');
      final Map<String, dynamic> responseData = jsonDecode(jsonString);
      final Map<String, dynamic> dataMap = responseData['data'];

      // 1. Get correct patient chart data key from the JSON dynamically based on selected period
      String chartKey = 'patient_chart_week';
      if (period == 'today') {
        chartKey = 'patient_chart_today';
      } else if (period == 'month') {
        chartKey = 'patient_chart_month';
      }

      final List<dynamic> chartListJson = dataMap[chartKey] ?? [];
      final List<PatientChartItem> dynamicChartData = chartListJson
          .map((item) => PatientChartItem.fromJson(item))
          .toList();

      // 2. Parse general data elements dynamically from the JSON
      final summary = DashboardSummary.fromJson(dataMap['summary'] ?? {});
      final upcoming = (dataMap['upcoming_appointments'] as List? ?? [])
          .map((item) => UpcomingAppointment.fromJson(item))
          .toList();
      final schedule = (dataMap['doctors_schedule'] as List? ?? [])
          .map((item) => DoctorScheduleItem.fromJson(item))
          .toList();
      final polyclinics = (dataMap['polyclinics'] as List? ?? [])
          .map((item) => PolyclinicItem.fromJson(item))
          .toList();
      final notifications = NotificationsSection.fromJson(dataMap['notifications'] ?? {});

      // 3. Construct and return the final DashboardData object fully dynamically!
      return DashboardData(
        summary: summary,
        patientChart: dynamicChartData,
        upcomingAppointments: upcoming,
        doctorsSchedule: schedule,
        polyclinics: polyclinics,
        notifications: notifications,
      );
    } catch (e) {
      print('Error loading mock asset dynamically: $e');
      throw Exception('Failed to load local mock data: $e');
    }
  }
}
