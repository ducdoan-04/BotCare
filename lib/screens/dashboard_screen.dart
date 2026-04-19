import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import 'help_center_screen.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import 'splash_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- FIXED TOP SECTION ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'images/logo/logo-v2.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationScreen(),
                                ),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppColors.border, width: 1),
                                  ),
                                  child: const Icon(Icons.notifications_none,
                                      color: AppColors.textPrimary, size: 24),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF04438),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.background, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: PopupMenuButton<int>(
                              offset: const Offset(0, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color: Colors.white,
                              elevation: 8,
                              onSelected: (value) {
                                if (value == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const AccountScreen()));
                                } else if (value == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ChangePasswordScreen()));
                                } else if (value == 3) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const SettingsScreen()));
                                } else if (value == 4) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const HelpCenterScreen()));
                                } else if (value == 5) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SplashScreen()),
                                    (route) => false,
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  enabled: false,
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 18,
                                        backgroundImage: AssetImage(
                                            'images/avatars/avatar-1.jpg'),
                                        backgroundColor: Colors.grey,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Nola Hawkins',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                  fontSize: 15)),
                                          Text('Receptionist',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textSecondary)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                _buildPopupItem(1, Icons.person, 'Account'),
                                _buildPopupItem(
                                    2, Icons.lock, 'Change password'),
                                _buildPopupItem(3, Icons.settings, 'Settings'),
                                _buildPopupItem(4, Icons.help_outline, 'Help'),
                                _buildPopupItem(5, Icons.logout, 'Logout',
                                    color: AppColors.error),
                              ],
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.border, width: 1),
                                ),
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage('images/avatars/avatar-1.jpg'),
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Time Filters (Today, This Week, This Month)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Today', true),
                        const SizedBox(width: 12),
                        _buildFilterChip('This Week', false),
                        const SizedBox(width: 12),
                        _buildFilterChip('This Month', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // --- SCROLLABLE BOTTOM SECTION ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Total doctors',
                            value: '120',
                            subtitle: 'Total doctors who have\ncollaborated',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Appointments',
                            value: '260',
                            subtitle:
                                'Total appointments today\n', // Added \n to align with the left card
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Patient Chart Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Patients',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Insightful overview of patient recovery and ongoing\nratio',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              _buildStatIndicator('86', 'Under treatment',
                                  const Color(0xFF007A8A)),
                              const SizedBox(width: 48),
                              _buildStatIndicator(
                                  '54', 'Recovered', const Color(0xFF10B981)),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 180,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 10,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(
                                          0xFFF1F5F9), // Light dashed line
                                      strokeWidth: 1.5,
                                      dashArray: [6, 6],
                                    );
                                  },
                                ),
                                rangeAnnotations: RangeAnnotations(
                                  verticalRangeAnnotations: [
                                    VerticalRangeAnnotation(
                                      x1: 1.6, // "Fri" highlight
                                      x2: 2.4,
                                      color: const Color(
                                          0xFFE2EFF0), // Light cyan highlight
                                    ),
                                  ],
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        const titles = [
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sun'
                                        ];
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < titles.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: Text(
                                              titles[value.toInt()],
                                              style: const TextStyle(
                                                  color: AppColors.textLight,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 10,
                                      reservedSize: 28,
                                      getTitlesWidget: (value, meta) {
                                        if (value == 40) {
                                          return const Text('0',
                                              style: TextStyle(
                                                  color: AppColors.textLight,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500));
                                        }
                                        if (value % 10 == 0 &&
                                            value >= 50 &&
                                            value <= 90) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: const TextStyle(
                                                color: AppColors.textLight,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                minX: 0,
                                maxX: 3,
                                minY: 40, // Base level acts as 0
                                maxY: 95,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: const [
                                      FlSpot(0, 75),
                                      FlSpot(1, 72),
                                      FlSpot(2, 85),
                                      FlSpot(3, 70),
                                    ],
                                    isCurved: true,
                                    color: const Color(
                                        0xFF007A8A), // Under treatment color
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      checkToShowDot: (spot, barData) =>
                                          spot.x == 2, // Dot only on Fri
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          strokeColor: const Color(0xFF007A8A),
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF007A8A)
                                              .withOpacity(0.15),
                                          const Color(0xFF007A8A)
                                              .withOpacity(0.0),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: const [
                                      FlSpot(0, 52),
                                      FlSpot(1, 50),
                                      FlSpot(2, 58),
                                      FlSpot(3, 60),
                                    ],
                                    isCurved: true,
                                    color: const Color(
                                        0xFF10B981), // Recovered color
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      checkToShowDot: (spot, barData) =>
                                          spot.x == 2, // Dot only on Fri
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          strokeColor: const Color(0xFF10B981),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Appointments Section Header
                    _buildSectionHeader(
                        'Appointments',
                        'Key statistics on the most frequently visited polyclinics',
                        context),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          _buildAppointmentItem('Jacob Jones',
                              'Headache Disease', '09.40 AM', '2',
                              hasRedDot: true),
                          _buildAppointmentItem('Jenny Wilson',
                              'Abdominal Pain', '10.40 AM', '3'),
                          _buildAppointmentItem(
                              'Robert Fox', 'Swelling', '11.20 AM', '4'),
                          _buildAppointmentItem(
                              'Jane Cooper', 'Cardiology', '12.10 AM', '5'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Doctor's Schedule Section Header
                    _buildSectionHeader(
                        'Doctor\'s schedule',
                        'Key statistics on the most frequently visited polyclinics',
                        context),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          _buildDoctorScheduleItem('DR. Johan Henry',
                              'General Practitioners', true, '', '6'),
                          _buildDoctorScheduleItem(
                              'DR. David Cooper', 'Cardiology', true, '', '7'),
                          _buildDoctorScheduleItem(
                              'DR. Brooklyn Simmons',
                              'Dermatology',
                              false,
                              'Available at\n2.30 PM',
                              '8'),
                          _buildDoctorScheduleItem(
                              'DR. Theresa Webb',
                              'Pediatrics',
                              false,
                              'Available at\n2.30 PM',
                              '9'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Polyclinics Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                              'Polyclinics',
                              'Key statistics on the most frequently\nvisited polyclinics',
                              context,
                              insideCard: true),
                          const SizedBox(height: 32),

                          // Polyclinic vertical bar chart
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildPolyclinicBar('80', 'General', 140,
                                  const Color(0xFF007A8A)),
                              _buildPolyclinicBar('50', 'Pediatrics', 100,
                                  const Color(0xFF389EA8)),
                              _buildPolyclinicBar('40', 'Cardiology', 85,
                                  const Color(0xFF6AB1B8)),
                              _buildPolyclinicBar('30', 'Dermatology', 70,
                                  const Color(0xFFB2D4D8)),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Bottom Stats text
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '+35%',
                                style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.0),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  const TextSpan(
                                    text: 'Data increase from the last day.\n',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        height: 1.5,
                                        fontWeight: FontWeight.normal),
                                    children: [
                                      TextSpan(
                                        text: '120 to 200 ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary),
                                      ),
                                      TextSpan(text: 'patients.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text.rich(
                            const TextSpan(
                              text: '20 ',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text:
                                      'patients have been treated and recovered',
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height:
                            20), // Reduced bottom padding for floating nav bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String label,
      {Color? color}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: color ?? AppColors.textPrimary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF161B22)
            : Colors.transparent, // dark pill
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? const Color(0xFF161B22) : const Color(0xFFDCDFE3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14, // Adjusted slightly for fit
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_outward,
                    size: 14, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatIndicator(String value, String label, Color dotColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
      String title, String subtitle, BuildContext context,
      {bool insideCard = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: insideCard ? AppColors.background : Colors.white,
          ),
          child: const Icon(Icons.arrow_outward,
              size: 16, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildAppointmentItem(
      String name, String dept, String time, String avatarId,
      {bool hasRedDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    AssetImage('images/avatars/avatar-$avatarId.jpg'),
              ),
              if (hasRedDot)
                Positioned(
                  top: 2,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF04438),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(dept,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Today ',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    Text(time,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: AppColors.background, shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_rounded,
                size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: AppColors.background, shape: BoxShape.circle),
            child:
                const Icon(Icons.phone, size: 20, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorScheduleItem(String name, String dept, bool available,
      String availableText, String avatarId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('images/avatars/avatar-$avatarId.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(dept,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (available)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success, width: 1),
              ),
              child: const Text('Available',
                  style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                      fontSize: 12)),
            )
          else
            Text(
              availableText,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildPolyclinicBar(
      String val, String label, double height, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Container(
          width: 50,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
