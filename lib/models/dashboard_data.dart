class DashboardSummary {
  final int totalDoctors;
  final int totalAppointments;
  final int underTreatmentCount;
  final int recoveredCount;

  DashboardSummary({
    required this.totalDoctors,
    required this.totalAppointments,
    required this.underTreatmentCount,
    required this.recoveredCount,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      totalDoctors: json['total_doctors'] ?? 0,
      totalAppointments: json['total_appointments'] ?? 0,
      underTreatmentCount: json['under_treatment_count'] ?? 0,
      recoveredCount: json['recovered_count'] ?? 0,
    );
  }
}

class PatientChartItem {
  final String label;
  final int underTreatment;
  final int recovered;

  PatientChartItem({
    required this.label,
    required this.underTreatment,
    required this.recovered,
  });

  factory PatientChartItem.fromJson(Map<String, dynamic> json) {
    return PatientChartItem(
      label: json['label'] ?? '',
      underTreatment: json['under_treatment'] ?? 0,
      recovered: json['recovered'] ?? 0,
    );
  }
}

class UpcomingAppointment {
  final String id;
  final String patientName;
  final String reason;
  final String avatar;
  final String time;
  final String doctorName;
  final String specialty;

  UpcomingAppointment({
    required this.id,
    required this.patientName,
    required this.reason,
    required this.avatar,
    required this.time,
    required this.doctorName,
    required this.specialty,
  });

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      id: json['id'] ?? '',
      patientName: json['patient_name'] ?? '',
      reason: json['reason'] ?? '',
      avatar: json['avatar'] ?? '',
      time: json['time'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      specialty: json['specialty'] ?? '',
    );
  }
}

class DoctorScheduleItem {
  final String id;
  final String name;
  final String specialty;
  final String status;
  final String? nextAvailable;
  final String avatar;

  DoctorScheduleItem({
    required this.id,
    required this.name,
    required this.specialty,
    required this.status,
    this.nextAvailable,
    required this.avatar,
  });

  factory DoctorScheduleItem.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      status: json['status'] ?? 'available',
      nextAvailable: json['next_available'],
      avatar: json['avatar'] ?? '',
    );
  }
}

class PolyclinicItem {
  final String id;
  final String name;
  final int patientCount;

  PolyclinicItem({
    required this.id,
    required this.name,
    required this.patientCount,
  });

  factory PolyclinicItem.fromJson(Map<String, dynamic> json) {
    return PolyclinicItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      patientCount: json['patient_count'] ?? 0,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String timeAgo;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.timeAgo,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'alert',
      isRead: json['is_read'] ?? false,
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class NotificationsSection {
  final int unreadCount;
  final List<NotificationItem> list;

  NotificationsSection({
    required this.unreadCount,
    required this.list,
  });

  factory NotificationsSection.fromJson(Map<String, dynamic> json) {
    return NotificationsSection(
      unreadCount: json['unread_count'] ?? 0,
      list: (json['list'] as List? ?? [])
          .map((item) => NotificationItem.fromJson(item))
          .toList(),
    );
  }
}

class DashboardData {
  final DashboardSummary summary;
  final List<PatientChartItem> patientChart;
  final List<UpcomingAppointment> upcomingAppointments;
  final List<DoctorScheduleItem> doctorsSchedule;
  final List<PolyclinicItem> polyclinics;
  final NotificationsSection notifications;

  DashboardData({
    required this.summary,
    required this.patientChart,
    required this.upcomingAppointments,
    required this.doctorsSchedule,
    required this.polyclinics,
    required this.notifications,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      summary: DashboardSummary.fromJson(json['summary'] ?? {}),
      patientChart: (json['patient_chart'] as List? ?? [])
          .map((item) => PatientChartItem.fromJson(item))
          .toList(),
      upcomingAppointments: (json['upcoming_appointments'] as List? ?? [])
          .map((item) => UpcomingAppointment.fromJson(item))
          .toList(),
      doctorsSchedule: (json['doctors_schedule'] as List? ?? [])
          .map((item) => DoctorScheduleItem.fromJson(item))
          .toList(),
      polyclinics: (json['polyclinics'] as List? ?? [])
          .map((item) => PolyclinicItem.fromJson(item))
          .toList(),
      notifications: NotificationsSection.fromJson(json['notifications'] ?? {}),
    );
  }
}
