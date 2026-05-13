import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/staff_model.dart';
import '../repositories/staff_repository.dart';
import '../widgets/attendance_heatmap.dart';
import 'staff_form_screen.dart';

class StaffProfileScreen extends StatefulWidget {
  final Staff staff;

  const StaffProfileScreen({super.key, required this.staff});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  final _repository = StaffRepository();
  late Staff _staff;
  int _activeTab = 1; // Default to Summary as per screenshot

  StaffSummary? _summary;
  StaffTimetable? _timetable;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _staff = widget.staff;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final summaryData = await _repository.fetchStaffSummary(_staff.id);
      final timetableData = await _repository.fetchStaffTimetable(_staff.id);
      setState(() {
        _summary = summaryData;
        _timetable = timetableData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 24),
                    _buildTabContent(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Staff profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final bool isAvailable = _staff.status.toLowerCase() == 'available';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Row(
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: _staff.profileImageUrl != null && _staff.profileImageUrl!.startsWith('uploads/')
                  ? NetworkImage('http://192.168.1.8:3000/${_staff.profileImageUrl}') as ImageProvider
                  : AssetImage(_staff.profileImageUrl ?? 'images/staff/avatar-1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                const SizedBox(height: 8),
                Text(_staff.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${_staff.role} • 30 yrs old', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => StaffFormScreen(existingStaff: _staff),
                          );
                          if (result == true) {
                            // Refresh logic
                            final updated = await _repository.fetchStaffDetail(_staff.id);
                            if (updated != null) {
                              setState(() => _staff = updated);
                              _fetchData();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildIconBtn(Icons.phone_outlined),
                    const SizedBox(width: 8),
                    _buildIconBtn(Icons.chat_bubble_outline),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border)),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTabItem(0, 'Timetable'),
        const SizedBox(width: 12),
        _buildTabItem(1, 'Summary'),
        const SizedBox(width: 12),
        _buildTabItem(2, 'Information'),
      ],
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF161B22) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? const Color(0xFF161B22) : AppColors.border),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    switch (_activeTab) {
      case 0: return _buildTimetableTab();
      case 1: return _buildSummaryTab();
      case 2: return _buildInformationTab();
      default: return const SizedBox();
    }
  }

  Widget _buildSummaryTab() {
    if (_summary == null) return const SizedBox();
    return Column(
      children: [
        _buildSummaryCard('In company', _summary!.inCompany, Icons.business),
        const SizedBox(height: 16),
        _buildSummaryCard('Avg. shift hours', _summary!.avgShiftHours, Icons.access_time),
        const SizedBox(height: 16),
        _buildSummaryCard('Attendance rate', _summary!.attendanceRate, Icons.check_circle_outline),
      ],
    );
  }

  Widget _buildSummaryCard(String title, StaffStat stat, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFE6F2F3), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: const Color(0xFF008394), size: 32),
              ),
              const SizedBox(width: 20),
              Text(stat.label, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Expanded(child: Text(stat.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTab() {
    return Column(
      children: [
        _buildInfoItem(Icons.access_time, 'Shift', _staff.shift ?? 'N/A'),
        _buildInfoItem(Icons.person_outline, 'Gender', _staff.gender ?? 'N/A'),
        _buildInfoItem(Icons.email_outlined, 'Email', _staff.email ?? 'N/A'),
        _buildInfoItem(Icons.phone_outlined, 'Phone number', _staff.phone ?? 'N/A'),
        _buildInfoItem(Icons.location_on_outlined, 'Address', _staff.address ?? 'N/A'),
        _buildInfoItem(Icons.calendar_today, 'Joining date', DateFormat('MMMM dd, yyyy').format(_staff.joiningDate)),
        _buildInfoItem(Icons.description_outlined, 'Professional summary', _staff.professionalSummary ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTab() {
    if (_timetable == null) return const SizedBox();
    
    // Map attendance data to 6x7 grid for heatmap
    // Simple logic: filling dummy 6x7 for visualization based on report
    List<List<int>> heatmapData = List.generate(6, (_) => List.generate(7, (_) => 0));
    for (int i = 0; i < _timetable!.attendanceReport.length && i < 42; i++) {
      heatmapData[i % 6][i % 7] = _timetable!.attendanceReport[i].level;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Attendance report', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Tracks attendance and punctuality efficiently.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Less ', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  _buildLevelBox(0),
                  const SizedBox(width: 4),
                  _buildLevelBox(1),
                  const SizedBox(width: 4),
                  _buildLevelBox(2),
                  const SizedBox(width: 4),
                  _buildLevelBox(3),
                  const Text(' Full', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 24),
              AttendanceHeatmap(data: heatmapData),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(text: TextSpan(children: [
                    const TextSpan(text: 'Today task ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(text: '${_timetable!.todayTasks.where((t) => t.isCompleted).length}/${_timetable!.todayTasks.length}', style: const TextStyle(color: AppColors.textSecondary)),
                  ])),
                  Row(children: [
                    _buildSmallArrow(Icons.chevron_left),
                    const SizedBox(width: 8),
                    _buildSmallArrow(Icons.chevron_right),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              ..._timetable!.todayTasks.map((task) => _buildTaskCard(task)).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBox(int level) {
     Color color;
    switch (level) {
      case 1: color = const Color(0xFFC0E1E5); break;
      case 2: color = const Color(0xFF66B5BF); break;
      case 3: color = const Color(0xFF008394); break;
      default: color = const Color(0xFFEBEBEB);
    }
    return Container(width: 20, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)));
  }

  Widget _buildSmallArrow(IconData icon) {
    return Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle), child: Icon(icon, size: 18));
  }

  Widget _buildTaskCard(StaffTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${task.startTime} – ${task.endTime}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(task.description ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
