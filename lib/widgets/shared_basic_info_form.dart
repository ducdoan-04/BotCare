import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/app_colors.dart';
import '../screens/select_country_screen.dart';
import '../screens/select_state_screen.dart';

class SharedBasicInfoForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  
  final Uint8List? avatarBytes;
  final String? avatarPath;
  final String? profileImageUrl; // Added for Update mode
  final String? country;
  final String? stateName;
  
  final VoidCallback onPickAvatar;
  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onAddressChanged;
  final Function(String) onCityChanged;
  final Function(String) onCountryChanged;
  final Function(String) onStateChanged;

  const SharedBasicInfoForm({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    this.avatarBytes,
    this.avatarPath,
    this.profileImageUrl,
    this.country,
    this.stateName,
    required this.onPickAvatar,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onAddressChanged,
    required this.onCityChanged,
    required this.onCountryChanged,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- AVATAR PICKER SECTION ---
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F2F3),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: avatarBytes != null
                  ? Image.memory(avatarBytes!, fit: BoxFit.cover)
                  : (profileImageUrl != null
                      ? Image.network(
                          'http://${kIsWeb ? Uri.base.host : '192.168.1.8'}:3000/$profileImageUrl',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 40, color: Color(0xFF008394)),
                        )
                      : (avatarPath != null && !kIsWeb
                          ? Image.asset(avatarPath!, fit: BoxFit.cover)
                          : const Icon(Icons.person, size: 40, color: Color(0xFF008394)))),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'JPG or PNG, < 5 MB.',
                  style: TextStyle(color: Color(0xFFA0A5A9), fontSize: 13),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onPickAvatar,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF008394)),
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
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- TEXT FIELDS ---
        _buildTextField(
          hintText: 'Enter full name',
          controller: fullNameController,
          onChanged: onFullNameChanged,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hintText: 'Enter email address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hintText: 'Input phone number',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          onChanged: onPhoneChanged,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hintText: 'Enter address',
          controller: addressController,
          onChanged: onAddressChanged,
        ),
        const SizedBox(height: 16),

        // --- SELECT COUNTRY ---
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SelectCountryScreen(
                initialSelection: country ?? 'United States',
              ),
            );
            if (result != null) onCountryChanged(result);
          },
          child: _buildDropdownField(
            country ?? 'Choose country',
            true,
            isSelected: country != null,
          ),
        ),
        const SizedBox(height: 16),

        // --- SELECT STATE ---
        GestureDetector(
          onTap: () async {
            if (country == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please choose a country first'), backgroundColor: AppColors.error),
              );
              return;
            }
            final result = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SelectStateScreen(
                country: country!,
                initialSelection: stateName ?? '',
              ),
            );
            if (result != null) onStateChanged(result);
          },
          child: _buildDropdownField(
            stateName ?? 'Choose state',
            false,
            isSelected: stateName != null,
          ),
        ),
        const SizedBox(height: 16),

        // --- CITY ---
        _buildTextField(
          hintText: 'Enter city',
          controller: cityController,
          onChanged: onCityChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA0A5A9), fontWeight: FontWeight.w500, fontSize: 15),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdownField(String value, bool isPrefix, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isPrefix && isSelected && value == 'United States')
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Image.asset('images/flags/us.png', width: 24, height: 18),
            ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : const Color(0xFFA0A5A9),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA0A5A9)),
        ],
      ),
    );
  }
}
