import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_colors.dart';
import '../models/doctor_model.dart';
import '../repositories/doctor_repository.dart';
import 'update_doctor_screen.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final _repository = DoctorRepository();
  
  late Doctor _doctor;
  int _activeTab = 0; // 0: Timetable, 1: Summary, 2: Information
  int _timetableSubTab = 0; // 0: Check-up, 1: Urgent visit

  DoctorTimetableResponse? _timetable;
  bool _isTimetableLoading = true;
  String _timetableError = '';

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
    _fetchTimetable();
  }

  Future<void> _fetchTimetable() async {
    setState(() {
      _isTimetableLoading = true;
      _timetableError = '';
    });

    try {
      final timetableData = await _repository.fetchDoctorTimetable(_doctor.id);
      setState(() {
        _timetable = timetableData;
        _isTimetableLoading = false;
      });
    } catch (e) {
      setState(() {
        _timetableError = e.toString().replaceAll('Exception: ', '');
        _isTimetableLoading = false;
      });
    }
  }

  // Reload doctor detail if updated
  Future<void> _refreshDoctorProfile() async {
    try {
      final updatedDoctor = await _repository.fetchDoctorById(_doctor.id);
      setState(() {
        _doctor = updatedDoctor;
      });
    } catch (e) {
      print('Failed to refresh doctor profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Doctor profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // --- PROFILE HEADER CARD ---
                    _buildProfileHeader(),
                    const SizedBox(height: 24),

                    // --- TAB BAR ---
                    Row(
                      children: [
                        _buildTabItem(0, 'Timetable'),
                        const SizedBox(width: 12),
                        _buildTabItem(1, 'Summary'),
                        const SizedBox(width: 12),
                        _buildTabItem(2, 'Information'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- TAB CONTENT ---
                    if (_activeTab == 0) _buildTimetableTab(),
                    if (_activeTab == 1) _buildSummaryTab(),
                    if (_activeTab == 2) _buildInformationTab(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final bool isAvailable = _doctor.status.toLowerCase() == 'available';

    // Image fallback logic for asset or default network profiles
    ImageProvider profileImage;
    if (_doctor.profileImageUrl != null && _doctor.profileImageUrl!.startsWith('images/')) {
      profileImage = AssetImage(_doctor.profileImageUrl!);
    } else if (_doctor.profileImageUrl != null && _doctor.profileImageUrl!.startsWith('uploads/')) {
      final host = kIsWeb ? Uri.base.host : '192.168.1.8';
      final finalHost = (host.isEmpty || host == 'localhost') ? '192.168.1.8' : host;
      profileImage = NetworkImage('http://$finalHost:3000/${_doctor.profileImageUrl!}');
    } else if (_doctor.profileImageUrl != null && _doctor.profileImageUrl!.startsWith('http')) {
      profileImage = NetworkImage(_doctor.profileImageUrl!);
    } else {
      profileImage = const AssetImage('images/avatars-doctor/avatar-1.jpg');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: profileImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isAvailable ? const Color(0xFF05B93E) : AppColors.textSecondary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Away',
                    style: TextStyle(
                      color: isAvailable ? const Color(0xFF05B93E) : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _doctor.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _doctor.specialization ?? 'General Practitioner',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => UpdateDoctorScreen(
                              doctor: _doctor.toJson(),
                              index: 0,
                            ),
                          );
                          if (result == true) {
                            _refreshDoctorProfile();
                            _fetchTimetable();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCircularIcon(Icons.phone_outlined),
                    const SizedBox(width: 8),
                    _buildCircularIcon(Icons.chat_bubble_outline),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 20),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF161B22) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? const Color(0xFF161B22) : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableTab() {
    if (_isTimetableLoading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Color(0xFF008394)),
      );
    }

    if (_timetableError.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text(_timetableError, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchTimetable,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008394)),
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    final t = _timetable!;
    final totalPatientsCount = t.checkUps.length + t.urgentVisits.length;
    final activeAppointments = _timetableSubTab == 0 ? t.checkUps : t.urgentVisits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- APPOINTMENTS WRAPPER ---
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Today patient  ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: '$totalPatientsCount',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: _timetableSubTab == 0 ? '/${t.checkUps.length}' : '/${t.urgentVisits.length}',
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildSmallArrow(Icons.chevron_left),
                      const SizedBox(width: 8),
                      _buildSmallArrow(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildSubTab(0, 'Check-up (${t.checkUps.length})'),
                  const SizedBox(width: 12),
                  _buildSubTab(1, 'Urgent visit (${t.urgentVisits.length})'),
                ],
              ),
              const SizedBox(height: 24),
              if (activeAppointments.isEmpty)
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: const Text('No appointments for today', style: TextStyle(color: AppColors.textSecondary)),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: activeAppointments.length,
                  itemBuilder: (context, idx) {
                    final app = activeAppointments[idx];
                    return _buildDynamicAppointmentCard(app);
                  },
                )
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- AVAILABILITY CARD ---
        Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Availability',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              if (t.availability.isEmpty)
                const Text('No availability slots defined', style: TextStyle(color: AppColors.textSecondary))
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: t.availability.map((slot) {
                    return _buildTimeSlot(slot.timeSlot, isDisabled: slot.isBooked);
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallArrow(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.textSecondary),
    );
  }

  Widget _buildSubTab(int index, String label) {
    final isSelected = _timetableSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _timetableSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F2F3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF008394) : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF008394) : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicAppointmentCard(DoctorAppointment app) {
    Color textColor = const Color(0xFF667085);
    Color badgeBgColor = const Color(0xFFF2F4F7);
    Color? cardBgColor;
    Color? cardBorderColor;

    final status = app.status.toLowerCase();
    if (status == 'confirm') {
      textColor = const Color(0xFF027A48);
      badgeBgColor = const Color(0xFFECFDF3);
    } else if (status == 'canceled') {
      textColor = const Color(0xFFB42318);
      badgeBgColor = const Color(0xFFFEF3F2);
    } else if (status == 'pending') {
      textColor = const Color(0xFFF79009);
      badgeBgColor = const Color(0xFFFFFAEB);
    }

    if (app.category.toLowerCase() == 'urgent visit') {
      cardBgColor = const Color(0xFFFFF5F2);
      cardBorderColor = const Color(0xFFFCAE91);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorderColor ?? AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: textColor.withOpacity(0.5)),
            ),
            child: Text(
              app.status,
              style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(app.appointmentTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(app.consultationType, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Text(app.patientName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, {bool isDisabled = false}) {
    // Normalizing display format e.g. "09.00:AM" to "09:00 AM" or similar
    final formattedTime = time.replaceAll('.', ':').replaceAll(':', ' ');

    return Container(
      width: (MediaQuery.of(context).size.width - 96 - 24) / 3, // Approx 3 columns
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDisabled ? AppColors.background : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Text(
        formattedTime,
        style: TextStyle(
          color: isDisabled ? AppColors.textSecondary.withOpacity(0.5) : AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return Column(
      children: [
        _buildSummaryItem(
          'Total patients',
          '${_doctor.totalPatients}',
          '',
          Icons.people_outline,
          const Color(0xFF008394),
          const Color(0xFFE6F2F3),
          subtext: 'Have increased from yesterday',
          trendPercent: '${_doctor.patientsIncreasePercent}%',
        ),
        const SizedBox(height: 16),
        _buildSummaryItem(
          'Surgeries',
          '${_doctor.surgeries}',
          '',
          Icons.colorize,
          const Color(0xFFD92D20),
          const Color(0xFFFEF3F2),
          subtext: 'Total space ready for use by the patient.',
        ),
        const SizedBox(height: 16),
        _buildSummaryItem(
          'Reviews',
          '${_doctor.rating}',
          '/5.0',
          Icons.star_rounded,
          const Color(0xFFF79009),
          const Color(0xFFFFFAEB),
          subtext: 'Based on ${_doctor.totalReviews} reviews from patient.',
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    String suffix,
    IconData icon,
    Color iconColor,
    Color iconBgColor, {
    required String subtext,
    String? trendPercent,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  if (suffix.isNotEmpty)
                    Text(suffix, style: const TextStyle(fontSize: 24, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: trendPercent != null 
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '$trendPercent ', style: const TextStyle(color: Color(0xFF05B93E), fontWeight: FontWeight.bold, fontSize: 13)),
                          TextSpan(text: subtext, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ]
                      )
                    )
                  : Text(subtext, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    return Column(
      children: [
        _buildInfoCard(Icons.person_outline, 'Gender', _doctor.gender ?? 'Male'),
        _buildInfoCard(Icons.email_outlined, 'Email', _doctor.email ?? 'Not specified'),
        _buildInfoCard(Icons.phone_outlined, 'Phone number', _doctor.phoneNumber ?? 'Not specified'),
        _buildInfoCard(Icons.location_on_outlined, 'Address', _doctor.address ?? 'Not specified'),
        _buildInfoCard(Icons.layers_outlined, 'Experience', _doctor.experience ?? '1+ Years'),
        _buildInfoCard(Icons.school_outlined, 'Education', _doctor.education ?? 'Medical Degree'),
        _buildInfoCard(Icons.badge_outlined, 'License number', _doctor.licenseNumber ?? 'Not specified'),
        _buildInfoCard(Icons.psychology_outlined, 'Specialization', _doctor.specialization ?? 'General Practitioner'),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
