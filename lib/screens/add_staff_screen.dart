import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';

class AddStaffSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSave;

  const AddStaffSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<AddStaffSheet> {
  int _currentStep = 0;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  DateTime? _selectedDate;
  String _selectedGender = 'Male';
  String _selectedPhoneCountry = 'United States';

  // Detail Info fields
  DateTime? _selectedStartDate;
  String? _selectedDesignation;
  String? _selectedCountry;
  String? _selectedState;
  
  late final TextEditingController _cityController;
  late final TextEditingController _postalController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    
    _cityController = TextEditingController();
    _postalController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    
    _cityController.dispose();
    _postalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
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
                  'Add new staff',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF2F4F7)),

          // Stepper
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _buildStepper(),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentStep == 0) ...[
                    // --- PROFILE AVATAR ---
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'D',
                            style: TextStyle(
                              color: Color(0xFF008394),
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
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
                                color: Color(0xFFA0A5A9),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                // Add image picking logic or just leave it blank for now
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // --- BASIC INFO FIELDS ---
                    _buildTextField(_nameController, hintText: 'Enter full name'),
                    const SizedBox(height: 16),
                    
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF008394),
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                      child: _buildDateField(
                        hintText: _selectedDate != null 
                          ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}' 
                          : 'Select date'
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(_emailController, hintText: 'Enter email address'),
                    const SizedBox(height: 16),
                    
                    _buildPhoneField(hintPhone: 'Input phone number'),
                    const SizedBox(height: 16),
                    
                    _buildTextField(_addressController, hintText: 'Enter address'),
                    const SizedBox(height: 24),
                    
                    _buildGenderSelection(),
                    const SizedBox(height: 48),

                  ] else if (_currentStep == 1) ...[
                    // --- DETAIL INFO FIELDS ---
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF008394),
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _selectedStartDate = picked);
                        }
                      },
                      child: _buildDateField(
                        hintText: _selectedStartDate != null 
                          ? '${_selectedStartDate!.day.toString().padLeft(2, '0')}/${_selectedStartDate!.month.toString().padLeft(2, '0')}/${_selectedStartDate!.year}' 
                          : 'Select date'
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        'Select designation',
                        const ['Nurse', 'Pharmacist', 'Receptionist', 'Accountant'],
                        _selectedDesignation,
                        (val) => setState(() => _selectedDesignation = val),
                      ),
                      child: _buildDropdownField(_selectedDesignation ?? 'Select designation', false, isSelected: _selectedDesignation != null),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => SelectCountryScreen(
                                  initialSelection: _selectedCountry ?? 'United States',
                                ),
                              );
                              if (result != null) {
                                setState(() => _selectedCountry = result);
                              }
                            },
                            child: _buildDropdownField(_selectedCountry ?? 'Choose country', false, isSelected: _selectedCountry != null),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final result = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => SelectStateScreen(
                                  initialSelection: _selectedState ?? 'California',
                                ),
                              );
                              if (result != null) {
                                setState(() => _selectedState = result);
                              }
                            },
                            child: _buildDropdownField(_selectedState ?? 'Choose state', false, isSelected: _selectedState != null),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(_cityController, hintText: 'Enter city'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(_postalController, hintText: 'Enter postal code'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(_notesController, hintText: 'Write here...', maxLines: 5),

                    const SizedBox(height: 48),
                  ],
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
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFF008394), width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep > 0 ? 'Back' : 'Cancel',
                        style: const TextStyle(
                          color: Color(0xFF008394),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep < 1) {
                        setState(() => _currentStep++);
                      } else {
                        widget.onSave({
                          'id': 'stf_${DateTime.now().millisecondsSinceEpoch}',
                          'name': _nameController.text.trim().isEmpty
                              ? 'New Staff Member'
                              : _nameController.text.trim(),
                          'role': _selectedDesignation ?? 'Receptionist',
                          'shift': '9AM - 2PM',
                          'available': true,
                          'postalCode': _postalController.text.trim(),
                          'gender': _selectedGender,
                          'avatarId': Random().nextInt(4) + 1,
                        });
                        
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              backgroundColor: const Color(0xFFE9EDEE),
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE8F5E9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF00C853),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check,
                                            size: 32, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Successfully',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'New staff was added successfully.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context); 
                                        Navigator.pop(context); 
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF008394),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Ok',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008394),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep < 1 ? 'Continue' : 'Save',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
            Expanded(
              child: Text(
                'Basic Info',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: _currentStep >= 0
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      _currentStep >= 0 ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Detail Info',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _currentStep >= 1
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      _currentStep >= 1 ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            // Background line
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Progress line
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: _currentStep == 0 ? 0.0 : 1.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008394),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
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

  Widget _buildStepIndicator(int stepIndex) {
    bool isCompleted = _currentStep > stepIndex;
    bool isActive = _currentStep == stepIndex;

    if (isActive) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF008394), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.person, size: 20, color: Color(0xFF008394)),
      );
    } else if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF008394),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFD0D5DD),
            shape: BoxShape.circle,
          ),
        ),
      );
    }
  }

  String _getPhoneCode(String country) {
    switch (country) {
      case 'Vietnam':
        return '+84';
      case 'China':
        return '+86';
      case 'Japan':
        return '+81';
      case 'South Korea':
        return '+82';
      case 'Thailand':
        return '+66';
      case 'Singapore':
        return '+65';
      case 'Malaysia':
        return '+60';
      case 'Indonesia':
        return '+62';
      case 'Philippines':
        return '+63';
      case 'India':
        return '+91';
      case 'United States':
        return '+1';
      case 'United Kingdom':
        return '+44';
      case 'Uruguay':
        return '+598';
      case 'Uzbekistan':
        return '+998';
      case 'Vanuatu':
        return '+678';
      case 'Venezuela':
        return '+58';
      case 'Wales':
        return '+44';
      case 'Yemen':
        return '+967';
      case 'Zambia':
        return '+260';
      default:
        return '+1';
    }
  }

  Widget _buildTextField(TextEditingController controller, {required String hintText, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFA0A5A9),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField({required String hintText}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hintText,
            style: const TextStyle(
              color: Color(0xFFA0A5A9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.calendar_today_outlined,
              size: 20, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildPhoneField({required String hintPhone}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SelectCountryScreen(
                  initialSelection: _selectedPhoneCountry,
                ),
              );
              if (result != null) {
                setState(() => _selectedPhoneCountry = result);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                        image: AssetImage('images/flags/Nation=${_selectedPhoneCountry.toLowerCase().replaceAll(' ', '_')}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_getPhoneCode(_selectedPhoneCountry),
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.border),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: hintPhone,
                hintStyle: const TextStyle(
                  color: Color(0xFFA0A5A9),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String hint, bool showFlag, {bool isSelected = false}) {
    bool isActuallySelected = isSelected || (!showFlag && !hint.startsWith('Choose') && !hint.startsWith('Select'));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              hint,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActuallySelected
                    ? AppColors.textPrimary
                    : const Color(0xFFA0A5A9),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down,
              size: 20, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Male', Icons.face)),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard('Female', Icons.face_3)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String value, IconData icon) {
    bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF008394) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? const Color(0xFF008394) : const Color(0xFF008394),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(String title, List<String> options, String? currentValue, ValueChanged<String> onSelected) {
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
}
