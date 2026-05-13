import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_colors.dart';
import '../repositories/staff_repository.dart';
import '../models/staff_model.dart';
import 'notification_screen.dart';
import 'staff_profile_screen.dart';
import 'staff_form_screen.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final _repository = StaffRepository();
  final _searchController = TextEditingController();

  List<Staff> _staff = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedRole = 'All';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchStaff() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final staffList = await _repository.fetchStaff(role: _selectedRole);
      setState(() {
        _staff = staffList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _onRoleSelected(String role) {
    if (_selectedRole == role) return;
    setState(() {
      _selectedRole = role;
    });
    _fetchStaff();
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
                    'Staff',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                              _fetchStaff();
                            }
                          });
                        },
                        child: _buildHeaderIcon(_isSearching ? Icons.close : Icons.search),
                      ),
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
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const StaffFormScreen(),
                          );
                          if (result == true) _fetchStaff();
                        },
                        child: _buildAddIcon(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _fetchStaff(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      hintText: 'Search staff name...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
              ),

            // --- FILTER ROLES ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildCategoryChip('All'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Nurse'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Pharmacist'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Receptionist'),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Accountant'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: _buildStaffBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF008394)),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 60),
            const SizedBox(height: 16),
            Text(_errorMessage),
            ElevatedButton(onPressed: _fetchStaff, child: const Text('Retry'))
          ],
        ),
      );
    }

    if (_staff.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: _staff.length,
      itemBuilder: (context, index) => _buildStaffCard(context, _staff[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: Color(0xFFE6F2F3), shape: BoxShape.circle),
            child: const Icon(Icons.people_outline, color: Color(0xFF008394), size: 40),
          ),
          const SizedBox(height: 24),
          const Text('No staff members yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Staff you add will be shown here to help\nmanage clinic operations.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const StaffFormScreen(),
              );
              if (result == true) _fetchStaff();
            },
            icon: const Icon(Icons.add),
            label: const Text('New Staff'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF008394),
              side: const BorderSide(color: Color(0xFF008394)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasNotification = false}) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border)),
      child: Icon(icon, color: AppColors.textPrimary, size: 22),
    );
  }

  Widget _buildAddIcon() {
    return Container(
      width: 44, height: 44,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF008394)),
      child: const Icon(Icons.add, color: Colors.white, size: 24),
    );
  }

  Widget _buildCategoryChip(String label) {
    final bool isSelected = _selectedRole == label;
    return GestureDetector(
      onTap: () => _onRoleSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? const Color(0xFF161B22) : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, Staff staff) {
    final bool isAvailable = staff.status.toLowerCase() == 'available';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StaffProfileScreen(staff: staff)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 90, height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: staff.profileImageUrl != null && staff.profileImageUrl!.startsWith('uploads/')
                        ? NetworkImage('http://192.168.1.8:3000/${staff.profileImageUrl}') as ImageProvider
                        : AssetImage(staff.profileImageUrl ?? 'images/staff/avatar-1.jpg'),
                      fit: BoxFit.cover,
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
                      border: Border.all(color: isAvailable ? const Color(0xFF05B93E) : Colors.grey),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Away',
                      style: TextStyle(color: isAvailable ? const Color(0xFF05B93E) : Colors.grey, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(staff.role, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Shift', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text(staff.shift ?? 'N/A', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => StaffFormScreen(existingStaff: staff),
                          );
                          if (result == true) _fetchStaff();
                        },
                        child: _buildActionIcon(Icons.edit_outlined),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(context, staff),
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

  void _showDeleteDialog(BuildContext context, Staff staff) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Staff'),
        content: Text('Are you sure you want to delete ${staff.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _repository.deleteStaff(staff.id);
              if (success) _fetchStaff();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {bool isDelete = false}) {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border)),
      child: Icon(icon, color: isDelete ? Colors.red : Colors.black, size: 18),
    );
  }
}
