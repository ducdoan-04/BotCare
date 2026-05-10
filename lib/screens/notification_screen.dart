import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              ),
            ),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _buildNotificationItem(
                        context: context,
                        title: 'Message from Lucy',
                        time: '32 minutes ago',
                        icon: Icons.email,
                        unread: true,
                        detailWidgetBuilder: () => const NotificationDetailScreen(
                          title: 'Message from Lucy',
                          time: '32 minutes ago',
                          appBarTitle: 'Message',
                          greeting: 'Dear Nola,',
                          bodyText: 'Can you please forward the patient reports of Jacob Jones from yesterday\'s General checkup? Dr. Arthur wants to review them before his next appointment.',
                          closingText: 'Thank you,\nLucy (Assistant)',
                        ),
                      ),
                      _buildDivider(),
                      _buildNotificationItem(
                        context: context,
                        title: 'New patients added',
                        time: '1 hours ago',
                        icon: Icons.person_add,
                        unread: false,
                        detailWidgetBuilder: () => const NotificationDetailScreen(
                          title: 'New patients added',
                          time: '1 hours ago',
                          appBarTitle: 'System Alert',
                          bodyText: 'A batch of new patients has been registered through the online booking system and assigned to your reception desk queue. Please verify their insurance details.',
                          details: {
                            'Patient Count': '5 New registrations',
                            'Assigned Desk': 'Reception Desk 1',
                          },
                          footerText: 'Check the Patient Directory page to complete verification steps.',
                        ),
                      ),
                      _buildDivider(),
                      _buildNotificationItem(
                        context: context,
                        title: 'Your leave is approved',
                        time: '2 hours ago',
                        icon: Icons.check_box,
                        unread: true,
                        detailWidgetBuilder: () => const NotificationDetailScreen(
                          title: 'Your leave is approved',
                          time: '2 hours ago',
                          appBarTitle: 'Leave',
                          greeting: 'Hi Nola,',
                          bodyText: 'Your leave request for personal time off has been approved by the management team.',
                          details: {
                            'Type': 'Personal Leave',
                            'Date Range': 'June 21 - June 23, 2025',
                            'Total Days': '3 Working Days',
                          },
                          footerText: 'Please ensure that any tasks or responsibilities are delegated before your time off. If there\'s anything urgent, the admin team will contact your replacement.',
                          closingText: 'Enjoy your well-deserved break! 🌿',
                        ),
                      ),
                      _buildDivider(),
                      _buildNotificationItem(
                        context: context,
                        title: 'Jacob recob file.pdf',
                        time: '4 hours ago',
                        icon: Icons.insert_drive_file,
                        unread: false,
                        detailWidgetBuilder: () => const NotificationDetailScreen(
                          title: 'Jacob recob file.pdf',
                          time: '4 hours ago',
                          appBarTitle: 'File Shared',
                          bodyText: 'Jacob Jones has uploaded a medical document file "patient_recob_file.pdf". You can now access and view it in the document section.',
                          details: {
                            'File Name': 'patient_recob_file.pdf',
                            'Size': '1.2 MB',
                            'Format': 'PDF Document',
                            'Uploader': 'Jacob Jones',
                          },
                        ),
                      ),
                      _buildDivider(),
                      _buildNotificationItem(
                        context: context,
                        title: 'Message from Jacob',
                        time: '1 day ago',
                        icon: Icons.email,
                        unread: false,
                        detailWidgetBuilder: () => const NotificationDetailScreen(
                          title: 'Message from Jacob',
                          time: '1 day ago',
                          appBarTitle: 'Message',
                          greeting: 'Hello Admin,',
                          bodyText: 'I would like to reschedule my appointment from 09:40 AM to 11:00 AM if possible. Please let me know if Dr. Arthur is available at that time.',
                          closingText: 'Regards,\nJacob Jones',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Mark all as read',
                  style: TextStyle(
                    color: Color(0xFF007A8A), // Teal
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.border, indent: 84, endIndent: 20); // Indent to clear icon
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required String title,
    required String time,
    required IconData icon,
    required bool unread,
    required Widget Function() detailWidgetBuilder,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => detailWidgetBuilder()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (unread)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFF04438),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
