import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import '../models/doctor_model.dart';
import '../repositories/doctor_repository.dart';
import '../providers/add_doctor_provider.dart';
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
  final _repository = DoctorRepository();
  final _imagePicker = ImagePicker();

  // Step 1 Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  // Step 2 Controllers
  final _experienceController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseNumberController = TextEditingController();

  int _currentStep = 0; // 0: Basic Info, 1: Detail Info, 2: Security
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Populate form controller values from local provider state to RETAIN STATE when opening or navigating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AddDoctorProvider>(context, listen: false);
      _fullNameController.text = provider.state.fullName;
      _emailController.text = provider.state.email;
      _phoneController.text = provider.state.phoneNumber;
      _addressController.text = provider.state.address;
      _cityController.text = provider.state.city;

      _experienceController.text = provider.state.experience;
      _specializationController.text = provider.state.specialization ?? '';
      _licenseNumberController.text = provider.state.licenseNumber;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();

    _experienceController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  // Handle Avatar image picking with size validation
  Future<void> _pickAvatar(AddDoctorProvider provider) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final sizeInBytes = bytes.length;

        // Size check: Limit is 5 MB
        if (sizeInBytes > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Avatar image size must be less than 5 MB'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        // Save local state inside provider (NO server upload yet!)
        provider.setAvatar(
          path: kIsWeb ? null : pickedFile.path,
          bytes: bytes,
          size: sizeInBytes,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  // Final Step Form Submission
  Future<void> _submitDoctor(AddDoctorProvider provider) async {
    if (provider.state.fullName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter full name'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final docToCreate = Doctor(
        id: '',
        fullName: provider.state.fullName.trim(),
        profileImageUrl: null, // Server will upload and return URL
        gender: provider.state.gender,
        email: provider.state.email.trim().isNotEmpty ? provider.state.email.trim() : 'doctor@carebot.com',
        phoneNumber: provider.state.phoneNumber.trim().isNotEmpty ? provider.state.phoneNumber.trim() : '+1 (555) 019-9028',
        address: '${provider.state.address.trim()}, ${provider.state.city.trim()}, ${provider.state.state ?? ""}, ${provider.state.country ?? ""}',
        specialization: provider.state.specialization?.trim().isNotEmpty == true
            ? provider.state.specialization!.trim()
            : 'General Practitioner',
        experience: provider.state.experience.trim().isNotEmpty ? provider.state.experience.trim() : '5+ Years',
        education: provider.state.education,
        licenseNumber: provider.state.licenseNumber.trim().isNotEmpty ? provider.state.licenseNumber.trim() : 'LIC-102938',
        status: 'Available',
        workingHours: provider.state.workingHours,
        rating: 4.8,
        totalReviews: 120,
        totalPatients: 230,
        surgeries: 90,
        patientsIncreasePercent: 3.5,
      );

      // Call API ĐÚNG MỘT LẦN ở bước cuối cùng với Multipart Request
      await _repository.createDoctorMultipart(
        docToCreate,
        provider.state.avatarPath,
        provider.state.avatarBytes,
      );

      // Reset local multi-step state on successful server create
      provider.reset();

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding doctor: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _showSuccessDialog() {
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
                    child: const Icon(Icons.check, size: 32, color: Colors.white),
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
                    Navigator.pop(context, true); // Close add doctor screen and notify change
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddDoctorProvider>(context);

    // Sync cascading clear of city TextField if provider cleared it
    if (provider.state.city.isEmpty && _cityController.text.isNotEmpty) {
      _cityController.clear();
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Keyboard auto hide when clicking outside
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- BOTTOM SHEET HANDLE ---
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAECF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // --- TITLE BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.textPrimary),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.border, height: 1),

              // --- STEPPER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildStepper(),
              ),

              // --- SCROLLABLE CONTENT BODY ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      if (_currentStep == 0) ...[
                        // =================== STEP 1: BASIC INFO ===================
                        const SizedBox(height: 8),

                        // --- AVATAR UPLOAD ---
                        Row(
                          children: [
                            // Avatar Image Circle
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F2F3),
                                borderRadius: BorderRadius.circular(16),
                                image: provider.state.avatarBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(provider.state.avatarBytes!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: provider.state.avatarBytes == null
                                  ? const Text(
                                      'D',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF008394),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'JPG or PNG, < 5 MB.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _pickAvatar(provider),
                                  borderRadius: BorderRadius.circular(24),
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
                          controller: _fullNameController,
                          onChanged: provider.setFullName,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          hintText: 'Enter email address',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: provider.setEmail,
                        ),
                        const SizedBox(height: 16),
                        _buildPhoneField(
                          hintPhone: 'Input phone number',
                          controller: _phoneController,
                          provider: provider,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          hintText: 'Enter address',
                          controller: _addressController,
                          onChanged: provider.setAddress,
                        ),
                        const SizedBox(height: 16),

                        // --- SELECT COUNTRY BOTTOM SHEET ---
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SelectCountryScreen(
                                initialSelection: provider.state.country ?? 'United States',
                              ),
                            );
                            if (result != null) {
                              provider.setCountry(result);
                            }
                          },
                          child: _buildDropdownField(
                            provider.state.country ?? 'Choose country',
                            true,
                            isSelected: provider.state.country != null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- SELECT STATE BOTTOM SHEET ---
                        GestureDetector(
                          onTap: () async {
                            if (provider.state.country == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please choose a country first'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                              return;
                            }
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SelectStateScreen(
                                country: provider.state.country!,
                                initialSelection: provider.state.state ?? '',
                              ),
                            );
                            if (result != null) {
                              provider.setStateName(result);
                            }
                          },
                          child: _buildDropdownField(
                            provider.state.state ?? 'Choose state',
                            false,
                            isSelected: provider.state.state != null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- ENTER CITY ---
                        _buildTextField(
                          hintText: 'Enter city',
                          controller: _cityController,
                          onChanged: provider.setCity,
                        ),
                        const SizedBox(height: 24),
                        _buildGenderSelection(provider),
                        const SizedBox(height: 16),

                      ] else if (_currentStep == 1) ...[
                        // =================== STEP 2: DETAIL INFO ===================
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const SelectDepartmentScreen(
                                initialSelection: 'General Practitioner',
                              ),
                            );
                            if (result != null) {
                              provider.setSpecialization(result);
                              _specializationController.text = result;
                            }
                          },
                          child: _buildDropdownField(
                            provider.state.specialization ?? 'Select department',
                            false,
                            isSelected: provider.state.specialization != null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          hintText: 'Experience (e.g. 10+ Years)',
                          controller: _experienceController,
                          onChanged: provider.setExperience,
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const SelectQualificationScreen(
                                initialSelection: 'MD degree',
                              ),
                            );
                            if (result != null) {
                              provider.setEducation(result);
                            }
                          },
                          child: _buildDropdownField(
                            provider.state.education,
                            false,
                            isSelected: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          hintText: 'License number',
                          controller: _licenseNumberController,
                          onChanged: provider.setLicenseNumber,
                        ),
                        const SizedBox(height: 40),

                      ] else if (_currentStep == 2) ...[
                        // =================== STEP 3: SECURITY ===================
                        const SizedBox(height: 16),
                        _buildPasswordField(
                          hintText: 'Create password',
                          obscureText: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onChanged: provider.setPassword,
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
                          onChanged: provider.setRepeatPassword,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),

              // --- FOOTER ACTION BUTTONS ---
              if (!_isSaving)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Back / Cancel Button
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

                      // Continue / Create Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_currentStep == 0) {
                              // Perform validation before moving to Step 2
                              final isValid = provider.validateBasicInfo((errorMsg) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
                                );
                              });
                              if (isValid) {
                                setState(() => _currentStep = 1);
                              }
                            } else if (_currentStep == 1) {
                              setState(() => _currentStep = 2);
                            } else {
                              _submitDoctor(provider);
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
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF008394)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI STEPPER INDICATOR ---
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
                  color: _currentStep >= 0 ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: _currentStep >= 0 ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Detail Info',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _currentStep >= 1 ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: _currentStep >= 1 ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Security',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: _currentStep >= 2 ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: _currentStep >= 2 ? FontWeight.w500 : FontWeight.normal,
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
            Container(
              height: 4,
              width: double.infinity,
              color: const Color(0xFFF2F4F7),
            ),
            Positioned(
              left: 0,
              top: (24 - 4) / 2,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width * (_currentStep / 2) * 0.8,
                color: const Color(0xFF008394),
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
            color: Color(0xFFD0D5DD),
            shape: BoxShape.circle,
          ),
        ),
      );
    }
  }

  // --- TEXTFIELD BUILDERS ---
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
        hintStyle: const TextStyle(
          color: Color(0xFFA0A5A9),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFA0A5A9),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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

  // Dial code phone input. Synchronized with chosen country flag and dial code!
  Widget _buildPhoneField({
    required String hintPhone,
    required TextEditingController controller,
    required AddDoctorProvider provider,
  }) {
    final country = provider.state.country ?? 'United States';
    final dialCode = _getPhoneCode(country);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  initialSelection: provider.state.country ?? 'United States',
                ),
              );
              if (result != null) {
                provider.setCountry(result);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                        image: AssetImage('images/flags/Nation=${_getFlagAssetName(country)}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(dialCode, style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.border),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: (val) {
                provider.setPhoneNumber('$dialCode $val');
              },
              decoration: InputDecoration(
                hintText: hintPhone,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                fillColor: const Color(0xFFF9F9F9),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String hint, bool showFlag, {bool isSelected = false}) {
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
                      image: AssetImage('images/flags/Nation=${_getFlagAssetName(hint)}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                hint,
                style: TextStyle(
                  color: isActuallySelected ? AppColors.textPrimary : const Color(0xFFA0A5A9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildGenderSelection(AddDoctorProvider provider) {
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
            Expanded(child: _buildGenderCard('Male', provider)),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard('Female', provider)),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(String value, AddDoctorProvider provider) {
    bool isSelected = provider.state.gender == value;
    return GestureDetector(
      onTap: () {
        provider.setGender(value);
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

  String _getFlagAssetName(String country) {
    if (country == 'Uzbekistan') return 'uzbekistan';
    return country.toLowerCase().replaceAll(' ', '_');
  }

  String _getPhoneCode(String country) {
    const Map<String, String> phoneCodes = {
      'United States': '+1',
      'Vietnam': '+84',
      'United Kingdom': '+44',
      'Uzbekistan': '+998',
      'Uruguay': '+598',
      'Vanuatu': '+678',
      'Venezuela': '+58',
      'Yemen': '+967',
      'Zambia': '+260',
    };
    return phoneCodes[country] ?? '+1';
  }
}
