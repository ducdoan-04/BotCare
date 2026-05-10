class Doctor {
  final String id;
  final String fullName;
  final String? profileImageUrl;
  final String? gender;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? specialization;
  final String? experience;
  final String? education;
  final String? licenseNumber;
  final String status;
  final String workingHours;
  final double rating;
  final int totalReviews;
  final int totalPatients;
  final int surgeries;
  final double patientsIncreasePercent;

  Doctor({
    required this.id,
    required this.fullName,
    this.profileImageUrl,
    this.gender,
    this.email,
    this.phoneNumber,
    this.address,
    this.specialization,
    this.experience,
    this.education,
    this.licenseNumber,
    required this.status,
    required this.workingHours,
    required this.rating,
    required this.totalReviews,
    required this.totalPatients,
    required this.surgeries,
    required this.patientsIncreasePercent,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      gender: json['gender'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      specialization: json['specialization'] ?? 'General Practitioner',
      experience: json['experience'] ?? '1+ Years',
      education: json['education'] ?? 'Medical Degree',
      licenseNumber: json['license_number'],
      status: json['status'] ?? 'Available',
      workingHours: json['working_hours'] ?? '9AM - 2PM',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      totalPatients: json['total_patients'] ?? 0,
      surgeries: json['surgeries'] ?? 0,
      patientsIncreasePercent: (json['patients_increase_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'gender': gender,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'specialization': specialization,
      'experience': experience,
      'education': education,
      'license_number': licenseNumber,
      'status': status,
      'working_hours': workingHours,
      'rating': rating,
      'total_reviews': totalReviews,
      'total_patients': totalPatients,
      'surgeries': surgeries,
      'patients_increase_percent': patientsIncreasePercent,
    };
  }
}

class DoctorAppointment {
  final String id;
  final String doctorId;
  final String patientName;
  final String consultationType;
  final String appointmentTime;
  final String category; // 'Check-up', 'Urgent visit'
  final String status; // 'Confirm', 'Canceled', 'Pending'

  DoctorAppointment({
    required this.id,
    required this.doctorId,
    required this.patientName,
    required this.consultationType,
    required this.appointmentTime,
    required this.category,
    required this.status,
  });

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) {
    return DoctorAppointment(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      patientName: json['patient_name'] ?? '',
      consultationType: json['consultation_type'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_name': patientName,
      'consultation_type': consultationType,
      'appointment_time': appointmentTime,
      'category': category,
      'status': status,
    };
  }
}

class AvailabilitySlotModel {
  final String id;
  final String doctorId;
  final String timeSlot;
  final bool isBooked;

  AvailabilitySlotModel({
    required this.id,
    required this.doctorId,
    required this.timeSlot,
    required this.isBooked,
  });

  factory AvailabilitySlotModel.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlotModel(
      id: json['id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      isBooked: json['is_booked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'time_slot': timeSlot,
      'is_booked': isBooked,
    };
  }
}

class DoctorTimetableResponse {
  final List<DoctorAppointment> checkUps;
  final List<DoctorAppointment> urgentVisits;
  final List<AvailabilitySlotModel> availability;

  DoctorTimetableResponse({
    required this.checkUps,
    required this.urgentVisits,
    required this.availability,
  });

  factory DoctorTimetableResponse.fromJson(Map<String, dynamic> json) {
    return DoctorTimetableResponse(
      checkUps: (json['check_ups'] as List? ?? [])
          .map((item) => DoctorAppointment.fromJson(item))
          .toList(),
      urgentVisits: (json['urgent_visits'] as List? ?? [])
          .map((item) => DoctorAppointment.fromJson(item))
          .toList(),
      availability: (json['availability'] as List? ?? [])
          .map((item) => AvailabilitySlotModel.fromJson(item))
          .toList(),
    );
  }
}
