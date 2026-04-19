import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  int _currentStep = 0; // 0: Basic Info, 1: Detail Info
  String _selectedGender = 'Male';
  String? _selectedSpecialist;
  String? _selectedDoctor;
  String? _selectedTime;
  DateTime? _selectedDate;

  final List<String> _timeSlots = [
    '08.00:AM', '08.30:AM', '09.00:AM', '09.30:AM',
    '10.00:AM', '10.30:AM', '11.30:AM', '12.00:PM',
    '02.00:PM', '02.30:PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add new appointment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // --- CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- STEPPER ---
                  _buildStepper(),
                  const SizedBox(height: 32),

                  if (_currentStep == 0) ...[
                    // --- STEP 1: BASIC INFO ---
                    _buildTextField(hintText: 'Enter full name'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter age'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter email address'),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter address'),
                    const SizedBox(height: 24),
                    const Text(
                      'Gender',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildGenderCard('Male', Icons.face)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildGenderCard('Female', Icons.face_3)),
                      ],
                    ),
                  ] else ...[
                    // --- STEP 2: DETAIL INFO ---
                    _buildDropdownField(
                      _selectedSpecialist ?? 'Choose specialist',
                      onTap: () => _showOptionsSheet(
                        'Choose specialist',
                        ['Cardiology', 'Dermatology', 'Neurology', 'Pediatrics'],
                        _selectedSpecialist,
                        (val) => setState(() => _selectedSpecialist = val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      _selectedDoctor ?? 'Choose doctor',
                      onTap: () => _showOptionsSheet(
                        'Choose doctor',
                        ['Dr. Courtney Henry', 'Dr. Jane Cooper', 'Dr. Raj Patel'],
                        _selectedDoctor,
                        (val) => setState(() => _selectedDoctor = val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 24),
                    const Text(
                      'Choose Time',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _timeSlots.map((time) => _buildTimeChip(time)).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(hintText: 'Enter treatment'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Notes here...', maxLines: 4),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // --- FOOTER BUTTONS ---
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep == 0) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _currentStep = 0);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.primary),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep == 0 ? 'Cancel' : 'Back',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep = 1);
                      } else {
                        _showSuccessDialog();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep == 0 ? 'Continue' : 'Save',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Basic Info',
              style: TextStyle(
                color: _currentStep >= 0 ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: _currentStep >= 0 ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            Text(
              'Detail Info',
              style: TextStyle(
                color: _currentStep >= 1 ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: _currentStep >= 1 ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(height: 4, width: double.infinity, color: AppColors.background),
            Positioned(
              left: 0,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width * (_currentStep == 0 ? 0.05 : 0.8),
                color: AppColors.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator(0),
                _buildStepIndicator(1),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator(int step) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primary : (isActive ? AppColors.primaryLight : Colors.white),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: isCompleted ? 0 : 1),
      ),
      child: Icon(
        isCompleted ? Icons.check : (step == 0 ? Icons.person : Icons.assignment),
        size: 16,
        color: isCompleted ? Colors.white : AppColors.primary,
      ),
    );
  }

  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 15),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.flag, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('USD', style: TextStyle(fontWeight: FontWeight.w500)), // Matches design "USD" text
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.border),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Input phone number',
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? AppColors.primary : AppColors.textLight),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(hint, style: const TextStyle(color: AppColors.textLight, fontSize: 15)),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Choose date', style: TextStyle(color: AppColors.textLight, fontSize: 15)),
          const Icon(Icons.calendar_month_outlined, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    bool isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showOptionsSheet(String title, List<String> options, String? current, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ...options.map((opt) => ListTile(
              title: Text(opt),
              trailing: opt == current ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                onSelect(opt);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: AppColors.success),
              const SizedBox(height: 24),
              const Text('Success', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Appointment scheduled successfully!', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Dialog
                  Navigator.pop(context); // Sheet
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 50)),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
