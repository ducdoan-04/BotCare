class Staff {
  final String id;
  final String fullName;
  final String? profileImageUrl;
  final String role;
  final String? shift;
  final String? gender;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime joiningDate;
  final String? professionalSummary;
  final String status;

  Staff({
    required this.id,
    required this.fullName,
    this.profileImageUrl,
    required this.role,
    this.shift,
    this.gender,
    this.email,
    this.phone,
    this.address,
    required this.joiningDate,
    this.professionalSummary,
    required this.status,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      role: json['role'] ?? 'Staff',
      shift: json['shift'] ?? '9AM - 2PM',
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      joiningDate: json['joining_date'] != null ? DateTime.parse(json['joining_date']) : DateTime.now(),
      professionalSummary: json['professional_summary'],
      status: json['status'] ?? 'Available',
    );
  }
}

class StaffStat {
  final int value;
  final String label;
  final String description;

  StaffStat({required this.value, required this.label, required this.description});

  factory StaffStat.fromJson(Map<String, dynamic> json) {
    return StaffStat(
      value: json['value'] ?? 0,
      label: json['label'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class StaffSummary {
  final StaffStat inCompany;
  final StaffStat avgShiftHours;
  final StaffStat attendanceRate;

  StaffSummary({
    required this.inCompany,
    required this.avgShiftHours,
    required this.attendanceRate,
  });

  factory StaffSummary.fromJson(Map<String, dynamic> json) {
    return StaffSummary(
      inCompany: StaffStat.fromJson(json['in_company']),
      avgShiftHours: StaffStat.fromJson(json['avg_shift_hours']),
      attendanceRate: StaffStat.fromJson(json['attendance_rate']),
    );
  }
}

class StaffTask {
  final String id;
  final String title;
  final String? description;
  final String? startTime;
  final String? endTime;
  final bool isCompleted;

  StaffTask({
    required this.id,
    required this.title,
    this.description,
    this.startTime,
    this.endTime,
    required this.isCompleted,
  });

  factory StaffTask.fromJson(Map<String, dynamic> json) {
    return StaffTask(
      id: json['id'] ?? '',
      title: json['task_title'] ?? '',
      description: json['task_description'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isCompleted: json['is_completed'] ?? false,
    );
  }
}

class AttendanceRecord {
  final String id;
  final DateTime date;
  final int level;

  AttendanceRecord({required this.id, required this.date, required this.level});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      level: json['attendance_level'] ?? 0,
    );
  }
}

class StaffTimetable {
  final List<StaffTask> todayTasks;
  final List<AttendanceRecord> attendanceReport;

  StaffTimetable({required this.todayTasks, required this.attendanceReport});

  factory StaffTimetable.fromJson(Map<String, dynamic> json) {
    return StaffTimetable(
      todayTasks: (json['today_tasks'] as List? ?? []).map((e) => StaffTask.fromJson(e)).toList(),
      attendanceReport: (json['attendance_report'] as List? ?? []).map((e) => AttendanceRecord.fromJson(e)).toList(),
    );
  }
}
