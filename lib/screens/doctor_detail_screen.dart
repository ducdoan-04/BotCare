import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final int index;

  const DoctorDetailScreen({super.key, required this.doctor, required this.index});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  int _activeTab = 0; // 0: Timetable, 1: Summary, 2: Information
  int _timetableSubTab = 0; // 0: Check-up, 1: Urgent visit

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
                image: AssetImage('images/avatars-doctor/avatar-${widget.index + 1}.jpg'),
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
                    border: Border.all(color: const Color(0xFF05B93E), width: 1),
                  ),
                  child: const Text(
                    'Available',
                    style: TextStyle(
                      color: Color(0xFF05B93E),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.doctor['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  widget.doctor['specialty'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        const TextSpan(
                          text: '4',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: _timetableSubTab == 0 ? '/8' : '/4',
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
                  _buildSubTab(0, 'Check-up (8)'),
                  const SizedBox(width: 12),
                  _buildSubTab(1, 'Urgent visit (4)'),
                ],
              ),
              const SizedBox(height: 24),
              if (_timetableSubTab == 0)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildAppointmentCard('Confirm', '09.40 AM', 'Routine check up', 'Leslie Alexander', const Color(0xFF027A48), const Color(0xFFECFDF3)),
                    _buildAppointmentCard('Canceled', '09.40 AM', 'Routine check up', 'Leslie Alexander', const Color(0xFFB42318), const Color(0xFFFEF3F2)),
                    _buildAppointmentCard('Canceled', '09.40 AM', 'Routine check up', 'Leslie Alexander', const Color(0xFFB42318), const Color(0xFFFEF3F2)),
                    _buildAppointmentCard('Pending', '09.40 AM', 'Routine check up', 'Leslie Alexander', const Color(0xFF667085), const Color(0xFFF2F4F7)),
                  ],
                )
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildAppointmentCard('Pending', '09.40 AM', 'Dermatology consultation', 'Savannah Nguyen', const Color(0xFF667085), const Color(0xFFF2F4F7), cardBgColor: const Color(0xFFFFF5F2), cardBorderColor: const Color(0xFFFCAE91)),
                    _buildAppointmentCard('Confirm', '09.40 AM', 'Dermatology consultation', 'Savannah Nguyen', const Color(0xFF027A48), const Color(0xFFECFDF3), cardBgColor: const Color(0xFFFFF5F2), cardBorderColor: const Color(0xFFFCAE91)),
                    _buildAppointmentCard('Confirm', '09.40 AM', 'Dermatology consultation', 'Savannah Nguyen', const Color(0xFF027A48), const Color(0xFFECFDF3), cardBgColor: const Color(0xFFFFF5F2), cardBorderColor: const Color(0xFFFCAE91)),
                    _buildAppointmentCard('Confirm', '09.40 AM', 'Dermatology consultation', 'Savannah Nguyen', const Color(0xFF027A48), const Color(0xFFECFDF3), cardBgColor: const Color(0xFFFFF5F2), cardBorderColor: const Color(0xFFFCAE91)),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTimeSlot('09.00:AM', isDisabled: true),
                  _buildTimeSlot('09.30:AM'),
                  _buildTimeSlot('10.00:AM'),
                  _buildTimeSlot('10.30:AM'),
                  _buildTimeSlot('11.30:AM'),
                  _buildTimeSlot('12.00:PM', isDisabled: true),
                  _buildTimeSlot('02.00:PM'),
                  _buildTimeSlot('02.30:PM'),
                ],
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

  Widget _buildAppointmentCard(String status, String time, String title, String patient, Color textColor, Color badgeBgColor, {Color? cardBgColor, Color? cardBorderColor}) {
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
              status,
              style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const Spacer(),
          Text(patient, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, {bool isDisabled = false}) {
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
        time,
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
        _buildSummaryItem('Total patients', '230', '', Icons.people_outline, const Color(0xFF008394), const Color(0xFFE6F2F3), subtext: 'Have increased from yesterday', trendPercent: '3.5%'),
        const SizedBox(height: 16),
        _buildSummaryItem('Surgeries', '90', '', Icons.colorize, const Color(0xFFD92D20), const Color(0xFFFEF3F2), subtext: 'Total space ready for use by the patient.'),
        const SizedBox(height: 16),
        _buildSummaryItem('Reviews', '4.5', '/5.0', Icons.star_rounded, const Color(0xFFF79009), const Color(0xFFFFFAEB), subtext: 'Based on 120 reviews from patient.'),
      ],
    );
  }

  Widget _buildSummaryItem(String title, String value, String suffix, IconData icon, Color iconColor, Color iconBgColor, {required String subtext, String? trendPercent}) {
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
        _buildInfoCard(Icons.person_outline, 'Gender', 'Male'),
        _buildInfoCard(Icons.email_outlined, 'Email', 'alma.lawson@example.com'),
        _buildInfoCard(Icons.phone_outlined, 'Phone number', '(704) 555-0127'),
        _buildInfoCard(Icons.location_on_outlined, 'Address', '6391 Elgin St. Celina, Delaware 10299'),
        _buildInfoCard(Icons.layers_outlined, 'Experience', '10+ Years'),
        _buildInfoCard(Icons.school_outlined, 'Education', 'Harvard Medical School'),
        _buildInfoCard(Icons.badge_outlined, 'License number', 'MD-2023-4982'),
        _buildInfoCard(Icons.psychology_outlined, 'Specialization', 'Neurologist'),
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
