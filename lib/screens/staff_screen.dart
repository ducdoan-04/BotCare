import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'notification_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  // Set to empty list [] to test empty state
  final List<Map<String, dynamic>> _staff = [
    {
      'name': 'Kathryn Murphy',
      'role': 'Receptionist',
      'shift': '9AM - 2PM',
      'available': true,
      'avatarId': 1,
    },
    {
      'name': 'Devon Lane',
      'role': 'Pharmacist',
      'shift': '9AM - 2PM',
      'available': true,
      'avatarId': 2,
    },
    {
      'name': 'Marvin McKinney',
      'role': 'Receptionist',
      'shift': '9AM - 2PM',
      'available': true,
      'avatarId': 3,
    },
    {
      'name': 'Ronald Richards',
      'role': 'Accountant',
      'shift': '9AM - 2PM',
      'available': true,
      'avatarId': 4,
    },
    {
      'name': 'Robert Fox',
      'role': 'Receptionist',
      'shift': '2PM - 7PM',
      'available': false,
      'avatarId': 5,
    },
    {
      'name': 'Jenny Wilson',
      'role': 'Pharmacist',
      'shift': '9AM - 2PM',
      'available': true,
      'avatarId': 6,
    },
    {
      'name': 'Courtney Henry',
      'role': 'Pharmacist',
      'shift': '2PM - 7PM',
      'available': false,
      'avatarId': 7,
    },
  ];

  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _staff.isEmpty ? _buildEmptyState() : _buildPopulatedState(),
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
                'Staff',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                child: _buildHeaderIcon(Icons.notifications_none),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F2F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups,
                      size: 40,
                      color: Color(0xFF008394),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'No staff members yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Staff you add will be shown here to help\nmanage clinic operations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      // Handle Add new staff
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
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
                            'New Staff',
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

  Widget _buildPopulatedState() {
    final filteredStaff = _selectedCategory == 'All'
        ? _staff
        : _staff.where((s) => s['role'] == _selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Staff',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.search),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: _buildHeaderIcon(Icons.notifications_none),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      // Navigate to add new staff
                    },
                    child: _buildHeaderIcon(Icons.add,
                        color: AppColors.primary, iconColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Categories Header
        _buildCategoryList(),

        const SizedBox(height: 16),

        // Staff List
        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            itemCount: filteredStaff.length,
            itemBuilder: (context, index) {
              return _buildStaffCard(filteredStaff[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      'All',
      'Nurse',
      'Pharmacist',
      'Receptionist',
      'Accountant'
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.textPrimary
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + Badge
          SizedBox(
            width: 90,
            height: 110,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 90,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(
                            'images/avatars-staff/avatar-${staff['avatarId']}.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: staff['available']
                            ? null
                            : const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: staff['available']
                            ? AppColors.success
                            : const Color(0xFF9CA3AF),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      staff['available'] ? 'Available' : 'Not Available',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: staff['available']
                            ? AppColors.success
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  staff['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  staff['role'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shift',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Text(
                          staff['shift'] as String,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
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

  Widget _buildActionIcon(IconData icon, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
