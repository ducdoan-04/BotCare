import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'notification_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  // Toggle this to false/empty to see the empty state
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'James Morrison',
      'doctor': 'Dr. Dianne Russell',
      'lastVisit': 'June 12, 2026',
      'avatarId': 1,
    },
    {
      'name': 'Clara Evans',
      'doctor': 'Dr. Mona Flores',
      'lastVisit': 'June 14, 2026',
      'avatarId': 2,
    },
    {
      'name': 'Anthony Ramirez',
      'doctor': 'Dr. Alicia Wexer',
      'lastVisit': 'June 16, 2026',
      'avatarId': 3,
    },
    {
      'name': 'Lillian Hart',
      'doctor': 'Dr. Leslie Alexander',
      'lastVisit': 'June 13, 2026',
      'avatarId': 4,
    },
    {
      'name': 'Daniel Novak',
      'doctor': 'Dr. Jacob Jones',
      'lastVisit': 'June 15, 2026',
      'avatarId': 5,
    },
    {
      'name': 'Johan Diserw',
      'doctor': 'Dr. Dianne Russell',
      'lastVisit': 'June 16, 2026',
      'avatarId': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _patients.isEmpty ? _buildEmptyState() : _buildPopulatedState(),
      ),
    );
  }

  Widget _buildPopulatedState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.search),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(Icons.notifications_none),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(Icons.add,
                      color: AppColors.primary, iconColor: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Date section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildHeaderIcon(Icons.calendar_today_outlined),
                  const SizedBox(width: 12),
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Text(
                '22 December 2026',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Patient Card
          _buildStatsCard(
            context,
            title: 'Total patient',
            value: '800',
            statsPercent: '-2.8%',
            statsDesc: 'Have decreased from yesterday',
            isIncrease: false,
            iconData: Icons.add,
          ),
          const SizedBox(height: 16),

          // Appointments Card
          _buildStatsCard(
            context,
            title: 'Appointments',
            value: '260',
            statsPercent: '3.5%',
            statsDesc: 'Have increased from yesterday',
            isIncrease: true,
            iconData: Icons.arrow_outward,
          ),
          const SizedBox(height: 20),

          // Patient List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _patients.length,
            itemBuilder: (context, index) {
              final patient = _patients[index];
              return _buildPatientCard(
                context,
                patient['name'],
                patient['doctor'],
                patient['lastVisit'],
                patient['avatarId'],
              );
            },
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              _buildHeaderIcon(Icons.notifications_none),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F2F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 60,
                      color: Color(0xFF008394),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'No patient added yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your patients will be displayed here once you add them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      // Navigate to add patient (placeholder)
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF008394)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Color(0xFF008394), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'New Patient',
                            style: TextStyle(
                              color: Color(0xFF008394),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
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
      child:
          Icon(iconData, color: iconColor ?? AppColors.textPrimary, size: 24),
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required String title,
    required String value,
    required String statsPercent,
    required String statsDesc,
    required bool isIncrease,
    required IconData iconData,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                child: Icon(iconData, size: 20, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      statsPercent,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isIncrease
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        statsDesc,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, String name, String doctor,
      String lastVisit, int imageId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage('images/avatars-patient/avatar-$imageId.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  doctor,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Visit',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                          lastVisit,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildActionIcon(
                            Icons.edit_outlined, AppColors.textPrimary),
                        const SizedBox(width: 8),
                        _buildActionIcon(Icons.delete_outline, AppColors.error),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
