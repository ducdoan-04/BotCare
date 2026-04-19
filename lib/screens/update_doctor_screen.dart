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
