import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:carebot/models/staff_model.dart';
import 'package:carebot/repositories/staff_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

class StaffFormScreen extends StatefulWidget {
  final Staff? existingStaff;

  const StaffFormScreen({super.key, this.existingStaff});

  @override
  State<StaffFormScreen> createState() => _StaffFormScreenState();
}

class _StaffFormScreenState extends State<StaffFormScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isSubmitting = false;
  late TabController _tabController;
  final StaffRepository _repository = StaffRepository();

  // Form Controllers
  XFile? _avatarFile;
  Uint8List? _avatarBytes;
  final _fullNameController = TextEditingController();
  DateTime? _dob;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _gender = 'Male';

  DateTime? _joiningDate;
  String? _designation;
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _summaryController = TextEditingController();

  final List<String> _designations = ['Nurse', 'Pharmacist', 'Receptionist', 'Accountant'];

  bool get isUpdate => widget.existingStaff != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (isUpdate) {
      final s = widget.existingStaff!;
      _fullNameController.text = s.fullName;
      _emailController.text = s.email ?? '';
      _phoneController.text = s.phone ?? '';
      _addressController.text = s.address ?? '';
      _gender = s.gender ?? 'Male';
      _joiningDate = s.joiningDate;
      _designation = s.role;
      _summaryController.text = s.professionalSummary ?? '';
      
      // Parse address if saved in comma format
      if (s.address != null && s.address!.contains(',')) {
        final parts = s.address!.split(',');
        if (parts.length >= 3) {
          _cityController.text = parts[0].trim();
          _stateController.text = parts[1].trim();
          _countryController.text = parts[2].trim();
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _avatarFile = image;
        _avatarBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    if (_fullNameController.text.isEmpty || _emailController.text.isEmpty || _designation == null) {
      _showSnackBar('Please fill all required fields');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final Map<String, dynamic> data = {
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'gender': _gender,
        'role': _designation!,
        'country': _countryController.text,
        'state': _stateController.text,
        'city': _cityController.text,
        'postal_code': _postalCodeController.text,
        'professional_summary': _summaryController.text,
      };
      
      if (_cityController.text.isNotEmpty) {
        data['address'] = '${_cityController.text}, ${_stateController.text}, ${_countryController.text}';
      } else {
        data['address'] = _addressController.text;
      }

      if (_joiningDate != null) data['joining_date'] = _joiningDate!.toIso8601String();

      bool success;
      if (isUpdate) {
        success = await _repository.updateStaff(widget.existingStaff!.id, data, avatarPath: _avatarFile?.path, avatarBytes: _avatarBytes);
      } else {
        success = await _repository.createStaff(data, avatarPath: _avatarFile?.path, avatarBytes: _avatarBytes);
      }

      if (success) {
        Navigator.pop(context, true);
      } else {
        _showSnackBar('Failed to ${isUpdate ? 'update' : 'create'} staff');
      }
    } catch (e) {
      _showSnackBar(e.toString());
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(
        children: [
          _buildHeader(),
          isUpdate ? _buildTabBar() : _buildStepperHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: isUpdate 
                ? _buildTabContent()
                : (_currentStep == 0 ? _buildBasicInfoStep() : _buildDetailInfoStep()),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isUpdate ? 'Update staff' : 'Add new staff', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel('Basic Info', _currentStep >= 0),
              _buildStepLabel('Detail Info', _currentStep >= 1),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(height: 4, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(2))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * (_currentStep == 0 ? 0.45 : 0.9),
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFF008394), borderRadius: BorderRadius.circular(2)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String text, bool active) => Text(text, style: TextStyle(color: active ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13));

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF008394),
      labelColor: const Color(0xFF008394),
      unselectedLabelColor: AppColors.textSecondary,
      tabs: const [Tab(text: 'Basic Info'), Tab(text: 'Detail Info')],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        children: [_buildBasicInfoStep(), _buildDetailInfoStep()],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
              child: _avatarBytes != null 
                ? ClipOval(child: Image.memory(_avatarBytes!, fit: BoxFit.cover))
                : (isUpdate && widget.existingStaff!.profileImageUrl != null
                    ? ClipOval(child: Image.network('http://192.168.1.8:3000/${widget.existingStaff!.profileImageUrl}', fit: BoxFit.cover))
                    : const Icon(Icons.person_outline, size: 32, color: Color(0xFF008394))),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField('Enter full name', _fullNameController),
        const SizedBox(height: 16),
        _buildDatePicker('Select date (DOB)', _dob, (d) => setState(() => _dob = d)),
        const SizedBox(height: 16),
        _buildTextField('Enter email address', _emailController),
        const SizedBox(height: 16),
        _buildTextField('Input phone number', _phoneController),
        const SizedBox(height: 16),
        _buildTextField('Enter address', _addressController),
        const SizedBox(height: 24),
        const Text('Gender', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildGenderCard('Male', Icons.face),
            const SizedBox(width: 16),
            _buildGenderCard('Female', Icons.face_retouching_natural),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDatePicker('Select date (Joining Date)', _joiningDate, (d) => setState(() => _joiningDate = d)),
        const SizedBox(height: 16),
        _buildDropdown('Select designation', _designation, _designations, (v) => setState(() => _designation = v)),
        const SizedBox(height: 16),
        // Requirements: Country and State in one row
        Row(
          children: [
            Expanded(child: _buildTextField('Choose country', _countryController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Choose state', _stateController)),
          ],
        ),
        const SizedBox(height: 16),
        // Requirements: City and Postal code in one row
        Row(
          children: [
            Expanded(child: _buildTextField('Enter city', _cityController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Enter postal code', _postalCodeController)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Professional summary', _summaryController, maxLines: 4),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller, maxLines: maxLines,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.all(16)),
      ),
    );
  }

  Widget _buildDatePicker(String hint, DateTime? value, Function(DateTime) onSelect) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
        if (d != null) onSelect(d);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value != null ? DateFormat('MMMM dd, yyyy').format(value) : hint, style: TextStyle(color: value != null ? AppColors.textPrimary : AppColors.textSecondary)),
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, hint: Text(hint, style: const TextStyle(color: AppColors.textSecondary)),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon) {
    final bool isSelected = _gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6F2F3) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isSelected ? const Color(0xFF008394) : AppColors.border),
          ),
          child: Column(children: [Icon(icon, color: const Color(0xFF008394)), const SizedBox(height: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text(isUpdate ? 'Cancel' : (_currentStep == 1 ? 'Back' : 'Cancel')))),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : (_currentStep == 0 && !isUpdate ? () => setState(() => _currentStep = 1) : _submit),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008394)),
              child: _isSubmitting 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(isUpdate ? 'Save Change' : (_currentStep == 0 ? 'Continue' : 'Save')),
            ),
          ),
        ],
      ),
    );
  }
}
