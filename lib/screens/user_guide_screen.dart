import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _buildGuideSection(
                      'Dashboard Overview',
                      [
                        'View operational summaries, including doctor schedules, patient room availability, and daily reports.',
                        'Use the navigation menu to switch between administrative modules.'
                      ],
                    ),
                    _buildGuideSection(
                      'Doctor Management',
                      [
                        'View and update doctor profiles, specialties, and availability.',
                        'Assign doctors to patient cases and appointment slots.',
                        'Monitor doctor activity logs to track consultations and workload.'
                      ],
                    ),
                    _buildGuideSection(
                      'Patient Management',
                      [
                        'Maintain comprehensive patient records, including medical history and treatment plans.',
                        'Secure access levels to ensure privacy compliance for sensitive data.'
                      ],
                    ),
                    _buildGuideSection(
                      'Appointment Management',
                      [
                        'Schedule, reschedule, and cancel patient appointments.',
                        'Automate appointment reminders for both doctors and patients.',
                        'Track consultation types, whether in-person or telemedicine.'
                      ],
                    ),
                    _buildGuideSection(
                      'Message Management',
                      [
                        'Communicate with patients via message templates for appointment confirmations.',
                        'Monitor communication logs for patient interactions and follow-ups.'
                      ],
                    ),
                    _buildGuideSection(
                      'Help Center',
                      [
                        'Access FAQs to find quick answers about system features.',
                        'Browse Troubleshooting guides for technical issues.',
                        'Reach out to the Support Team for assistance with the platform.'
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
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
              child: const Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'User guide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, List<String> bulletPoints) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...bulletPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0, right: 12.0),
                      child: Icon(
                        Icons.circle,
                        size: 4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
