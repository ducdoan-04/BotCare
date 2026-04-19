import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String subtitle;
  final String avatarUrl;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF6F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warning Banner
                    _buildWarningBanner(),
                    const SizedBox(height: 12),

                    // Info Card
                    _buildInfoCard(),
                    const SizedBox(height: 12),

                    // Medical History Card
                    _buildMedicalHistoryCard(),
                    const SizedBox(height: 16),
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
      color: const Color(0xFFEEF6F7),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 1),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
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
            'Detail information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEEFEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFD53411),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'i',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Warnings on drug interactions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Warfarin + Aspirin: Increased bleeding risk.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final List<Map<String, String>> rows = [
      {'label': 'ID', 'value': '0123453'},
      {'label': 'Date of Birth', 'value': '12/4/17'},
      {'label': 'Contact', 'value': '(229) 555-0109'},
      {'label': 'Appointment', 'value': '8/15/17  •  5.23 PM'},
      {'label': 'Medications', 'value': 'Hydrocortisone cream'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: rows.map((row) {
          final isLast = row == rows.last;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        row['label']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary.withOpacity(0.45),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row['value']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMedicalHistoryCard() {
    final List<Map<String, dynamic>> history = [
      {
        'title': 'Routine check up',
        'date': '30 Nov 2024  •  5.23 PM',
        'isFirst': true
      },
      {
        'title': 'Check lab',
        'date': '23 Nov 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Control of lab results',
        'date': '18 Nov 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Drug control',
        'date': '11 Nov 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Routine check up',
        'date': '4 Nov 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Check lab',
        'date': '27 Oct 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Control of lab results',
        'date': '27 Oct 2024  •  5.23 PM',
        'isFirst': false
      },
      {
        'title': 'Routine check up',
        'date': '15 Oct 2024  •  5.23 PM',
        'isFirst': false
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical history',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...history.asMap().entries.map((entry) {
            final item = entry.value;
            final isFirst = item['isFirst'] as bool;
            final isLast = entry.key == history.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Timeline column
                  SizedBox(
                    width: 20,
                    child: Column(
                      children: [
                        // Dot
                        Container(
                          width: isFirst ? 14 : 10,
                          height: isFirst ? 14 : 10,
                          margin: EdgeInsets.only(top: isFirst ? 3 : 5),
                          decoration: BoxDecoration(
                            color: isFirst
                                ? const Color(0xFF008394)
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Vertical line (not on last item)
                        if (!isLast)
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 2,
                                color: isFirst
                                    ? const Color(0xFF008394)
                                    : Colors.grey.shade200,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['date'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
