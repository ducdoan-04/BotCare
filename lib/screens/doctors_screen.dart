import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'notification_screen.dart';
import 'doctor_detail_screen.dart';
import 'update_doctor_screen.dart';
import 'add_doctor_screen.dart';
import '../services/doctor_service.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final DoctorService _doctorService = DoctorService();

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    setState(() => _isLoading = true);
    final data = await _doctorService.getAllDoctors();
    if (mounted) {
      setState(() {
        _doctors = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredDoctors {
    if (_selectedCategory == 'All') return _doctors;
    return _doctors
        .where((d) =>
            (d['specialty'] ?? '').toString().toLowerCase().contains(
                  _selectedCategory.toLowerCase(),
                ) ||
            (d['department'] ?? '').toString().toLowerCase().contains(
                  _selectedCategory.toLowerCase(),
                ))
        .toList();
  }

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
                      GestureDetector(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddDoctorScreen(),
                          );
                          // Re-fetch after modal closes (whether saved or cancelled)
                          _fetchDoctors();
                        },
                        child: _buildAddIcon(),
                      ),
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
                  _buildCategoryChip('All'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('General Practitioners'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Cardiology'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Dermatology'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- DOCTORS LIST ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF008394)),
                    )
                  : _filteredDoctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F2F3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: Color(0xFF008394),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No doctors added yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Doctors will appear here once you\'ve\nadded them to the system.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const AddDoctorScreen(),
                                  );
                                  _fetchDoctors();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                                        'New Doctor',
                                        style: TextStyle(
                                          color: Color(0xFF008394),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchDoctors,
                          color: const Color(0xFF008394),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemCount: _filteredDoctors.length,
                            itemBuilder: (context, index) {
                              return _buildDoctorCard(context, _filteredDoctors[index]);
                            },
                          ),
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
        color: Color(0xFF008394),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 24),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
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
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doctor) {
    final bool isAvailable =
        doctor['availability']?.toString().toLowerCase().contains('available') ?? true;
    final String avatarStr = doctor['avatar'] ?? '1';
    final int avatarIndex = (int.tryParse(avatarStr) ?? 1).clamp(1, 6);

    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorDetailScreen(doctor: doctor, index: avatarIndex - 1),
          ),
        );
        _fetchDoctors();
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
            // Avatar with availability badge
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
                      image: AssetImage('assets/images/avatars-doctor/avatar-$avatarIndex.jpg'),
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
                        color: isAvailable
                            ? const Color(0xFF05B93E)
                            : AppColors.textSecondary.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Not Available',
                      style: TextStyle(
                        color: isAvailable
                            ? const Color(0xFF05B93E)
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),

            // Doctor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor['specialty'] ?? '',
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
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor['workHours'] ?? '9AM - 5PM',
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
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => UpdateDoctorScreen(
                              doctor: doctor,
                              index: avatarIndex - 1,
                            ),
                          );
                          _fetchDoctors();
                        },
                        child: _buildActionIcon(Icons.edit_outlined),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(context, doctor),
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
            color: Colors.black.withOpacity(0.06),
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

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> doctor) {
    final doctorId = doctor['_id']?.toString();
    final doctorName = doctor['name'] ?? 'this doctor';

    showDialog(
      context: context,
      builder: (dialogCtx) {
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
                  'Delete Doctor',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete $doctorName?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(dialogCtx),
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
                        onTap: () async {
                          Navigator.pop(dialogCtx);
                          if (doctorId != null) {
                            final success = await _doctorService.deleteDoctor(doctorId);
                            if (success) {
                              _fetchDoctors();
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to delete doctor')),
                              );
                            }
                          }
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
