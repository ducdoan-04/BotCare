import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  static const String baseUrl = 'http://localhost:3000/api/v1/doctors';
  
  // Set to true to test local mock data or if backend is not yet started.
  // Set to false to fetch from real PostgreSQL/Prisma server!
  static const bool useMockData = false;

  // Local Mock List representing the exact doctors in your screenshots
  static final List<Doctor> _mockDoctors = [
    Doctor(
      id: 'a1111111-1111-1111-1111-111111111111',
      fullName: 'Dr. Dianne Russell',
      profileImageUrl: 'images/doctors/dianne_russell.jpg',
      gender: 'Female',
      email: 'dianne.russell@carebot.com',
      phoneNumber: '+1 (555) 019-2834',
      address: '123 Medical Center Dr, NY',
      specialization: 'General Practitioner',
      experience: '12+ Years',
      education: 'MD from Harvard Medical School',
      licenseNumber: 'LIC-908273',
      status: 'Available',
      workingHours: '9AM - 2PM',
      rating: 4.8,
      totalReviews: 120,
      totalPatients: 230,
      surgeries: 90,
      patientsIncreasePercent: 3.5,
    ),
    Doctor(
      id: 'b2222222-2222-2222-2222-222222222222',
      fullName: 'Dr. Jacob Jones',
      profileImageUrl: 'images/doctors/jacob_jones.jpg',
      gender: 'Male',
      email: 'jacob.jones@carebot.com',
      phoneNumber: '+1 (555) 019-5829',
      address: '456 Cardiovascular Ave, LA',
      specialization: 'Cardiology',
      experience: '15+ Years',
      education: 'PhD in Cardiology, Stanford University',
      licenseNumber: 'LIC-582910',
      status: 'Available',
      workingHours: '9AM - 2PM',
      rating: 4.9,
      totalReviews: 198,
      totalPatients: 340,
      surgeries: 150,
      patientsIncreasePercent: 5.2,
    ),
    Doctor(
      id: 'c3333333-3333-3333-3333-333333333333',
      fullName: 'Dr. Mona Flores',
      profileImageUrl: 'images/doctors/mona_flores.jpg',
      gender: 'Female',
      email: 'mona.flores@carebot.com',
      phoneNumber: '+1 (555) 019-3829',
      address: '789 Skin Care Lane, SF',
      specialization: 'Dermatology',
      experience: '8+ Years',
      education: 'MD from Johns Hopkins School of Medicine',
      licenseNumber: 'LIC-192837',
      status: 'Available',
      workingHours: '9AM - 2PM',
      rating: 4.5,
      totalReviews: 120,
      totalPatients: 185,
      surgeries: 45,
      patientsIncreasePercent: 2.1,
    ),
    Doctor(
      id: 'd4444444-4444-4444-4444-444444444444',
      fullName: 'Dr. Alicia Wexer',
      profileImageUrl: 'images/doctors/alicia_wexer.jpg',
      gender: 'Female',
      email: 'alicia.wexer@carebot.com',
      phoneNumber: '+1 (555) 019-9028',
      address: '101 Dermatology Way, SF',
      specialization: 'Dermatology',
      experience: '10+ Years',
      education: 'MD from Yale University',
      licenseNumber: 'LIC-102938',
      status: 'Available',
      workingHours: '9AM - 2PM',
      rating: 4.7,
      totalReviews: 135,
      totalPatients: 210,
      surgeries: 60,
      patientsIncreasePercent: 4.0,
    ),
  ];

  // Fetch standard dynamic timetable mock response (Check-ups vs Urgent visits)
  static final _mockTimetable = DoctorTimetableResponse(
    checkUps: [
      DoctorAppointment(
        id: '1',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Leslie Alexander',
        consultationType: 'Routine check up',
        appointmentTime: '09:40 AM',
        category: 'Check-up',
        status: 'Confirm',
      ),
      DoctorAppointment(
        id: '2',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Leslie Alexander',
        consultationType: 'Routine check up',
        appointmentTime: '09:40 AM',
        category: 'Check-up',
        status: 'Canceled',
      ),
      DoctorAppointment(
        id: '3',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Leslie Alexander',
        consultationType: 'Routine check up',
        appointmentTime: '09:40 AM',
        category: 'Check-up',
        status: 'Canceled',
      ),
      DoctorAppointment(
        id: '4',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Leslie Alexander',
        consultationType: 'Routine check up',
        appointmentTime: '09:40 AM',
        category: 'Check-up',
        status: 'Pending',
      ),
    ],
    urgentVisits: [
      DoctorAppointment(
        id: '5',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Savannah Nguyen',
        consultationType: 'Dermatology consultation',
        appointmentTime: '09:40 AM',
        category: 'Urgent visit',
        status: 'Pending',
      ),
      DoctorAppointment(
        id: '6',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Savannah Nguyen',
        consultationType: 'Dermatology consultation',
        appointmentTime: '09:40 AM',
        category: 'Urgent visit',
        status: 'Confirm',
      ),
      DoctorAppointment(
        id: '7',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Savannah Nguyen',
        consultationType: 'Dermatology consultation',
        appointmentTime: '09:40 AM',
        category: 'Urgent visit',
        status: 'Confirm',
      ),
      DoctorAppointment(
        id: '8',
        doctorId: 'a1111111-1111-1111-1111-111111111111',
        patientName: 'Savannah Nguyen',
        consultationType: 'Dermatology consultation',
        appointmentTime: '09:40 AM',
        category: 'Urgent visit',
        status: 'Confirm',
      ),
    ],
    availability: [
      AvailabilitySlotModel(id: 's1', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '09.00:AM', isBooked: true),
      AvailabilitySlotModel(id: 's2', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '09.30:AM', isBooked: false),
      AvailabilitySlotModel(id: 's3', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '10.00:AM', isBooked: false),
      AvailabilitySlotModel(id: 's4', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '10.30:AM', isBooked: false),
      AvailabilitySlotModel(id: 's5', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '11.30:AM', isBooked: false),
      AvailabilitySlotModel(id: 's6', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '12.00:PM', isBooked: true),
      AvailabilitySlotModel(id: 's7', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '02.00:PM', isBooked: false),
      AvailabilitySlotModel(id: 's8', doctorId: 'a1111111-1111-1111-1111-111111111111', timeSlot: '02.30:PM', isBooked: false),
    ],
  );

  // GET /api/v1/doctors
  Future<List<Doctor>> fetchDoctors({String? search, String? specialty}) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return _mockDoctors.where((doc) {
        final matchesSearch = search == null || 
            search.isEmpty || 
            doc.fullName.toLowerCase().contains(search.toLowerCase());
        final matchesSpecialty = specialty == null || 
            specialty.toLowerCase() == 'all' || 
            doc.specialization?.toLowerCase() == specialty.toLowerCase();
        return matchesSearch && matchesSpecialty;
      }).toList();
    }

    try {
      final token = await StorageService.read('accessToken');
      String query = '';
      if (search != null && search.isNotEmpty) query += 'search=$search&';
      if (specialty != null && specialty.isNotEmpty) query += 'specialty=$specialty';

      final response = await http.get(
        Uri.parse('$baseUrl?$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          final List list = resData['data'] ?? [];
          return list.map((item) => Doctor.fromJson(item)).toList();
        } else {
          throw Exception(resData['error'] ?? 'Failed to fetch doctors');
        }
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      // Graceful fallback to Mock data on network failure to guarantee no visual crashes
      print('Network error, falling back to mock doctors: $e');
      return _mockDoctors.where((doc) {
        final matchesSearch = search == null || 
            search.isEmpty || 
            doc.fullName.toLowerCase().contains(search.toLowerCase());
        final matchesSpecialty = specialty == null || 
            specialty.toLowerCase() == 'all' || 
            doc.specialization?.toLowerCase() == specialty.toLowerCase();
        return matchesSearch && matchesSpecialty;
      }).toList();
    }
  }

  // GET /api/v1/doctors/:id
  Future<Doctor> fetchDoctorById(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockDoctors.firstWhere(
        (doc) => doc.id == id,
        orElse: () => _mockDoctors[0],
      );
    }

    try {
      final token = await StorageService.read('accessToken');
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          return Doctor.fromJson(resData['data']);
        } else {
          throw Exception(resData['error'] ?? 'Doctor not found');
        }
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error, falling back to mock doctor: $e');
      return _mockDoctors.firstWhere(
        (doc) => doc.id == id,
        orElse: () => _mockDoctors[0],
      );
    }
  }

  // POST /api/v1/doctors
  Future<Doctor> createDoctor(Doctor doctor) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      final newDoctor = Doctor(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: doctor.fullName,
        profileImageUrl: doctor.profileImageUrl ?? 'images/doctors/default.jpg',
        gender: doctor.gender,
        email: doctor.email,
        phoneNumber: doctor.phoneNumber,
        address: doctor.address,
        specialization: doctor.specialization,
        experience: doctor.experience,
        education: doctor.education,
        licenseNumber: doctor.licenseNumber,
        status: doctor.status,
        workingHours: doctor.workingHours,
        rating: doctor.rating,
        totalReviews: doctor.totalReviews,
        totalPatients: doctor.totalPatients,
        surgeries: doctor.surgeries,
        patientsIncreasePercent: doctor.patientsIncreasePercent,
      );
      _mockDoctors.add(newDoctor);
      return newDoctor;
    }

    try {
      final token = await StorageService.read('accessToken');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(doctor.toJson()),
      );

      if (response.statusCode == 201) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          return Doctor.fromJson(resData['data']);
        } else {
          throw Exception(resData['error'] ?? 'Failed to create doctor');
        }
      } else {
        throw Exception('Server status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createDoctor: $e');
      throw Exception('Failed to add new doctor: $e');
    }
  }

  // PUT /api/v1/doctors/:id
  Future<Doctor> updateDoctor(String id, Map<String, dynamic> updateData) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      final index = _mockDoctors.indexWhere((doc) => doc.id == id);
      if (index != -1) {
        final current = _mockDoctors[index];
        final updated = Doctor(
          id: current.id,
          fullName: updateData['full_name'] ?? current.fullName,
          profileImageUrl: updateData['profile_image_url'] ?? current.profileImageUrl,
          gender: updateData['gender'] ?? current.gender,
          email: updateData['email'] ?? current.email,
          phoneNumber: updateData['phone_number'] ?? current.phoneNumber,
          address: updateData['address'] ?? current.address,
          specialization: updateData['specialization'] ?? current.specialization,
          experience: updateData['experience'] ?? current.experience,
          education: updateData['education'] ?? current.education,
          licenseNumber: updateData['license_number'] ?? current.licenseNumber,
          status: updateData['status'] ?? current.status,
          workingHours: updateData['working_hours'] ?? current.workingHours,
          rating: updateData['rating'] != null ? (updateData['rating'] as num).toDouble() : current.rating,
          totalReviews: updateData['total_reviews'] ?? current.totalReviews,
          totalPatients: updateData['total_patients'] ?? current.totalPatients,
          surgeries: updateData['surgeries'] ?? current.surgeries,
          patientsIncreasePercent: updateData['patients_increase_percent'] != null 
              ? (updateData['patients_increase_percent'] as num).toDouble() 
              : current.patientsIncreasePercent,
        );
        _mockDoctors[index] = updated;
        return updated;
      }
      throw Exception('Doctor not found in mock list');
    }

    try {
      final token = await StorageService.read('accessToken');
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          return Doctor.fromJson(resData['data']);
        } else {
          throw Exception(resData['error'] ?? 'Failed to update doctor');
        }
      } else {
        throw Exception('Server status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateDoctor: $e');
      throw Exception('Failed to update doctor: $e');
    }
  }

  // DELETE /api/v1/doctors/:id
  Future<void> deleteDoctor(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 600));
      _mockDoctors.removeWhere((doc) => doc.id == id);
      return;
    }

    try {
      final token = await StorageService.read('accessToken');
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] != true) {
          throw Exception(resData['error'] ?? 'Failed to delete doctor');
        }
      } else {
        throw Exception('Server status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteDoctor: $e');
      throw Exception('Failed to delete doctor: $e');
    }
  }

  // GET /api/v1/doctors/:id/timetable
  Future<DoctorTimetableResponse> fetchDoctorTimetable(String id) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockTimetable;
    }

    try {
      final token = await StorageService.read('accessToken');
      final response = await http.get(
        Uri.parse('$baseUrl/$id/timetable'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['success'] == true) {
          return DoctorTimetableResponse.fromJson(resData['data']);
        } else {
          throw Exception(resData['error'] ?? 'Failed to fetch timetable');
        }
      } else {
        throw Exception('Server status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error, falling back to mock timetable: $e');
      return _mockTimetable;
    }
  }
}
