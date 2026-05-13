import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_colors.dart';
import '../repositories/doctor_repository.dart';
import '../widgets/shared_basic_info_form.dart';

class UpdateDoctorScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final int? index; // Added for compatibility

  const UpdateDoctorScreen({super.key, required this.doctor, this.index});

  @override
  State<UpdateDoctorScreen> createState() => _UpdateDoctorScreenState();
}

class _UpdateDoctorScreenState extends State<UpdateDoctorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DoctorRepository _repository = DoctorRepository();

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  
  late TextEditingController _experienceController;
  late TextEditingController _specializationController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _educationController;
  
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedCountry;
  String? _selectedState;
  String _selectedGender = 'Female';
  bool _isSaving = false;

  Uint8List? _avatarBytes;
  String? _avatarPath;
  String? _existingAvatarUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    final d = widget.doctor;
    _fullNameController = TextEditingController(text: d['full_name'] ?? '');
    _emailController = TextEditingController(text: d['email'] ?? '');
    _phoneController = TextEditingController(text: d['phone_number'] ?? '');
    _addressController = TextEditingController(text: d['address'] ?? '');
    _cityController = TextEditingController(text: d['city'] ?? '');
    _experienceController = TextEditingController(text: d['experience'] ?? '');
    _specializationController = TextEditingController(text: d['specialization'] ?? '');
    _licenseNumberController = TextEditingController(text: d['license_number'] ?? '');
    _educationController = TextEditingController(text: d['education'] ?? '');

    _selectedGender = d['gender'] ?? 'Female';
    _existingAvatarUrl = d['profile_image_url'];

    // Try to extract country/state if address is comma-separated
    if (d['address'] != null && d['address'].toString().contains(',')) {
      final parts = d['address'].toString().split(',');
      if (parts.length >= 4) {
        _selectedState = parts[2].trim();
        _selectedCountry = parts[3].trim();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _experienceController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _educationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _avatarBytes = bytes;
          _avatarPath = kIsWeb ? null : pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking avatar: $e');
    }
  }

  Future<void> _updateDoctor() async {
    setState(() => _isSaving = true);
    try {
      final d = widget.doctor;
      final updatePayload = {
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'address': [
          _addressController.text.trim(),
          _cityController.text.trim(),
          _selectedState ?? '',
          _selectedCountry ?? '',
        ].where((s) => s.isNotEmpty).join(', '),
        'gender': _selectedGender,
        'experience': _experienceController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'license_number': _licenseNumberController.text.trim(),
        'education': _educationController.text.trim(),
      };

      if (_usernameController.text.isNotEmpty) updatePayload['username'] = _usernameController.text.trim();
      if (_passwordController.text.isNotEmpty) updatePayload['password'] = _passwordController.text.trim();

      await _repository.updateDoctor(
        d['id'], 
        updatePayload,
        avatarPath: _avatarPath,
        avatarBytes: _avatarBytes,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doctor profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 48, height: 4, decoration: BoxDecoration(color: const Color(0xFFEAECF0), borderRadius: BorderRadius.circular(2)),),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Update doctor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 48,
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(24)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                labelColor: const Color(0xFF008394),
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [Tab(text: 'Basic Info'), Tab(text: 'Detail Info'), Tab(text: 'Security')],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildBasicInfoTab(), _buildDetailInfoTab(), _buildSecurityTab()],
            ),
          ),
          if (!_isSaving)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFF008394))),
                        alignment: Alignment.center,
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF008394), fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _updateDoctor,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: const Color(0xFF008394), borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: const Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: CircularProgressIndicator(color: Color(0xFF008394)))),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SharedBasicInfoForm(
            fullNameController: _fullNameController,
            emailController: _emailController,
            phoneController: _phoneController,
            addressController: _addressController,
            cityController: _cityController,
            avatarBytes: _avatarBytes,
            avatarPath: _avatarPath,
            profileImageUrl: _existingAvatarUrl, // Handle server image
            country: _selectedCountry,
            stateName: _selectedState,
            onPickAvatar: _pickAvatar,
            onFullNameChanged: (v) => setState(() {}),
            onEmailChanged: (v) => setState(() {}),
            onPhoneChanged: (v) => setState(() {}),
            onAddressChanged: (v) => setState(() {}),
            onCityChanged: (v) => setState(() {}),
            onCountryChanged: (v) => setState(() { _selectedCountry = v; _selectedState = null; }),
            onStateChanged: (v) => setState(() => _selectedState = v),
          ),
          const SizedBox(height: 16),
          _buildGenderSelection(),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderOption('Male'),
            const SizedBox(width: 12),
            _buildGenderOption('Female'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF008394).withOpacity(0.1) : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF008394) : Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Text(gender, style: TextStyle(color: isSelected ? const Color(0xFF008394) : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildDetailInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTextField(hintText: 'Experience', controller: _experienceController),
          const SizedBox(height: 16),
          _buildTextField(hintText: 'Specialization', controller: _specializationController),
          const SizedBox(height: 16),
          _buildTextField(hintText: 'License Number', controller: _licenseNumberController),
          const SizedBox(height: 16),
          _buildTextField(hintText: 'Education', controller: _educationController),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildTextField(hintText: 'New Username (Optional)', controller: _usernameController),
          const SizedBox(height: 16),
          _buildTextField(hintText: 'New Password (Optional)', controller: _passwordController, isPassword: true),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hintText, required TextEditingController controller, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 15),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
