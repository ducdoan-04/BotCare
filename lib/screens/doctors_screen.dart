import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'notification_screen.dart';
import 'doctor_detail_screen.dart';
import 'update_doctor_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final List<Map<String, dynamic>> _doctors = [
    {'name': 'Dr. Dianne Russell', 'specialty': 'General Practitioner', 'time': '9AM - 2PM', 'avatar': 1, 'isAvailable': true},
    {'name': 'Dr. Jacob Jones', 'specialty': 'Cardiology', 'time': '9AM - 2PM', 'avatar': 2, 'isAvailable': true},
    {'name': 'Dr. Mona Flores', 'specialty': 'Dermatology', 'time': '9AM - 2PM', 'avatar': 3, 'isAvailable': true},
    {'name': 'Dr. Alicia Wexer', 'specialty': 'Dermatology', 'time': '9AM - 2PM', 'avatar': 4, 'isAvailable': true},
    {'name': 'Dr. Leslie Alexander', 'specialty': 'General Practitioner', 'time': '2PM - 7PM', 'avatar': 5, 'isAvailable': false},
    {'name': 'Dr. Kathryn Murphy', 'specialty': 'Cardiology', 'time': '9AM - 2PM', 'avatar': 6, 'isAvailable': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Doctors',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationScreen()),
                        ),
                        child: _buildHeaderIcon(Icons.notifications_none, hasNotification: true),
                      ),
                      const SizedBox(width: 12),
                      _buildAddIcon(),
                    ],
                  ),
                ],
              ),
            ),
            
            // --- CATEGORIES ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildCategoryChip('All', true),
                  const SizedBox(width: 12),
                  _buildCategoryChip('General Practitioners', false),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Cardiology', false),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Dermatology', false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- DOCTORS LIST ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  return _buildDoctorCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasNotification = false}) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
        if (hasNotification)
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFF04438),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF008394), // Specific Teal from design
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 24),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? const Color(0xFF161B22) : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, int index) {
    if (index >= _doctors.length) return const SizedBox.shrink();

    final doctor = _doctors[index];
    final bool isAvailable = doctor['isAvailable'] as bool;
    final int avatarIndex = doctor['avatar'] as int;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDetailScreen(doctor: doctor, index: index),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 90,
                height: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('images/avatars-doctor/avatar-$avatarIndex.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: isAvailable 
                        ? null 
                        : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isAvailable ? const Color(0xFF05B93E) : AppColors.textSecondary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Not Available',
                    style: TextStyle(
                      color: isAvailable ? const Color(0xFF05B93E) : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor['specialty']!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor['time']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => UpdateDoctorScreen(
                            doctor: doctor,
                            index: index,
                          ),
                        );
                      },
                      child: _buildActionIcon(Icons.edit_outlined),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(context, doctor['name']!, index),
                      child: _buildActionIcon(Icons.delete_outline, isDelete: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildActionIcon(IconData icon, {bool isDelete = false}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: isDelete ? const Color(0xFFF04438) : AppColors.textPrimary,
        size: 18,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String doctorName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3F2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD92D20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 36),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Delete',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                    children: [
                      const TextSpan(text: 'Are you sure you want to delete\n'),
                      TextSpan(text: doctorName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      const TextSpan(text: '?'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF008394)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF008394), fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _doctors.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF008394),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Yes, Delete',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
