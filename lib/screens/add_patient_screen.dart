import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../providers/add_patient_provider.dart';
import '../repositories/patient_repository.dart';
import '../models/patient.dart';
import '../models/doctor_model.dart';
import '../widgets/shared_basic_info_form.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _patientRepo = PatientRepository();
  final _imagePicker = ImagePicker();

  // Step 1 Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  // Step 2 Controllers
  final _allergiesController = TextEditingController();

  int _currentStep = 0; // 0: Basic Info, 1: Detail Info
  bool _isSaving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(AddPatientProvider provider) async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      provider.setAvatar(path: image.path, bytes: bytes);
    }
  }

  Future<void> _handleSubmit(AddPatientProvider provider) async {
    if (!provider.validateDetailInfo((err) => _showError(err))) return;

    setState(() => _isSaving = true);
    try {
      final patient = Patient(
        id: '', // Backend will generate
        fullName: provider.state.fullName,
        email: provider.state.email,
        phone: provider.state.phoneNumber,
        address: provider.state.address,
        country: provider.state.country,
        state: provider.state.state,
        city: provider.state.city,
        bloodType: provider.state.bloodType,
        allergies: provider.state.allergies,
        status: provider.state.status,
        specialistDepartment: provider.state.specialistDepartment,
        assignedDoctorId: provider.state.assignedDoctorId,
      );

      await _patientRepo.createPatient(
        patient,
        provider.state.avatarPath,
        provider.state.avatarBytes,
      );

      if (mounted) {
        provider.reset();
        Navigator.pop(context, true); // Return true to indicate success
        _showSuccessDialog();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: AppColors.success),
              const SizedBox(height: 24),
              const Text('Successfully', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('New patient was added successfully.', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008394),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Ok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddPatientProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add new patient', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _currentStep == 0 ? _buildStep1(provider) : _buildStep2(provider),
            ),
          ),
          _buildFooter(provider),
        ],
      ),
    );
  }

  Widget _buildStep1(AddPatientProvider provider) {
    return SharedBasicInfoForm(
      fullNameController: _fullNameController,
      emailController: _emailController,
      phoneController: _phoneController,
      addressController: _addressController,
      cityController: _cityController,
      avatarBytes: provider.state.avatarBytes,
      avatarPath: provider.state.avatarPath,
      country: provider.state.country,
      stateName: provider.state.state,
      onPickAvatar: () => _pickAvatar(provider),
      onFullNameChanged: provider.setFullName,
      onEmailChanged: provider.setEmail,
      onPhoneChanged: provider.setPhoneNumber,
      onAddressChanged: provider.setAddress,
      onCityChanged: provider.setCity,
      onCountryChanged: provider.setCountry,
      onStateChanged: provider.setStateName,
    );
  }

  Widget _buildStep2(AddPatientProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown('Choose blood type', ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'], provider.state.bloodType, provider.setBloodType),
        const SizedBox(height: 16),
        _buildTextField('Enter allergies', _allergiesController, provider.setAllergies),
        const SizedBox(height: 16),
        _buildDropdown('Choose specialist', ['General Practitioner', 'Cardiology', 'Dermatology', 'Pediatrics', 'Neurology', 'Hematology', 'Gynecology'], provider.state.specialistDepartment, provider.setSpecialistDepartment),
        const SizedBox(height: 16),
        
        // Cascading Doctor Dropdown
        provider.isLoadingDoctors 
          ? const Center(child: CircularProgressIndicator())
          : _buildDropdown(
              'Choose doctor', 
              provider.availableDoctors.map((d) => d.fullName).toList(),
              _getSelectedDoctorName(provider),
              (name) {
                final doc = provider.availableDoctors.firstWhere((d) => d.fullName == name);
                provider.setAssignedDoctorId(doc.id);
              }
            ),
        const SizedBox(height: 16),
        _buildDropdown('Choose patient status', ['Under Treatment', 'Recovered'], provider.state.status, provider.setStatus),
      ],
    );
  }

  String? _getSelectedDoctorName(AddPatientProvider provider) {
    if (provider.state.assignedDoctorId == null) return null;
    try {
      return provider.availableDoctors.firstWhere((d) => d.id == provider.state.assignedDoctorId).fullName;
    } catch (_) {
      return null;
    }
  }

  Widget _buildDropdown(String hint, List<String> items, String? currentVal, Function(String) onSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentVal,
          hint: Text(hint, style: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 15)),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) { if (v != null) onSelected(v); },
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, Function(String) onChanged) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Basic Info', style: TextStyle(color: _currentStep >= 0 ? AppColors.textPrimary : Colors.grey, fontWeight: FontWeight.bold)),
              Text('Detail Info', style: TextStyle(color: _currentStep >= 1 ? AppColors.textPrimary : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: (_currentStep + 1) / 2, backgroundColor: Colors.grey[200], color: const Color(0xFF008394)),
        ],
      ),
    );
  }

  Widget _buildFooter(AddPatientProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () { if (_currentStep > 0) setState(() => _currentStep--); else Navigator.pop(context); },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: Color(0xFF008394)),
              ),
              child: Text(_currentStep == 0 ? 'Cancel' : 'Back', style: const TextStyle(color: Color(0xFF008394), fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : () {
                if (_currentStep == 0) {
                  if (provider.validateBasicInfo((err) => _showError(err))) setState(() => _currentStep++);
                } else {
                  _handleSubmit(provider);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008394),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: _isSaving 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(_currentStep == 0 ? 'Continue' : 'Save', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
