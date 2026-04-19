import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class UpdatePatientSheet extends StatefulWidget {
  final Map<String, dynamic> patient;
  final ValueChanged<Map<String, dynamic>> onSave;

  const UpdatePatientSheet({
    super.key,
    required this.patient,
    required this.onSave,
  });

  @override
  State<UpdatePatientSheet> createState() => _UpdatePatientSheetState();
}

class _UpdatePatientSheetState extends State<UpdatePatientSheet> {
  int _currentStep = 0;

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _postalController;
  late final TextEditingController _allergiesController;

  String _selectedBloodType = 'B+';
  String _selectedSpecialist = 'General Practitioners';
  String _selectedDoctor = 'Dr. Johan Henry';
  String _selectedPatientStatus = 'Inpatient';
  DateTime _selectedDate = DateTime(2025, 11, 14);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: (widget.patient['name'] as String?) ?? '',
    );
    _addressController = TextEditingController(
      text: '6391 Elgin St. Celina, Delaware 10299',
    );
    _phoneController = TextEditingController(text: '(480) 555-0103');
    _cityController = TextEditingController(text: 'Fairbanks');
    _postalController = TextEditingController(text: '99703');
    _allergiesController = TextEditingController(text: 'Penicillin');

    _selectedBloodType = (widget.patient['bloodType'] as String?) ?? 'B+';
    _selectedSpecialist =
        (widget.patient['specialist'] as String?) ?? 'General Practitioners';
    _selectedDoctor = (widget.patient['doctor'] as String?) ?? 'Dr. Johan Henry';
    _selectedPatientStatus =
        (widget.patient['patientStatus'] as String?) ?? 'Inpatient';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Update patient',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _currentStep = 0),
                        child: _tab('Basic Info', _currentStep == 0),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _currentStep = 1),
                        child: _tab('Detail Info', _currentStep == 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_currentStep == 0) ...[
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                'images/avatars-patient/avatar-${widget.patient['avatarId']}.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'JPG or PNG, < 5 MB.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: const Color(0xFF008394),
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                'Upload New Picture',
                                style: TextStyle(
                                  color: Color(0xFF008394),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _field(_nameController),
                    const SizedBox(height: 16),
                    _field(_addressController),
                    const SizedBox(height: 16),
                    _phoneField(),
                    const SizedBox(height: 16),
                    _field(_addressController),
                    const SizedBox(height: 16),
                    _dropdown('United States', true),
                    const SizedBox(height: 16),
                    _dropdown('Alaska', false),
                    const SizedBox(height: 16),
                    _field(_cityController),
                    const SizedBox(height: 16),
                    _field(_postalController),
                  ] else ...[
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Choose blood type',
                        options: const [
                          'A+',
                          'A-',
                          'B+',
                          'B-',
                          'AB+',
                          'AB-',
                          'O+',
                          'O-'
                        ],
                        currentValue: _selectedBloodType,
                        onSelected: (val) =>
                            setState(() => _selectedBloodType = val),
                      ),
                      child: _dropdown(_selectedBloodType, false),
                    ),
                    const SizedBox(height: 16),
                    _field(_allergiesController),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Choose specialist',
                        options: const [
                          'General Practitioners',
                          'Cardiology',
                          'Dermatology',
                          'Neurology',
                          'Orthopedics'
                        ],
                        currentValue: _selectedSpecialist,
                        onSelected: (val) =>
                            setState(() => _selectedSpecialist = val),
                      ),
                      child: _dropdown(_selectedSpecialist, false),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Choose doctor',
                        options: const [
                          'Dr. Johan Henry',
                          'Dr. Dianne Russell',
                          'Dr. Mona Flores',
                          'Dr. Alicia Wexer',
                          'Dr. Leslie Alexander'
                        ],
                        currentValue: _selectedDoctor,
                        onSelected: (val) =>
                            setState(() => _selectedDoctor = val),
                      ),
                      child: _dropdown(_selectedDoctor, false),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Choose patient status',
                        options: const [
                          'Inpatient',
                          'Outpatient',
                          'Recovering',
                          'Discharged'
                        ],
                        currentValue: _selectedPatientStatus,
                        onSelected: (val) =>
                            setState(() => _selectedPatientStatus = val),
                      ),
                      child: _dropdown(_selectedPatientStatus, false),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDate,
                      child: _dateField(_formatDate(_selectedDate)),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: _outlineButton('Cancel', () => Navigator.pop(context)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _solidButton(
                    _currentStep == 0 ? 'Next' : 'Save Change',
                    () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep = 1);
                        return;
                      }

                      widget.onSave({
                        ...widget.patient,
                        'name': _nameController.text.trim().isEmpty
                            ? widget.patient['name']
                            : _nameController.text.trim(),
                        'doctor': _selectedDoctor,
                        'bloodType': _selectedBloodType,
                        'specialist': _selectedSpecialist,
                        'patientStatus': _selectedPatientStatus,
                        'allergies': _allergiesController.text.trim(),
                        'visitDate': _formatDate(_selectedDate),
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF008394),
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showOptionsSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option),
                    trailing: option == currentValue
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _tab(String label, bool selected) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE6F2F3) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                selected ? const Color(0xFF008394) : const Color(0xFFD0D5DD),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF008394) : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      );

  Widget _field(TextEditingController controller) => TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
      );

  Widget _phoneField() => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: const Row(
                children: [
                  Text(
                    'USD',
                    style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
            ),
            Container(width: 1, height: 24, color: const Color(0xFFE4E7EC)),
            Expanded(
              child: TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                style:
                    const TextStyle(fontSize: 16, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      );

  Widget _dropdown(String value, bool showFlag) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (showFlag) ...[
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            AssetImage('images/flags/Nation=united_states.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 22,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      );

  Widget _dateField(String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.calendar_month,
              size: 22,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      );

  Widget _outlineButton(String text, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF008394), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF008394),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );

  Widget _solidButton(String text, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF008394),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
}
