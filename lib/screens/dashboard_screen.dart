import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import 'help_center_screen.dart';
import 'account_screen.dart';
import 'change_password_screen.dart';
import 'splash_screen.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import '../repositories/dashboard_repository.dart';
import '../models/dashboard_data.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = DashboardRepository();
  String _selectedPeriod = 'week'; // Default: 'week' to match Figma

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<DashboardData>(
          future: _repository.fetchDashboardData(period: _selectedPeriod),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (!snapshot.hasData) {
              return _buildEmptyState();
            }

            final data = snapshot.data!;
            return _buildDashboardContent(data);
          },
        ),
      ),
    );
  }

  // --- ERROR STATE ---
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Oops, something went wrong!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Try Again'),
            )
          ],
        ),
      ),
    );
  }

  // --- EMPTY STATE ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/logo/logo-v2.png', height: 80, opacity: const AlwaysStoppedAnimation(0.4)),
          const SizedBox(height: 16),
          const Text(
            'No data yet - Start by adding your medical team',
            style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // --- SHIMMER SKELETON LOADING ---
  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 40, width: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)))),
              const SizedBox(width: 16),
              Expanded(child: Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)))),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
        ],
      ),
    );
  }

  // --- MAIN DASHBOARD CONTENT ---
  Widget _buildDashboardContent(DashboardData data) {
    return Column(
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
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: const Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 24),
                            ),
                            if (data.notifications.unreadCount > 0)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF04438),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.background, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      data.notifications.unreadCount.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                    ),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: Colors.white,
                          elevation: 8,
                          onSelected: (value) {
                            if (value == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
                            } else if (value == 2) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                            } else if (value == 3) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                            } else if (value == 4) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
                            } else if (value == 5) {
                              context.read<AuthProvider>().logout();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const SplashScreen()),
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
                                    backgroundImage: AssetImage('images/avatars/avatar-1.jpg'),
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        context.watch<AuthProvider>().user?.fullName ?? 'Nola Hawkins',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 15),
                                      ),
                                      Text(
                                        context.watch<AuthProvider>().user?.email ?? 'Receptionist',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            _buildPopupItem(1, Icons.person, 'Account'),
                            _buildPopupItem(2, Icons.lock, 'Change password'),
                            _buildPopupItem(3, Icons.settings, 'Settings'),
                            _buildPopupItem(4, Icons.help_outline, 'Help'),
                            _buildPopupItem(5, Icons.logout, 'Logout', color: AppColors.error),
                          ],
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('images/avatars/avatar-1.jpg'),
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
                    _buildFilterChip('Today', _selectedPeriod == 'today', 'today'),
                    const SizedBox(width: 12),
                    _buildFilterChip('This Week', _selectedPeriod == 'week', 'week'),
                    const SizedBox(width: 12),
                    _buildFilterChip('This Month', _selectedPeriod == 'month', 'month'),
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
            physics: const BouncingScrollPhysics(),
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
                        value: data.summary.totalDoctors.toString(),
                        subtitle: 'Total doctors who have\ncollaborated',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Appointments',
                        value: data.summary.totalAppointments.toString(),
                        subtitle: 'Total appointments today\n',
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
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Insightful overview of patient recovery and ongoing care ratio',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildStatIndicator(data.summary.underTreatmentCount.toString(), 'Under treatment', const Color(0xFF007A8A)),
                          const SizedBox(width: 48),
                          _buildStatIndicator(data.summary.recoveredCount.toString(), 'Recovered', const Color(0xFF10B981)),
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
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xFFF1F5F9), // Light dashed line
                                  strokeWidth: 1.5,
                                  dashArray: [6, 6],
                                );
                              },
                            ),
                            rangeAnnotations: RangeAnnotations(
                              verticalRangeAnnotations: [
                                if (data.patientChart.length >= 3)
                                  VerticalRangeAnnotation(
                                    x1: 1.6, // "Fri" or index 2 highlight
                                    x2: 2.4,
                                    color: const Color(0xFFE2EFF0), // Light cyan highlight
                                  ),
                              ],
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < data.patientChart.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          data.patientChart[index].label,
                                          style: const TextStyle(color: AppColors.textLight, fontSize: 11, fontWeight: FontWeight.w500),
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
                                  interval: 50,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(color: AppColors.textLight, fontSize: 11, fontWeight: FontWeight.w500),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: data.patientChart.isEmpty ? 3 : (data.patientChart.length - 1).toDouble(),
                            minY: 0,
                            maxY: _calculateMaxY(data.patientChart),
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.patientChart.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.underTreatment.toDouble())).toList(),
                                isCurved: true,
                                color: const Color(0xFF007A8A), // Under treatment color
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  checkToShowDot: (spot, barData) => spot.x == (data.patientChart.length >= 3 ? 2 : 0),
                                  getDotPainter: (spot, percent, barData, index) {
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
                                      const Color(0xFF007A8A).withOpacity(0.15),
                                      const Color(0xFF007A8A).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              LineChartBarData(
                                spots: data.patientChart.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.recovered.toDouble())).toList(),
                                isCurved: true,
                                color: const Color(0xFF10B981), // Recovered color
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  checkToShowDot: (spot, barData) => spot.x == (data.patientChart.length >= 3 ? 2 : 0),
                                  getDotPainter: (spot, percent, barData, index) {
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
                _buildSectionHeader('Appointments', 'Key statistics on the most frequently visited polyclinics', context),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: data.upcomingAppointments.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('No upcoming appointments', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        )
                      : Column(
                          children: data.upcomingAppointments.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final app = entry.value;
                            return _buildAppointmentItem(
                              app.patientName,
                              app.reason,
                              app.time,
                              app.avatar,
                              hasRedDot: idx == 0,
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 32),

                // Doctor's Schedule Section Header
                _buildSectionHeader('Doctor\'s schedule', 'Key statistics on the most frequently visited polyclinics', context),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: data.doctorsSchedule.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('No doctors scheduled', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        )
                      : Column(
                          children: data.doctorsSchedule.map((doc) {
                            return _buildDoctorScheduleItem(
                              doc.name,
                              doc.specialty,
                              doc.status == 'available',
                              doc.nextAvailable != null ? 'Available at\n${doc.nextAvailable}' : '',
                              doc.avatar,
                            );
                          }).toList(),
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
                      _buildSectionHeader('Polyclinics', 'Key statistics on the most frequently\nvisited polyclinics', context, insideCard: true),
                      const SizedBox(height: 32),

                      // Polyclinic vertical bar chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: data.polyclinics.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final poly = entry.value;

                          // Scale height dynamically based on count
                          double rawHeight = 40 + (poly.patientCount.toDouble() * 0.8);
                          double finalHeight = rawHeight > 150 ? 150 : rawHeight;

                          Color barColor = const Color(0xFF007A8A);
                          if (idx == 1) barColor = const Color(0xFF389EA8);
                          if (idx == 2) barColor = const Color(0xFF6AB1B8);
                          if (idx == 3) barColor = const Color(0xFFB2D4D8);

                          return _buildPolyclinicBar(
                            poly.patientCount.toString(),
                            poly.name,
                            finalHeight,
                            barColor,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Bottom Stats text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '+35%',
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.0),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Data increase from the last day.\n',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5, fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text: '120 to ${data.summary.totalDoctors} ',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  const TextSpan(text: 'patients.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text.rich(
                        TextSpan(
                          text: '${data.summary.recoveredCount} ',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                          children: const [
                            TextSpan(
                              text: 'patients have been treated and recovered',
                              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120), // Padding to avoid overlap with bottom navigation bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY(List<PatientChartItem> chart) {
    if (chart.isEmpty) return 100;
    double maxVal = 0;
    for (var item in chart) {
      if (item.underTreatment > maxVal) maxVal = item.underTreatment.toDouble();
      if (item.recovered > maxVal) maxVal = item.recovered.toDouble();
    }
    return maxVal + 20; // safe padding on top
  }

  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String label, {Color? color}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color ?? AppColors.textPrimary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, String periodCode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = periodCode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF161B22) : Colors.transparent, // dark pill
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
                    fontSize: 14,
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
                child: const Icon(Icons.arrow_outward, size: 14, color: AppColors.textPrimary),
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

  Widget _buildSectionHeader(String title, String subtitle, BuildContext context, {bool insideCard = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
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
          child: const Icon(Icons.arrow_outward, size: 16, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildAppointmentItem(String name, String dept, String time, String avatarPath, {bool hasRedDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: avatarPath.startsWith('images/') 
                    ? AssetImage(avatarPath) as ImageProvider
                    : const AssetImage('images/avatars/avatar-1.jpg'),
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
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(dept, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text('Today ', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text(time, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_rounded, size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: const Icon(Icons.phone, size: 20, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorScheduleItem(String name, String dept, bool available, String availableText, String avatarPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: avatarPath.startsWith('images/') 
                ? AssetImage(avatarPath) as ImageProvider
                : const AssetImage('images/avatars/avatar-1.jpg'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(dept, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
              child: const Text('Available', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w500, fontSize: 12)),
            )
          else
            Text(
              availableText,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.textLight, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
            ),
        ],
      ),
    );
  }

  Widget _buildPolyclinicBar(String val, String label, double height, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
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
