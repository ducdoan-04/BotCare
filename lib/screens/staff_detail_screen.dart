import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
// Note: We would import update staff screen if it exists
// import 'update_staff_screen.dart';

class StaffDetailScreen extends StatefulWidget {
  final Map<String, dynamic> staff;
  final int index;

  const StaffDetailScreen(
      {super.key, required this.staff, required this.index});

  @override
  State<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  int _activeTab = 0; // 0: Timetable, 1: Summary, 2: Information

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP BAR ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
                      child: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Staff profile',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: AssetImage(
                    'images/avatars-staff/avatar-${widget.staff['avatarId']}.jpg'),
                fit: BoxFit.cover,
                colorFilter: widget.staff['available']
                    ? null
                    : const ColorFilter.matrix(<double>[
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.staff['available']
                          ? AppColors.success
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  child: Text(
                    widget.staff['available'] ? 'Available' : 'Not Available',
                    style: TextStyle(
                      color: widget.staff['available']
                          ? AppColors.success
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.staff['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                    children: [
                      TextSpan(text: widget.staff['role']),
                      const TextSpan(text: '  •  '),
                      const TextSpan(text: '30 yrs old'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // NOTE: Implementation for UpdateStaffScreen goes here
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 18),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF111827)
                : Colors.transparent, // Dark text color for selected tab
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isSelected ? const Color(0xFF111827) : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableTab() {
    return Column(
      children: [
        // Attendance Report Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attendance report',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Tracks attendance and punctuality efficiently.',
                  style:
                      TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 20),

              // Map legend
              Row(
                children: [
                  const Text('Less',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(width: 8),
                  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 4),
                  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          color: const Color(0xFF7DD3FC),
                          borderRadius:
                              BorderRadius.circular(4))), // Approximate color
                  const SizedBox(width: 4),
                  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          color: const Color(0xFF008394),
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(width: 8),
                  const Text('Full',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 24),

              // Heatmap grid - rows are times, columns are days
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time labels
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _timeLabel('09.00 AM'),
                      _timeLabel('10.00 AM'),
                      _timeLabel('11.00 AM'),
                      _timeLabel('12.00 PM'),
                      _timeLabel('01.00 PM'),
                      _timeLabel('02.00 PM'),
                      const SizedBox(height: 24), // empty corner for day labels
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Grid
                  Expanded(
                    child: Column(
                      children: [
                        _buildGridRow([2, 1, 2, 1, 0, 1, 2]),
                        _buildGridRow([2, 2, 0, 2, 0, 2, 0]),
                        _buildGridRow([1, 2, 1, 0, 2, 1, 2]),
                        _buildGridRow([2, 2, 0, 2, 2, 1, 2]),
                        _buildGridRow([2, 0, 1, 2, 1, 2, 0]),
                        _buildGridRow([0, 2, 2, 1, 2, 2, 2]),

                        const SizedBox(height: 8),
                        // Day labels
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Mon',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Tue',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Wed',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Thu',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Fri',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Sat',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            Text('Sun',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Today Task Card
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
                children: [
                  const Text('Today task',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const Spacer(),
                  RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: '2',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    TextSpan(
                        text: '/8',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ])),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.chevron_left,
                        size: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.chevron_right,
                        size: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTaskCard(
                  '09:00 - 10:00 AM',
                  'Morning check-in & patient queue',
                  'Greet patients, log arrivals, prepare forms'),
              const SizedBox(height: 16),
              _buildTaskCard('10:00 - 12:00 AM', 'Front desk operations',
                  'Handle calls, manage bookings, assist walk-ins'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timeLabel(String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Text(time,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    );
  }

  Widget _buildGridRow(List<int> intensities) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: intensities.map((val) {
          Color c;
          if (val == 0) {
            c = const Color(0xFFE5E7EB);
          } else if (val == 1) {
            c = const Color(0xFF7DD3FC); // light teal mock
          } else {
            c = const Color(0xFF008394); // main teal
          }
          return Expanded(
            child: Container(
              height: 28, // scale according to width gracefully
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(String time, String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return Column(
      children: [
        _buildSummaryStatCard(
          title: 'In company',
          value: '4',
          unit: 'yrs',
          desc: 'Has been working at the clinic for 4 years.',
          icon: Icons.domain,
          iconBgColor: const Color(0xFFE6F2F3),
          iconColor: const Color(0xFF008394),
        ),
        const SizedBox(height: 16),
        _buildSummaryStatCard(
          title: 'Avg. shift hours',
          value: '5.5',
          unit: 'hrs',
          desc: 'Works around 5.5 hours per day on average.',
          icon: Icons.schedule,
          iconBgColor: const Color(0xFFFEE4E2), // Reddish
          iconColor: const Color(0xFFD92D20), // Red
        ),
        const SizedBox(height: 16),
        _buildSummaryStatCard(
          title: 'Attendance rate',
          value: '96',
          unit: '%',
          desc: 'Almost always arrives on time.',
          icon: Icons.verified,
          iconBgColor: const Color(0xFFFFFAEB), // Yellowish
          iconColor: const Color(0xFFF79009), // Yellow
        ),
      ],
    );
  }

  Widget _buildSummaryStatCard({
    required String title,
    required String value,
    required String unit,
    required String desc,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
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
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(width: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  Text(unit,
                      style: const TextStyle(
                          fontSize: 24, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(desc,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
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
        _buildInfoCard(Icons.schedule, 'Shift', widget.staff['shift']),
        _buildInfoCard(Icons.person_outline, 'Gender', 'Female'),
        _buildInfoCard(
            Icons.email_outlined, 'Email', 'kathry.murp@example.com'),
        _buildInfoCard(Icons.phone_outlined, 'Phone number', '(704) 555-0127'),
        _buildInfoCard(Icons.location_on_outlined, 'Address',
            '6391 Elgin St. Celina, Delaware 10299'),
        _buildInfoCard(
            Icons.calendar_month_outlined, 'Joining date', 'March 15, 2020'),
        _buildInfoCard(Icons.badge_outlined, 'Professional summary',
            'Kathryn is a highly dedicated receptionist with 4+ years of experience ensuring smooth front-desk operations, patient scheduling.'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: AppColors.background, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
