import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'basic_info_sheet.dart';
import 'document_sheet.dart';

class AppointmentDetailsSheet extends StatelessWidget {
  const AppointmentDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 20, top: 24, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Appointment details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.border),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Profile Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage(
                                'images/avatars-patient/avatar-1.jpg'), // placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Johan Wilson',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Poli Cardiology',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const BasicInfoSheet(),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F4F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.info_outline,
                              size: 18, color: AppColors.textPrimary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const DocumentSheet(),
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF2F4F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.description_outlined,
                              size: 18, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),

                // Statistics
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('9', 'Total visits'),
                      _buildStatColumn('4', 'Visited'),
                      _buildStatColumn('5', 'Remaining'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Container(height: 1, color: AppColors.border),
                const SizedBox(height: 10),

                // Timeline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildTimelineItem(
                        isFirst: true,
                        isLast: false,
                        isToday: false,
                        date: '14 Dec 24  •  08.30 AM',
                        typeLabel: 'Treatment',
                        title: 'Lifestyle & vitals monitoring',
                        doctor: 'Dr. David Cooper',
                        actionButtons: Row(
                          children: [
                            _buildOutlinedButton(
                                icon: Icons.note_alt_outlined,
                                label: 'Note',
                                color: AppColors.primary),
                          ],
                        ),
                      ),
                      _buildTimelineItem(
                        isFirst: false,
                        isLast: false,
                        isToday: true,
                        date: '21 Dec 24  •  08.30 AM',
                        typeLabel: 'Today Treatment',
                        title: 'Heart health consultation',
                        doctor: 'Dr. David Cooper',
                        actionButtons: Row(
                          children: [
                            _buildFilledButton(
                                icon: Icons.check,
                                label: 'Confirm',
                                color: AppColors.primary),
                            const SizedBox(width: 10),
                            _buildOutlinedButton(
                                icon: Icons.calendar_today_outlined,
                                label: 'Reschedule',
                                color: Colors.deepOrange),
                          ],
                        ),
                      ),
                      _buildTimelineItem(
                        isFirst: false,
                        isLast: false,
                        isToday: false,
                        date: '24 Dec 24  •  08.30 AM',
                        typeLabel: 'Next Treatment',
                        title: 'Heart health consultation',
                        doctor: 'Dr. David Cooper',
                        actionButtons: Row(
                          children: [
                            _buildOutlinedButton(
                                icon: Icons.calendar_today_outlined,
                                label: 'Reschedule',
                                color: Colors.deepOrange),
                          ],
                        ),
                      ),
                      _buildTimelineItem(
                        isFirst: false,
                        isLast: true,
                        isToday: false,
                        date: '28 Dec 24  •  08.30 AM',
                        typeLabel: 'Next Treatment',
                        title: 'Heart health consultation',
                        doctor: 'Dr. David Cooper',
                        actionButtons: Row(
                          children: [
                            _buildOutlinedButton(
                                icon: Icons.calendar_today_outlined,
                                label: 'Reschedule',
                                color: Colors.deepOrange),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required bool isFirst,
    required bool isLast,
    required bool isToday,
    required String date,
    required String typeLabel,
    required String title,
    required String doctor,
    required Widget actionButtons,
  }) {
    Color nodeColor = isToday ? AppColors.primary : const Color(0xFFD0D5DD);
    Color lineColor = const Color(0xFFE5E7EB); // Darker line than before

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator with CustomPaint
          SizedBox(
            width: 10, // Wider to center paint properly
            child: CustomPaint(
              painter: _TimelinePainter(
                isFirst: isFirst,
                isLast: isLast,
                nodeColor: nodeColor,
                lineColor: lineColor,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Content
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 14, bottom: 16), //giam khoang cach
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        typeLabel,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary),
                      ),
                      const Text(
                        'Doctor',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          doctor,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  actionButtons,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledButton(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color nodeColor;
  final Color lineColor;

  _TimelinePainter({
    required this.isFirst,
    required this.isLast,
    required this.nodeColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    var paintNode = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double nodeY = 22; // Aligns with the middle of the 'Date' text

    // Draw top line
    if (!isFirst) {
      canvas.drawLine(Offset(centerX, 0), Offset(centerX, nodeY), paintLine);
    }

    // Draw bottom line
    if (!isLast) {
      canvas.drawLine(
          Offset(centerX, nodeY), Offset(centerX, size.height), paintLine);
    }

    // Draw filled node
    canvas.drawCircle(Offset(centerX, nodeY), 4.5, paintNode);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
