import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';

class UpdateDoctorScreen extends StatefulWidget {
  final Map<String, dynamic>? doctor;
  final int? index;

  const UpdateDoctorScreen({super.key, this.doctor, this.index});

  @override
  State<UpdateDoctorScreen> createState() => _UpdateDoctorScreenState();
}

class _UpdateDoctorScreenState extends State<UpdateDoctorScreen> {
  int _currentStep = 0; // 0: Basic Info, 1: Detail Info, 2: Security
  String _selectedPhoneCountry = 'United States';
  String _selectedGender = 'Female';
  String? _selectedState = 'Alaska';

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
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
                  'Update doctor',
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
                    child: const Icon(Icons.close,
                        size: 20, color: AppColors.textSecondary),
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
                  // --- TABS ---
                  Row(
                    children: [
                      _buildTab('Basic Info', true),
                      const SizedBox(width: 12),
                      _buildTab('Detail Info', false),
                      const SizedBox(width: 12),
                      _buildTab('Security', false),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- AVATAR UPLOAD ---
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(
                                'images/avatars-doctor/avatar-${(widget.index ?? 0) + 1}.jpg'),
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
                                color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border:
                                  Border.all(color: const Color(0xFF008394)),
                            ),
                            child: const Text(
                              'Upload New Picture',
                              style: TextStyle(
                                color: Color(0xFF008394),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- FORM FIELDS ---
                  _buildTextField(hintText: 'Dr. Dianne Russell'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      hintText: '6391 Elgin St. Celina, Delaware 10299'),
                  const SizedBox(height: 16),
                  _buildPhoneField(hintPhone: '(704) 555-0127'),
                  const SizedBox(height: 16),
                  _buildTextField(
                      hintText: '6391 Elgin St. Celina, Delaware 10299'),
                  const SizedBox(height: 16),
                  _buildDropdownField('United States',
                      true), // Assuming flag is part of it or just text
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SelectStateScreen(
                          initialSelection: _selectedState ?? 'Alaska',
                        ),
                      );
                      if (result != null) {
                        setState(() => _selectedState = result);
                      }
                    },
                    child: _buildDropdownField(
                        _selectedState ?? 'Alaska', false),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(hintText: 'Fairbanks'),
                  const SizedBox(height: 16),
                  _buildTextField(hintText: '99703'),
                  const SizedBox(height: 24),
                  _buildGenderSelection(),

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
                        style: TextStyle(
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
                    onTap: () => _showSuccessDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008394),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Update',
                        style: TextStyle(
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

  Widget _buildTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE6F2F3) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isSelected ? const Color(0xFF008394) : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF008394) : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText}) {
    return TextFormField(
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
            const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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

  Widget _buildPhoneField({required String hintPhone}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Country code part
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
                        image: AssetImage(
                            'images/flags/Nation=${_getFlagAssetName(_selectedPhoneCountry)}.png'),
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
          // Number part
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: hintPhone,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                fillColor: const Color(0xFFF9F9F9),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
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
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Male')),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard('Female')),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String value) {
    bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F2F3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              value == 'Male' ? Icons.face : Icons.face_3,
              size: 40,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String value, bool showFlag) {
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
          Row(
            children: [
              if (showFlag && value != 'Choose country') ...[
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    image: DecorationImage(
                      image: AssetImage(
                          'images/flags/Nation=${_getFlagAssetName(value)}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down,
              size: 20, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (Designer mistakenly used a Trash bin for success here, matching the provided screenshot exactly)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFFFEE),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF05B93E),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 36),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Successfully',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Info doctor was changed successfully.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close bottom sheet
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008394),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
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

  String _getFlagAssetName(String country) {
    if (country == 'Uzbekistan') return 'uzbekistan';
    return country.toLowerCase().replaceAll(' ', '_');
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
}
