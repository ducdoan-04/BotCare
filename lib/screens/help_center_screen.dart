import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'user_guide_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpCard(
                      context,
                      icon: Icons.person_outline,
                      title: 'User guide',
                      subtitle: 'Step-by-step instructions for using key features of the dashboard, including viewing doctor schedules.',
                      actionText: 'Read More',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const UserGuideScreen()));
                      },
                    ),
                    _buildHelpCard(
                      context,
                      icon: Icons.question_answer_outlined,
                      title: 'Frequently asked questions (FAQs)',
                      subtitle: 'Provides answers to common healthcare-related questions such as how to schedule an appointment.',
                      actionText: 'Read More',
                      onTap: () {},
                    ),
                    _buildHelpCard(
                      context,
                      icon: Icons.build_outlined,
                      title: 'Troubleshooting',
                      subtitle: 'Solutions to common issues, such as errors in appointment booking, missing patient records or logi...',
                      actionText: 'Read More',
                      onTap: () {},
                    ),
                    _buildHelpCard(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Support contact',
                      subtitle: 'Information on how to reach the support team via chat, email or phone.',
                      actionText: 'Read More',
                      onTap: () {},
                    ),
                    _buildHelpCard(
                      context,
                      icon: Icons.security_outlined,
                      title: 'Security & privacy',
                      subtitle: 'Explains on of how patient data is protected, privacy policies, and compliance with healthcare st...',
                      actionText: 'Read More',
                      onTap: () {},
                    ),
                    _buildHelpCard(
                      context,
                      icon: Icons.feedback_outlined,
                      title: 'Feedback & suggestions',
                      subtitle: 'A section where users can provide input on current features and suggest improvements.',
                      actionText: 'Read More',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Can't find what you're looking for?",
                      style: TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    _buildContactCard(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Call us',
                      subtitle: "Need assistance? Call us now. We're here to assist y...",
                      actionText: 'Call Now',
                    ),
                    _buildContactCard(
                      context,
                      icon: Icons.chat_bubble_outline,
                      title: 'Chat us',
                      subtitle: "Need quick answers? We're here to help in real time.",
                      actionText: 'Chat Now',
                    ),
                    _buildContactCard(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Mail us',
                      subtitle: "Have questions? Reach out us via email, fast respo...",
                      actionText: 'Mail Now',
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
            'Help center',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required String actionText, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Light grey background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF007A8A)), // Primary Teal
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required String actionText}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 12),
          Text(
            actionText,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF007A8A)),
          ),
        ],
      ),
    );
  }
}
