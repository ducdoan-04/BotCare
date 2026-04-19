import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';
import 'select_department_screen.dart';
import 'select_qualification_screen.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  int _currentStep = 0; // 0: Basic Info, 1: Detail Info, 2: Security
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDepartment;
  String? _selectedQualification;
  String _selectedPhoneCountry = 'United States';
  String _selectedGender = 'Male';
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

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
                  'Add new doctor',
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
                  // --- STEPPER ---
                  _buildStepper(),
                  const SizedBox(height: 32),

                  // If _currentStep == 0 show Basic Info form
                  if (_currentStep == 0) ...[
                    // --- AVATAR UPLOAD ---
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE6F2F3), // Pale blue background
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'D',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF008394),
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
                    _buildTextField(hintText: 'Enter full name'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter email address'),
                    const SizedBox(height: 16),
                    _buildPhoneField(hintPhone: 'Input phone number'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter address'),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectCountryScreen(
                            initialSelection:
                                _selectedCountry ?? 'United States',
                          ),
                        );
                        if (result != null) {
                          setState(() => _selectedCountry = result);
                        }
                      },
                      child: _buildDropdownField(
                          _selectedCountry ?? 'Choose country', true,
                          isSelected: _selectedCountry != null),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
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
                      child: _buildDropdownField(
                          _selectedState ?? 'Choose state', false,
                          isSelected: _selectedState != null),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter city'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter postal code'),
                    const SizedBox(height: 24),
                    _buildGenderSelection(),
                    const SizedBox(height: 1),
                  ] else if (_currentStep == 1) ...[
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectDepartmentScreen(
                            initialSelection: _selectedDepartment,
                          ),
                        );
                        if (result != null) {
                          setState(() => _selectedDepartment = result);
                        }
                      },
                      child: _buildDropdownField(
                          _selectedDepartment ?? 'Choose department', false,
                          isSelected: _selectedDepartment != null),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SelectQualificationScreen(
                            initialSelection: _selectedQualification,
                          ),
                        );
                        if (result != null) {
                          setState(() => _selectedQualification = result);
                        }
                      },
                      child: _buildDropdownField(
                          _selectedQualification ?? 'Choose qualification', false,
                          isSelected: _selectedQualification != null),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter experience'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter specialization'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter license number'),
                    const SizedBox(height: 40),
                  ] else if (_currentStep == 2) ...[
                    _buildTextField(hintText: 'Enter username'),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      hintText: 'Enter password',
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      hintText: 'Repeat password',
                      obscureText: _obscureRepeatPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureRepeatPassword = !_obscureRepeatPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                  ] else ...[
                    // Placeholder for other steps
                    Center(
                        child:
                            Text('Step ${_currentStep + 1} content goes here')),
                  ],
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
                        border: Border.all(color: const Color(0xFF008394)),
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
                      if (_currentStep < 2) {
                        setState(() => _currentStep++);
                      } else {
                        // Create action
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
                                      'New doctor was added successfully.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(context); // Close add doctor screen
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
                        _currentStep < 2 ? 'Continue' : 'Create',
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
                textAlign: TextAlign.center,
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
            Expanded(
              child: Text(
                'Security',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _currentStep >= 2
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      _currentStep >= 2 ? FontWeight.w500 : FontWeight.normal,
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
              height: 4,
              width: double.infinity,
              color: const Color(0xFFF2F4F7), // Light grey line
            ),
            // Progress line (if we wanted to fill it)
            Positioned(
              left: 0,
              top: (24 - 4) / 2, // Centered vertically with dots
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width *
                    (_currentStep / 2) *
                    0.8, // Approximation
                color: const Color(0xFF008394), // Teal line
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator(0),
                _buildStepIndicator(1),
                _buildStepIndicator(2),
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
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFFE6F2F3),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF008394), width: 1.5),
        ),
        child: const Icon(Icons.person, size: 14, color: Color(0xFF008394)),
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
            color: Color(0xFFD0D5DD), // Grey dot
            shape: BoxShape.circle,
          ),
        ),
      );
    }
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

  Widget _buildPasswordField({
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      obscureText: obscureText,
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
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFFA0A5A9),
          ),
          splashRadius: 20,
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

  Widget _buildDropdownField(String hint, bool showFlag,
      {bool isSelected = false}) {
    // If it's a state field, it's considered "selected" if it's not the placeholder
    bool isActuallySelected = isSelected || (!showFlag && hint != 'Choose state');
    
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
              if (showFlag && hint != 'Choose country') ...[
                Container(
                  width: 20,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    image: DecorationImage(
                      image: AssetImage(
                          'images/flags/Nation=${_getFlagAssetName(hint)}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                hint,
                style: TextStyle(
                  color: isActuallySelected
                      ? AppColors.textPrimary
                      : const Color(0xFFA0A5A9),
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

  String _getFlagAssetName(String country) {
    if (country == 'Uzbekistan') return 'uzbekistan';
    return country.toLowerCase().replaceAll(' ', '_');
  }

  String _getPhoneCode(String country) {
    const Map<String, String> phoneCodes = {
      'Afghanistan': '+93', 'Albania': '+355', 'Algeria': '+213',
      'Angola': '+244', 'Argentina': '+54', 'Armenia': '+374',
      'Australia': '+61', 'Austria': '+43', 'Azerbaijan': '+994',
      'Bahrain': '+973', 'Bangladesh': '+880', 'Belarus': '+375',
      'Belgium': '+32', 'Bolivia': '+591', 'Bosnia': '+387',
      'Brazil': '+55', 'Bulgaria': '+359', 'Cambodia': '+855',
      'Cameroon': '+237', 'Canada': '+1', 'Chile': '+56',
      'China': '+86', 'Colombia': '+57', 'Croatia': '+385',
      'Cuba': '+53', 'Cyprus': '+357', 'Czech Republic': '+420',
      'Denmark': '+45', 'Ecuador': '+593', 'Egypt': '+20',
      'Ethiopia': '+251', 'Finland': '+358', 'France': '+33',
      'Georgia': '+995', 'Germany': '+49', 'Ghana': '+233',
      'Greece': '+30', 'Guatemala': '+502', 'Honduras': '+504',
      'Hong Kong': '+852', 'Hungary': '+36', 'India': '+91',
      'Indonesia': '+62', 'Iran': '+98', 'Iraq': '+964',
      'Ireland': '+353', 'Israel': '+972', 'Italy': '+39',
      'Jamaica': '+1876', 'Japan': '+81', 'Jordan': '+962',
      'Kazakhstan': '+7', 'Kenya': '+254', 'Kuwait': '+965',
      'Kyrgyzstan': '+996', 'Laos': '+856', 'Latvia': '+371',
      'Lebanon': '+961', 'Libya': '+218', 'Lithuania': '+370',
      'Luxembourg': '+352', 'Macau': '+853', 'Malaysia': '+60',
      'Maldives': '+960', 'Mexico': '+52', 'Moldova': '+373',
      'Mongolia': '+976', 'Morocco': '+212', 'Myanmar': '+95',
      'Nepal': '+977', 'Netherlands': '+31', 'New Zealand': '+64',
      'Nigeria': '+234', 'North Korea': '+850', 'Norway': '+47',
      'Oman': '+968', 'Pakistan': '+92', 'Panama': '+507',
      'Paraguay': '+595', 'Peru': '+51', 'Philippines': '+63',
      'Poland': '+48', 'Portugal': '+351', 'Qatar': '+974',
      'Romania': '+40', 'Russia': '+7', 'Saudi Arabia': '+966',
      'Serbia': '+381', 'Singapore': '+65', 'Slovakia': '+421',
      'Slovenia': '+386', 'South Africa': '+27', 'South Korea': '+82',
      'Spain': '+34', 'Sri Lanka': '+94', 'Sudan': '+249',
      'Sweden': '+46', 'Switzerland': '+41', 'Syria': '+963',
      'Taiwan': '+886', 'Tajikistan': '+992', 'Tanzania': '+255',
      'Thailand': '+66', 'Tunisia': '+216', 'Turkey': '+90',
      'Turkmenistan': '+993', 'Uganda': '+256', 'Ukraine': '+380',
      'United Arab Emirates': '+971', 'United Kingdom': '+44',
      'United States': '+1', 'Uruguay': '+598', 'Uzbekistan': '+998',
      'Venezuela': '+58', 'Vietnam': '+84', 'Wales': '+44',
      'Yemen': '+967', 'Zambia': '+260', 'Zimbabwe': '+263',
    };
    return phoneCodes[country] ?? '+1';
  }

}
