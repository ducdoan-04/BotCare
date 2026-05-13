import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_colors.dart';
import '../models/patient.dart';
import '../providers/add_patient_provider.dart';
import '../repositories/patient_repository.dart';
import '../widgets/shared_basic_info_form.dart';
import '../widgets/shared_detail_info_form.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient? existingPatient;

  const PatientFormScreen({super.key, this.existingPatient});

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late TabController _tabController;
  final PatientRepository _patientRepo = PatientRepository();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _allergiesController = TextEditingController();

  bool get isUpdate => widget.existingPatient != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize provider if updating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AddPatientProvider>();
      provider.reset();
      if (isUpdate) {
        provider.initWithExistingPatient(widget.existingPatient!);
        _syncControllers(provider.state);
      }
    });
  }

  void _syncControllers(AddPatientFormState state) {
    _fullNameController.text = state.fullName;
    _emailController.text = state.email;
    _phoneController.text = state.phoneNumber;
    _addressController.text = state.address;
    _cityController.text = state.city;
    _allergiesController.text = state.allergies ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _allergiesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddPatientProvider>();
    final state = provider.state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isUpdate ? 'Update patient' : 'Add new patient',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- NAVIGATION (Stepper vs Tabs) ---
          if (isUpdate)
            _buildTabBar()
          else
            _buildStepperHeader(),

          // --- FORM CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: isUpdate 
                ? _buildTabContent(provider)
                : _buildStepContent(provider),
            ),
          ),

          // --- ACTIONS ---
          _buildActionButtons(provider),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF008394),
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: [
          _buildTabItem('Basic Info', 0),
          _buildTabItem('Detail Info', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = _tabController.index == index;
    return Tab(
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          bool selected = _tabController.index == index;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE6F2F3) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? const Color(0xFF008394) : AppColors.border),
            ),
            child: Text(label),
          );
        },
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStepCircle(1, 'Basic Info', _currentStep >= 0),
          _buildStepDivider(_currentStep >= 1),
          _buildStepCircle(2, 'Detail Info', _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int num, String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF008394) : Colors.white,
            border: Border.all(color: isActive ? const Color(0xFF008394) : AppColors.border),
          ),
          child: Center(
            child: Text(
              num.toString(),
              style: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: isActive ? const Color(0xFF008394) : AppColors.border,
      ),
    );
  }

  Widget _buildTabContent(AddPatientProvider provider) {
    return SizedBox(
      height: 600, // Fixed height for TabBarView inside scroll
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoForm(provider),
          _buildDetailInfoForm(provider),
        ],
      ),
    );
  }

  Widget _buildStepContent(AddPatientProvider provider) {
    return _currentStep == 0 ? _buildBasicInfoForm(provider) : _buildDetailInfoForm(provider);
  }

  Widget _buildBasicInfoForm(AddPatientProvider provider) {
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
      onPickAvatar: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null) {
          provider.setAvatar(bytes: result.files.first.bytes, path: result.files.first.path);
        }
      },
      onFullNameChanged: provider.setFullName,
      onEmailChanged: provider.setEmail,
      onPhoneChanged: provider.setPhoneNumber,
      onAddressChanged: provider.setAddress,
      onCityChanged: provider.setCity,
      onCountryChanged: provider.setCountry,
      onStateChanged: provider.setStateName,
    );
  }

  Widget _buildDetailInfoForm(AddPatientProvider provider) {
    return SharedDetailInfoForm(
      allergiesController: _allergiesController,
      bloodType: provider.state.bloodType,
      specialistDepartment: provider.state.specialistDepartment,
      assignedDoctorId: provider.state.assignedDoctorId,
      status: provider.state.status,
      appointmentDate: provider.state.appointmentDate,
      availableDoctors: provider.availableDoctors,
      isLoadingDoctors: provider.isLoadingDoctors,
      onBloodTypeChanged: provider.setBloodType,
      onAllergiesChanged: provider.setAllergies,
      onDepartmentChanged: provider.setSpecialistDepartment,
      onDoctorChanged: provider.setAssignedDoctorId,
      onStatusChanged: provider.setStatus,
      onDateChanged: provider.setAppointmentDate,
    );
  }

  Widget _buildActionButtons(AddPatientProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (!isUpdate && _currentStep == 1) {
                  setState(() => _currentStep = 0);
                } else {
                  Navigator.pop(context);
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF008394)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                (!isUpdate && _currentStep == 1) ? 'Back' : 'Cancel',
                style: const TextStyle(color: Color(0xFF008394), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleNextOrSave(provider),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF008394),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                isUpdate ? 'Save Change' : (_currentStep == 0 ? 'Continue' : 'Save'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextOrSave(AddPatientProvider provider) async {
    if (!isUpdate && _currentStep == 0) {
      if (provider.validateBasicInfo((msg) => _showError(msg))) {
        setState(() => _currentStep = 1);
      }
      return;
    }

    // Save Logic (Add or Update)
    if (!provider.validateBasicInfo((msg) => _showError(msg))) return;
    if (!provider.validateDetailInfo((msg) => _showError(msg))) return;

    _showLoading();

    try {
      bool success;
      if (isUpdate) {
        // Map state to Partial Update Map
        final data = {
          'full_name': provider.state.fullName,
          'email': provider.state.email,
          'phone': provider.state.phoneNumber,
          'address': provider.state.address,
          'country': provider.state.country,
          'state': provider.state.state,
          'city': provider.state.city,
          'blood_type': provider.state.bloodType,
          'allergies': provider.state.allergies,
          'specialist_department': provider.state.specialistDepartment,
          'assigned_doctor_id': provider.state.assignedDoctorId,
          'status': provider.state.status,
        };
        success = await _patientRepo.updatePatient(widget.existingPatient!.id, data, avatarBytes: provider.state.avatarBytes);
      } else {
        final newPatient = Patient(
          id: '',
          fullName: provider.state.fullName,
          email: provider.state.email,
          phone: provider.state.phoneNumber,
          address: provider.state.address,
          country: provider.state.country,
          state: provider.state.state,
          city: provider.state.city,
          bloodType: provider.state.bloodType,
          allergies: provider.state.allergies,
          specialistDepartment: provider.state.specialistDepartment,
          assignedDoctorId: provider.state.assignedDoctorId,
          status: provider.state.status,
          registeredAt: DateTime.now().toIso8601String(),
        );
        final p = await _patientRepo.createPatient(newPatient, avatarBytes: provider.state.avatarBytes);
        success = true;
      }

      Navigator.pop(context); // Close loading
      if (success) {
        Navigator.pop(context, true); // Return success to list screen
        _showSuccess(isUpdate ? 'Patient updated successfully' : 'Patient added successfully');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.error));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.success));
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
