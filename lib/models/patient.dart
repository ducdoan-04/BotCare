class Patient {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? email;
  final String? phone;
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? bloodType;
  final String? allergies;
  final String status;
  final String? assignedDoctorId;
  final String? specialistDepartment;
  final DateTime? registeredAt;
  final String? lastVisitDate; // Calculated from appointments
  final String? assignedDoctorName; // Joined from Doctor model

  Patient({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.email,
    this.phone,
    this.address,
    this.country,
    this.state,
    this.city,
    this.bloodType,
    this.allergies,
    this.status = 'Under Treatment',
    this.assignedDoctorId,
    this.specialistDepartment,
    this.registeredAt,
    this.lastVisitDate,
    this.assignedDoctorName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      bloodType: json['blood_type'],
      allergies: json['allergies'],
      status: json['status'] ?? 'Under Treatment',
      assignedDoctorId: json['assigned_doctor_id'],
      specialistDepartment: json['specialist_department'],
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at']) : null,
      lastVisitDate: json['last_visit_date'],
      assignedDoctorName: json['assigned_doctor'] != null ? json['assigned_doctor']['full_name'] : null,
    );
  }
}
