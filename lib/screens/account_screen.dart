import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'update_account_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedTab = 0; // 0: Timetable, 1: Today Task, 2: Information

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _buildProfileBox(context),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 24),
                    _buildTabContent(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Account',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'images/avatars/avatar-1.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFF10B981)), // Green
                      ),
                      child: const Text('Available',
                          style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () {
                        showUpdateAccountBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF007A8A), // Teal
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: Colors.white, size: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Nola Hawkins',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Receptionist',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    const Text('30 yrs old',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text('Shift :  ',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    Text('9AM - 2PM',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTabButton('Timetable', 0),
        _buildTabButton('Today Task', 1),
        _buildTabButton('Informartion', 2),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF161B22) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF161B22)
                  : const Color(0xFFDCDFE3),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildTimetableTab();
      case 1:
        return _buildTodayTaskTab();
      case 2:
        return _buildInformationTab();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTimetableTab() {
    return Column(
      children: [
        // Working hours
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Working hours',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              const Text('04h : 10m : 30s',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2)),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEF4444)), // Red
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Clock Out',
                    style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Attendance report
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attendance report',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Tracks attendance and punctuality efficiently.',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              // Legend
              Row(
                children: [
                  const Text('Less',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  _buildLegendBox(const Color(0xFFE5E7EB)),
                  const SizedBox(width: 4),
                  _buildLegendBox(const Color(0xFF67B5BE)),
                  const SizedBox(width: 4),
                  _buildLegendBox(const Color(0xFF008394)), // Teal-ish dark
                  const SizedBox(width: 8),
                  const Text('Full',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 24),
              // Grid heatmap mock
              _buildAttendanceGrid(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: color == const Color(0xFFE5E7EB)
            ? Border.all(color: const Color(0xFFDCDFE3))
            : null,
      ),
    );
  }

  Widget _buildAttendanceGrid() {
    // Mock simple row data
    final hours = [
      '09.00 AM',
      '10.00 AM',
      '11.00 PM',
      '12.00 PM',
      '01.00 PM',
      '02.00 PM'
    ]; // Follows image typo PM for 11?
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Random colors to match mock
    final cDark = const Color(0xFF008394); // primary
    final cMed = const Color(0xFF67B5BE); // primaryLight
    final cLight = const Color(0xFFE5E7EB); // gray 200

    final mockGrid = [
      [cDark, cMed, cDark, cMed, cLight, cMed, cDark],
      [cDark, cDark, cMed, cDark, cMed, cDark, cMed],
      [cMed, cDark, cMed, cLight, cDark, cMed, cDark],
      [cDark, cDark, cLight, cDark, cDark, cMed, cDark],
      [cDark, cLight, cMed, cDark, cMed, cDark, cLight],
      [cLight, cDark, cDark, cMed, cDark, cDark, cDark],
    ];

    Color getColor(int r, int c) {
      if (r < mockGrid.length && c < mockGrid[0].length) {
        return mockGrid[r][c];
      }
      return cDark;
    }

    return Column(
      children: [
        for (int r = 0; r < hours.length; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(hours[r],
                      style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int c = 0; c < 7; c++)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: getColor(r, c),
                            borderRadius: BorderRadius.circular(6),
                            border: getColor(r, c) == cLight
                                ? Border.all(color: const Color(0xFFDCDFE3))
                                : null,
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 50), // alignment
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var day in days)
                    SizedBox(
                      width: 24,
                      child: Center(
                          child: Text(day,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary))),
                    )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildTodayTaskTab() {
    return Column(
      children: [
        _buildTaskCard('09:00 - 10:00 AM', 'Morning check-in & patient queue',
            'Greet patients, log arrivals, prepare forms'),
        _buildTaskCard('10:00 - 12:00 AM', 'Front desk operations',
            'Handle calls, manage bookings, assist walk-ins'),
        _buildTaskCard('02:00 - 04:00 PM', 'Appointment coordination',
            'Manage schedules, confirm bookings, answer inquiries'),
        _buildTaskCard('04:00 - 06:00 PM', 'Reception support',
            'Guide patients, assist staff, handle walk-ins'),
        _buildTaskCard('06:00 - 08:00 PM', 'End-of-day reporting',
            'Summarize activities, update logs, report issues'),
      ],
    );
  }

  Widget _buildTaskCard(String time, String title, String subtitle) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    return Column(
      children: [
        _buildInfoCard(Icons.person_outline, 'Gender', 'Female'),
        _buildInfoCard(
            Icons.email_outlined, 'Email', 'kathry.murp@example.com'),
        _buildInfoCard(Icons.phone_outlined, 'Phone number', '(704) 555-0127'),
        _buildInfoCard(Icons.location_on_outlined, 'Address',
            '6391 Elgin St. Celina, Delaware 10299'),
        _buildInfoCard(
            Icons.calendar_today_outlined, 'Joining date', 'March 15, 2020'),
        _buildInfoCard(
          Icons.file_copy_outlined,
          'Professional summary',
          'Kathryn is a highly dedicated receptionist with 4+ years of experience ensuring smooth front-desk operations, patient scheduling.',
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
