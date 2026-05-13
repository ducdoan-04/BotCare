import 'package:carebot/screens/patient_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import 'add_patient_screen.dart';
import 'notification_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final _repository = PatientRepository();
  List<Patient> _patients = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final result = await _repository.fetchPatients(
        search: _searchQuery,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      );
      setState(() {
        _patients = result['patients'];
        _stats = result['stats'];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading patients: $e');
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
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _patients.isEmpty ? _buildEmptyState() : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Patient', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Row(
                children: [
                  _buildIconBtn(Icons.search, onTap: () {
                    // Implement search toggle or field
                  }),
                  const SizedBox(width: 12),
                  _buildIconBtn(Icons.notifications_none, hasBadge: true, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                  }),
                  const SizedBox(width: 12),
                  _buildIconBtn(Icons.add, isPrimary: true, onTap: () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientFormScreen()));
                    if (res == true) _loadData();
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20, color: AppColors.textPrimary),
                  const SizedBox(width: 12),
                  const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(DateFormat('dd MMMM yyyy').format(_selectedDate), style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildStatCard('Total patient', _stats['total_patients']?['value']?.toString() ?? '0', _stats['total_patients']?['percent_change']?.toString() ?? '0', _stats['total_patients']?['is_increase'] ?? true),
            const SizedBox(height: 16),
            _buildStatCard('Appointments', _stats['appointments']?['value']?.toString() ?? '0', _stats['appointments']?['percent_change']?.toString() ?? '0', _stats['appointments']?['is_increase'] ?? true),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _patients.length,
              itemBuilder: (context, index) => _buildPatientCard(_patients[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String percent, bool isIncrease) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${isIncrease ? '+' : '-'}${double.tryParse(percent)?.toStringAsFixed(1) ?? percent}%',
                  style: TextStyle(color: isIncrease ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text('from yesterday', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: p.avatarUrl != null 
                  ? NetworkImage('http://192.168.1.8:3000/${p.avatarUrl}') 
                  : const AssetImage('images/avatars-patient/patient-1.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(p.assignedDoctorName ?? 'No Doctor Assigned', style: const TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last Visit', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text(p.lastVisitDate != null ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(p.lastVisitDate!)) : 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildActionIcon(Icons.edit_outlined, AppColors.textPrimary, onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PatientFormScreen(existingPatient: p)),
                          );
                          if (result == true) _loadData();
                        }),
                        const SizedBox(width: 8),
                        _buildActionIcon(Icons.delete_outline, AppColors.error, onTap: () {
                          // Implement delete logic if needed
                        }),
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

  Widget _buildIconBtn(IconData icon, {bool isPrimary = false, bool hasBadge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPrimary ? const Color(0xFF008394) : Colors.white,
              border: isPrimary ? null : Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: isPrimary ? Colors.white : AppColors.textPrimary, size: 24),
          ),
          if (hasBadge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.border)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_add, size: 80, color: Color(0xFF008394)),
          const SizedBox(height: 24),
          const Text('No patients added yet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const PatientFormScreen()));
              if (res == true) _loadData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008394), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: const Text('New Patient', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
