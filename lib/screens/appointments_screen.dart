import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'add_appointment_screen.dart';
import 'appointment_details_sheet.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool _isEmpty = false;

  void _toggleEmptyState() {
    setState(() {
      _isEmpty = !_isEmpty;
    });
  }

  void _showNewAppointmentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAppointmentScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FIXED HEADER PART ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Appointments',
                      style: Theme.of(context).textTheme.displayLarge,
                      // fontSize: 18,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search),
                      const SizedBox(width: 12),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _buildHeaderIcon(Icons.notifications_none),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF04438),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showNewAppointmentSheet,
                        child: _buildHeaderIcon(Icons.add,
                            color: AppColors.primary, iconColor: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Summary Info Cards (Also Fixed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                      child:
                          _buildSummaryCard(_isEmpty ? '0' : '260', 'Total')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildSummaryCard(
                          _isEmpty ? '0' : '140', 'Completed')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildSummaryCard(
                          _isEmpty ? '0' : '400', 'Canceled')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SCROLLABLE CONTENT PART ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: _isEmpty ? _buildEmptyState() : _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo/logo-v1.png',
              height: 120, color: AppColors.border),
          const SizedBox(height: 24),
          Text('You don\'t have an appointment yet',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text('Click the + button to add a new appointment',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        const SizedBox(height: 32),
        // Date Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildHeaderIcon(Icons.calendar_today_outlined),
                const SizedBox(width: 12),
                const Text('Today',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
            const Text('22 Desember 2024',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 20),

        // Doctors List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDoctorItem('Dr. Johan Henry', 'General Practitioners', 1),
              const SizedBox(width: 24),
              _buildDoctorItem('Dr. David', 'Cardiolog', 2),
              const SizedBox(width: 24),
              _buildDoctorItem('Dr. Sarah', 'Dermatology', 3),
              const SizedBox(width: 24),
              _buildDoctorItem('Dr. Henry', 'Pediatrics', 4),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Radio Buttons
        Row(
          children: [
            _buildRadioOption('Routine check-up', false),
            const SizedBox(width: 24),
            _buildRadioOption('Urgent visit', true),
          ],
        ),
        const SizedBox(height: 24),

        // Appointment Cards
        _buildModernAppointmentCard(
          time: '09.40 AM',
          type: 'Routine check up',
          patient: 'Jacob Jones',
          doctor: 'Dr. Courtney Henry',
          status: 'Confirm',
          cardStyle: 'white',
        ),
        _buildModernAppointmentCard(
          time: '09.40 AM',
          type: 'Dermatology consultation',
          patient: 'Jenny Wilson',
          doctor: 'Dr. Jane Cooper',
          status: 'Pending',
          cardStyle: 'blue',
        ),
        _buildModernAppointmentCard(
          time: '09.40 AM',
          type: 'Routine check up',
          patient: 'Albert Flores',
          doctor: 'Dr. Raj Patel',
          status: 'Canceled',
          cardStyle: 'white',
        ),
        _buildModernAppointmentCard(
          time: '10.40 AM',
          type: 'Physical therapy',
          patient: 'Esther Howard',
          doctor: 'Dr. Brooklyn S',
          status: 'Confirm',
          cardStyle: 'blue',
        ),
        _buildModernAppointmentCard(
          time: '10.40 AM',
          type: 'Allergy test',
          patient: 'Annette Black',
          doctor: 'Dr. Theresa Webb',
          status: 'Canceled',
          cardStyle: 'white',
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDoctorItem(String name, String type, int avatarId) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image:
                      AssetImage('images/avatars-doctor/avatar-$avatarId.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(type,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String text, bool isTeal) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isTeal ? const Color(0xFF6AB1B8) : const Color(0xFFD1D5DB),
              width: 1.5,
            ),
          ),
          child: isTeal
              ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6AB1B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData iconData, {Color? color, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.white,
        border:
            color == null ? Border.all(color: const Color(0xFFF3F4F6)) : null,
      ),
      child:
          Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 22),
    );
  }

  Widget _buildSummaryCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppointmentCard({
    required String time,
    required String type,
    required String patient,
    required String doctor,
    required String status,
    required String cardStyle,
  }) {
    Color statusColor;
    Color statusBgColor;
    Color statusBorderColor;

    if (status == 'Confirm') {
      statusColor = AppColors.success;
      statusBgColor = Colors.transparent;
      statusBorderColor = AppColors.success.withOpacity(0.5);
    } else if (status == 'Pending') {
      statusColor = AppColors.textSecondary;
      statusBgColor = const Color(0xFFE5E7EB);
      statusBorderColor = const Color(0xFFD1D5DB);
    } else {
      // Canceled
      statusColor = const Color(0xFFF04438);
      statusBgColor = Colors.transparent;
      statusBorderColor = const Color(0xFFF04438).withOpacity(0.5);
    }

    Color cardBgColor =
        cardStyle == 'white' ? Colors.white : const Color(0xFFE2F0F2);
    Color cardBorderColor =
        cardStyle == 'white' ? const Color(0xFFF3F4F6) : AppColors.primary;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AppointmentDetailsSheet(),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: cardBorderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: statusBorderColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              type,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  patient,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.textLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  doctor,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
