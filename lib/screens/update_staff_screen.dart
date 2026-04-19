import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';

class UpdateStaffSheet extends StatefulWidget {
  final Map<String, dynamic> staff;
  final ValueChanged<Map<String, dynamic>> onSave;

  const UpdateStaffSheet({
    super.key,
    required this.staff,
    required this.onSave,
  });

  @override
  State<UpdateStaffSheet> createState() => _UpdateStaffSheetState();
}

class _UpdateStaffSheetState extends State<UpdateStaffSheet> {
  int _currentStep = 0;

  late final TextEditingController _nameController;
  late final TextEditingController _address1Controller;
  late final TextEditingController _phoneController;
  late final TextEditingController _address2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _postalController;

  String _selectedRole = 'Receptionist';
  String _selectedShift = '9AM - 2PM';
  bool _isAvailable = true;
  String _selectedGender = 'Male';

  String _selectedPhoneCode = 'USD';
  String _selectedCountry = 'United States';
  String _selectedState = 'Alaska';

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.staff['name'] as String? ?? '');
    _address1Controller = TextEditingController(text: '6391 Elgin St. Celina, Delaware 10299');
    _phoneController = TextEditingController(text: '(704) 555-0127');
    _address2Controller = TextEditingController(text: '6391 Elgin St. Celina, Delaware 10299');
    _cityController = TextEditingController(text: 'Fairbanks');
    _postalController = TextEditingController(text: widget.staff['postalCode'] as String? ?? '10299');

    _selectedRole = widget.staff['role'] as String? ?? 'Receptionist';
    _selectedShift = widget.staff['shift'] as String? ?? '9AM - 2PM';
    _isAvailable = widget.staff['available'] as bool? ?? true;
    _selectedGender = widget.staff['gender'] as String? ?? 'Female';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _address1Controller.dispose();
    _phoneController.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90, // Not full screen
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Update staff',
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

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => _currentStep = 2),
                          child: _tab('Security', _currentStep == 2),
                        ),
                      ],
                    ),
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
                                'images/avatars-staff/avatar-${widget.staff['avatarId']}.jpg',
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
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
                                  fontSize: 14,
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
                    _field(_address1Controller),
                    const SizedBox(height: 16),
                    _phoneField(),
                    const SizedBox(height: 16),
                    _field(_address2Controller),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectCountryScreen(
                            initialSelection: _selectedCountry,
                          ),
                        );
                        if (result != null) {
                          setState(() => _selectedCountry = result);
                        }
                      },
                      child: _dropdown(_selectedCountry, showFlag: true),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectStateScreen(
                            initialSelection: _selectedState,
                          ),
                        );
                        if (result != null) {
                          setState(() => _selectedState = result);
                        }
                      },
                      child: _dropdown(_selectedState, showFlag: false),
                    ),
                    const SizedBox(height: 16),
                    _field(_cityController),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _postalController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9F9F9),
                        hintText: 'Enter postal code',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 24),
                    _genderSelection(),
                  ] else if (_currentStep == 1) ...[
                    const Text('Role',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Role',
                        options: const [
                          'Nurse',
                          'Pharmacist',
                          'Receptionist',
                          'Accountant'
                        ],
                        currentValue: _selectedRole,
                        onSelected: (val) => setState(() => _selectedRole = val),
                      ),
                      child: _dropdown(_selectedRole, showFlag: false),
                    ),
                    const SizedBox(height: 16),
                    const Text('Shift',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        title: 'Select Shift',
                        options: const ['9AM - 2PM', '2PM - 7PM', '7PM - 12AM'],
                        currentValue: _selectedShift,
                        onSelected: (val) => setState(() => _selectedShift = val),
                      ),
                      child: _dropdown(_selectedShift, showFlag: false),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mark as Available',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Switch(
                          value: _isAvailable,
                          onChanged: (val) => setState(() => _isAvailable = val),
                          activeColor: const Color(0xFF008394),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),

          // Footer
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
                    _currentStep == 0 ? 'Next' : 'Update',
                    () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep = 1);
                        return;
                      }
                      
                      widget.onSave({
                        ...widget.staff,
                        'name': _nameController.text.trim().isEmpty
                            ? widget.staff['name']
                            : _nameController.text.trim(),
                        'role': _selectedRole,
                        'shift': _selectedShift,
                        'available': _isAvailable,
                        'postalCode': _postalController.text.trim(),
                        'gender': _selectedGender,
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

  Widget _tab(String label, bool selected) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            GestureDetector(
              onTap: () => _showOptionsSheet(
                title: 'Phone Code',
                options: const ['USD', 'EUR', 'GBP', 'VND'],
                currentValue: _selectedPhoneCode,
                onSelected: (val) => setState(() => _selectedPhoneCode = val),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                color: Colors.transparent,
                child: Row(
                  children: [
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
                    const SizedBox(width: 8),
                    Text(
                      _selectedPhoneCode,
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
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

  Widget _dropdown(String value, {required bool showFlag}) => Container(
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            'images/flags/Nation=${value.toLowerCase().replaceAll(' ', '_')}.png'),
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

  Widget _genderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedGender = 'Male'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'Male'
                        ? const Color(0xFFE6F2F3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGender == 'Male'
                          ? const Color(0xFF008394)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.face,
                          size: 44,
                          color: _selectedGender == 'Male'
                              ? const Color(0xFF008394)
                              : AppColors.textPrimary),
                      const SizedBox(height: 12),
                      Text(
                        'Male',
                        style: TextStyle(
                          color: _selectedGender == 'Male'
                              ? const Color(0xFF008394)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedGender = 'Female'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: _selectedGender == 'Female'
                        ? const Color(0xFFE6F2F3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedGender == 'Female'
                          ? const Color(0xFF008394)
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.face_3,
                          size: 44,
                          color: _selectedGender == 'Female'
                              ? const Color(0xFF008394)
                              : AppColors.textPrimary),
                      const SizedBox(height: 12),
                      Text(
                        'Female',
                        style: TextStyle(
                          color: _selectedGender == 'Female'
                              ? const Color(0xFF008394)
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
