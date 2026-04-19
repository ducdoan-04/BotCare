import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  int _currentStep = 0; // 0: Basic Info, 1: Detail Info
  String? _selectedCountry;
  String? _selectedState;
  String _selectedPhoneCountry = 'United States';
  String _selectedGender = 'Male';
  String? _selectedBloodType;
  String? _selectedSpecialist;
  String? _selectedDoctor;
  String? _selectedPatientStatus;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let the modal handle the backdrop
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 40),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // --- CUSTOM MODAL HEADER ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add new patient',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
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
                            child: const Icon(Icons.close,
                                size: 20, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF2F4F7)),

                  // --- STEPPER HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: _buildStepper(),
          ),

          // --- FORM CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentStep == 0) ...[
                    // --- BASIC INFO FIELDS ---
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F2F3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Text('D',
                              style: TextStyle(
                                  color: Color(0xFF008394),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500)),
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
                    const SizedBox(height: 40),
                  ] else if (_currentStep == 1) ...[
                    // --- DETAIL INFO FIELDS ---
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        'Choose blood type',
                        ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                        _selectedBloodType,
                        (val) => setState(() => _selectedBloodType = val),
                      ),
                      child: _buildDropdownField(_selectedBloodType ?? 'Choose blood type', false, isSelected: _selectedBloodType != null),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter allergies'),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        'Choose specialist',
                        ['Cardiology', 'Dermatology', 'Neurology', 'Pediatrics', 'Orthopedics'],
                        _selectedSpecialist,
                        (val) => setState(() => _selectedSpecialist = val),
                      ),
                      child: _buildDropdownField(_selectedSpecialist ?? 'Choose specialist', false, isSelected: _selectedSpecialist != null),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        'Choose doctor',
                        ['Dr. Dianne Russell', 'Dr. Mona Flores', 'Dr. Alicia Wexer', 'Dr. Leslie Alexander', 'Dr. Jacob Jones'],
                        _selectedDoctor,
                        (val) => setState(() => _selectedDoctor = val),
                      ),
                      child: _buildDropdownField(_selectedDoctor ?? 'Choose doctor', false, isSelected: _selectedDoctor != null),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _showOptionsSheet(
                        'Choose patient status',
                        ['New Patient', 'Active', 'Recovering', 'Discharged'],
                        _selectedPatientStatus,
                        (val) => setState(() => _selectedPatientStatus = val),
                      ),
                      child: _buildDropdownField(_selectedPatientStatus ?? 'Choose patient status', false, isSelected: _selectedPatientStatus != null),
                    ),
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
                      child: _buildDateField(hintText: _selectedDate != null ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}' : 'Choose date'),
                    ),
                    const SizedBox(height: 40),
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
                      if (_currentStep < 1) {
                        setState(() => _currentStep++);
                      } else {
                        // Save action
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
                                      'New patient was added successfully.',
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
                                        Navigator.pop(
                                            context); // Close add patient screen
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
              height: 4,
              width: double.infinity,
              color: const Color(0xFFF2F4F7),
            ),
            // Progress line
            Positioned(
              left: 0,
              top: (24 - 4) / 2,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width *
                    (_currentStep), // Will fill to 100% when at step 1
                color: const Color(0xFF008394),
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

  Widget _buildPhoneField({required String hintPhone}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
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

  Widget _buildDropdownField(String hint, bool showFlag,
      {bool isSelected = false}) {
    bool isActuallySelected =
        isSelected || (!showFlag && hint != 'Choose state');
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F2F3) : Colors.white,
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
              size: 40,
              color: isSelected ? const Color(0xFF008394) : AppColors.textPrimary,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: isSelected ? const Color(0xFF008394) : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(String title, List<String> options, String? currentValue, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24, color: Color(0xFFF2F4F7)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == currentValue;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option, style: TextStyle(color: isSelected ? const Color(0xFF008394) : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
                    trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF008394)) : null,
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
