import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';
import 'select_state_screen.dart';
import 'select_department_screen.dart';
import 'select_qualification_screen.dart';
import '../services/doctor_service.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Data storage
  final Map<String, dynamic> _formData = {
    'name': '',
    'email': '',
    'phone': '',
    'address': '',
    'city': '',
    'postalCode': '',
    'gender': 'Male',
    'specialty': '',
    'experience': '',
    'licenseNumber': '',
    'username': '',
    'password': '',
    'department': '',
    'qualification': '',
  };

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDepartment;
  String? _selectedQualification;
  String _selectedPhoneCountry = 'United States';
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  bool _isSaving = false;

  final _doctorService = DoctorService();

  // Controllers to persist text across step changes
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'name': TextEditingController(),
      'email': TextEditingController(),
      'phone': TextEditingController(),
      'address': TextEditingController(),
      'city': TextEditingController(),
      'postalCode': TextEditingController(),
      'experience': TextEditingController(),
      'specialty': TextEditingController(),
      'licenseNumber': TextEditingController(),
      'username': TextEditingController(),
      'password': TextEditingController(),
      'repeatPassword': TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleContinue() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _saveDoctor();
    }
  }

  Future<void> _saveDoctor() async {
    if (_controllers['password']!.text != _controllers['repeatPassword']!.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final finalData = {
      'name': _controllers['name']!.text.trim().isNotEmpty 
          ? _controllers['name']!.text.trim() 
          : 'New Doctor',
      'email': _controllers['email']!.text.trim(),
      'phone': '${_getPhoneCode(_selectedPhoneCountry)} ${_controllers['phone']!.text.trim()}',
      'address': _controllers['address']!.text.trim(),
      'country': _selectedCountry ?? '',
      'state': _selectedState ?? '',
      'city': _controllers['city']!.text.trim(),
      'postalCode': _controllers['postalCode']!.text.trim(),
      'gender': _formData['gender'],
      'specialty': _controllers['specialty']!.text.trim().isNotEmpty
          ? _controllers['specialty']!.text.trim()
          : (_selectedDepartment ?? 'General Practitioner'),
      'department': _selectedDepartment ?? '',
      'qualification': _selectedQualification ?? '',
      'experience': _controllers['experience']!.text.trim(),
      'licenseNumber': _controllers['licenseNumber']!.text.trim(),
      'username': _controllers['username']!.text.trim(),
      'password': _controllers['password']!.text,
      'availability': 'Available',
      'workHours': '9AM - 5PM',
      'avatar': '1',
      'totalPatients': 0,
      'surgeries': 0,
      'rating': 5.0,
      'reviewsCount': 0,
      'about': 'Profile created via BotCare App',
    };

    debugPrint('Submit Data: $finalData');
    
    final success = await _doctorService.createDoctor(finalData);
    
    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection error. Please check if backend is running on port 3000.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Color(0xFF00C853)),
              const SizedBox(height: 24),
              const Text('Successfully', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Doctor added successfully!', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008394),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Ok', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildStepper(),
                  const SizedBox(height: 32),
                  _buildCurrentStep(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Add new doctor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _stepBasic();
      case 1: return _stepDetail();
      case 2: return _stepSecurity();
      default: return const SizedBox.shrink();
    }
  }

  Widget _stepBasic() {
    return Column(
      key: const ValueKey('step0'),
      children: [
        _textField('Full Name', _controllers['name']!, Icons.person_outline),
        const SizedBox(height: 16),
        _textField('Email', _controllers['email']!, Icons.email_outlined, type: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _phoneField(),
        const SizedBox(height: 16),
        _textField('Address', _controllers['address']!, Icons.location_on_outline),
        const SizedBox(height: 16),
        _picker('Country', _selectedCountry ?? 'Choose country', () async {
          final r = await showModalBottomSheet<String>(
            context: context, builder: (_) => SelectCountryScreen(initialSelection: _selectedCountry ?? 'United States'),
          );
          if (r != null) setState(() => _selectedCountry = r);
        }),
        const SizedBox(height: 16),
        _picker('State', _selectedState ?? 'Choose state', () async {
          final r = await showModalBottomSheet<String>(
            context: context, builder: (_) => SelectStateScreen(initialSelection: _selectedState ?? 'California'),
          );
          if (r != null) setState(() => _selectedState = r);
        }),
        const SizedBox(height: 16),
        _textField('City', _controllers['city']!, Icons.location_city_outlined),
        const SizedBox(height: 24),
        _genderPicker(),
      ],
    );
  }

  Widget _stepDetail() {
    return Column(
      key: const ValueKey('step1'),
      children: [
        _picker('Department', _selectedDepartment ?? 'Choose department', () async {
          final r = await showModalBottomSheet<String>(
            context: context, builder: (_) => SelectDepartmentScreen(initialSelection: _selectedDepartment),
          );
          if (r != null) setState(() => _selectedDepartment = r);
        }),
        const SizedBox(height: 16),
        _picker('Qualification', _selectedQualification ?? 'Choose qualification', () async {
          final r = await showModalBottomSheet<String>(
            context: context, builder: (_) => SelectQualificationScreen(initialSelection: _selectedQualification),
          );
          if (r != null) setState(() => _selectedQualification = r);
        }),
        const SizedBox(height: 16),
        _textField('Experience (years)', _controllers['experience']!, Icons.work_outline),
        const SizedBox(height: 16),
        _textField('Specialization', _controllers['specialty']!, Icons.star_border),
        const SizedBox(height: 16),
        _textField('License Number', _controllers['licenseNumber']!, Icons.badge_outlined),
      ],
    );
  }

  Widget _stepSecurity() {
    return Column(
      key: const ValueKey('step2'),
      children: [
        _textField('Username', _controllers['username']!, Icons.alternate_email),
        const SizedBox(height: 16),
        _passwordField('Password', _controllers['password']!, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
        const SizedBox(height: 16),
        _passwordField('Repeat Password', _controllers['repeatPassword']!, _obscureRepeatPassword, () => setState(() => _obscureRepeatPassword = !_obscureRepeatPassword)),
      ],
    );
  }

  Widget _textField(String label, TextEditingController controller, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _passwordField(String label, TextEditingController controller, bool obscure, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(onPressed: onToggle, icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _picker(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: TextStyle(color: value.contains('Choose') ? Colors.grey : Colors.black)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _phoneField() {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            final r = await showModalBottomSheet<String>(context: context, builder: (_) => SelectCountryScreen(initialSelection: _selectedPhoneCountry));
            if (r != null) setState(() => _selectedPhoneCountry = r);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
            child: Text(_getPhoneCode(_selectedPhoneCountry)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _textField('Phone Number', _controllers['phone']!, Icons.phone_outlined, type: TextInputType.phone)),
      ],
    );
  }

  Widget _genderPicker() {
    return Row(
      children: [
        _genderCard('Male', Icons.male),
        const SizedBox(width: 16),
        _genderCard('Female', Icons.female),
      ],
    );
  }

  Widget _genderCard(String gender, IconData icon) {
    final isSelected = _formData['gender'] == gender;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _formData['gender'] = gender),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF008394).withOpacity(0.1) : Colors.grey[50],
            border: Border.all(color: isSelected ? const Color(0xFF008394) : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [Icon(icon, color: isSelected ? const Color(0xFF008394) : Colors.grey), Text(gender)]),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => _currentStep > 0 ? setState(() => _currentStep--) : Navigator.pop(context), child: Text(_currentStep > 0 ? 'Back' : 'Cancel'))),
          const SizedBox(width: 16),
          Expanded(child: ElevatedButton(
            onPressed: _isSaving ? null : _handleContinue,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF008394)),
            child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(_currentStep < 2 ? 'Continue' : 'Create'),
          )),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (i) => _stepIndicator(i)),
    );
  }

  Widget _stepIndicator(int index) {
    final isActive = _currentStep >= index;
    return Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: isActive ? const Color(0xFF008394) : Colors.grey, shape: BoxShape.circle),
          child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
        ),
        if (index < 2) Container(width: 40, height: 2, color: _currentStep > index ? const Color(0xFF008394) : Colors.grey),
      ],
    );
  }

  String _getPhoneCode(String country) {
    const Map<String, String> codes = {'United States': '+1', 'Vietnam': '+84', 'United Kingdom': '+44', 'Japan': '+81'};
    return codes[country] ?? '+1';
  }
}
