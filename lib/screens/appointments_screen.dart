import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointments',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(Icons.notifications_none),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(Icons.add, color: AppColors.primary, iconColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            
            // Summary Info Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildSummaryCard(context, '260', 'Total'),
                  const SizedBox(width: 12),
                  _buildSummaryCard(context, '140', 'Completed'),
                  const SizedBox(width: 12),
                  _buildSummaryCard(context, '400', 'Canceled'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Main Content Area inside a white-ish container
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Date Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildHeaderIcon(Icons.calendar_today_outlined, color: AppColors.background),
                              const SizedBox(width: 12),
                              Text('Today', style: Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                          Text('22 December 2026', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    
                    // Appointment Cards
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        children: [
                          _buildAppointmentCard(
                            context,
                            time: '09.40 AM',
                            type: 'Routine check up',
                            patient: 'Jacob Jones',
                            doctor: 'Dr. Courtney Henry',
                            status: 'Confirm',
                          ),
                          _buildAppointmentCard(
                            context,
                            time: '09.40 AM',
                            type: 'Dermatology consultation',
                            patient: 'Jenny Wilson',
                            doctor: 'Dr. Jane Cooper',
                            status: 'Pending',
                          ),
                          _buildAppointmentCard(
                            context,
                            time: '09.40 AM',
                            type: 'Routine check up',
                            patient: 'Albert Flores',
                            doctor: 'Dr. Raj Patel',
                            status: 'Canceled',
                          ),
                          _buildAppointmentCard(
                            context,
                            time: '10.40 AM',
                            type: 'Physical therapy',
                            patient: 'Esther Howard',
                            doctor: 'Dr. Brooklyn S',
                            status: 'Confirm',
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData iconData, {Color? color, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.white,
        border: color == null ? Border.all(color: AppColors.border) : null,
      ),
      child: Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 24),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String value, String label) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context, {
    required String time,
    required String type,
    required String patient,
    required String doctor,
    required String status,
  }) {
    Color statusColor;
    Color statusBgColor;
    Color cardBgColor = Colors.white;

    if (status == 'Confirm') {
      statusColor = AppColors.success;
      statusBgColor = AppColors.success.withOpacity(0.1);
      cardBgColor = AppColors.surface;
    } else if (status == 'Pending') {
      statusColor = AppColors.textSecondary;
      statusBgColor = AppColors.border;
      cardBgColor = AppColors.primaryLight; 
    } else {
      statusColor = AppColors.error;
      statusBgColor = AppColors.errorLight;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: cardBgColor == Colors.white 
            ? Border.all(color: AppColors.border) 
            : Border.all(color: AppColors.primary.withOpacity(0.3)), // Subtle border for non-white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            type,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                patient,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.textLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Text(
                doctor,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
