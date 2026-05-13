import 'dart:typed_data';
import 'package:flutter/foundation.dart';

// Sentinel value to handle setting nullable properties to null in copyWith
// ignore: prefer_const_constructors
final Object _undefined = Object();

class AddDoctorFormState {
  // Step 1: Basic Info
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final Object? _country; // internal nullable field
  final Object? _state;
  final String city;
  final String gender;
  final String? avatarPath;
  final Uint8List? avatarBytes;
  final int avatarSizeInBytes;

  // Step 2: Detail Info
  final String? specialization;  // Department (Cardiology, etc.)
  final String experience;
  final String education;         // Qualification (MBBS, MD, etc.)
  final String licenseNumber;
  final String workingHours;

  // Step 3: Security
  final String username;
  final String password;
  final String repeatPassword;

  String? get country => _country as String?;
  String? get state => _state as String?;

  AddDoctorFormState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    Object? country,
    Object? state,
    this.city = '',
    this.gender = 'Male',
    this.avatarPath,
    this.avatarBytes,
    this.avatarSizeInBytes = 0,
    this.specialization,
    this.experience = '',
    this.education = 'MBBS',
    this.licenseNumber = '',
    this.workingHours = '9AM - 2PM',
    this.username = '',
    this.password = '',
    this.repeatPassword = '',
  })  : _country = country,
        _state = state;

  AddDoctorFormState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    Object? country = const _Unset(),
    Object? state = const _Unset(),
    String? city,
    String? gender,
    Object? avatarPath = const _Unset(),
    Object? avatarBytes = const _Unset(),
    int? avatarSizeInBytes,
    Object? specialization = const _Unset(),
    String? experience,
    String? education,
    String? licenseNumber,
    String? workingHours,
    String? username,
    String? password,
    String? repeatPassword,
  }) {
    return AddDoctorFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      country: country is _Unset ? _country : country,
      state: state is _Unset ? _state : state,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      avatarPath: avatarPath is _Unset ? this.avatarPath : (avatarPath as String?),
      avatarBytes: avatarBytes is _Unset ? this.avatarBytes : (avatarBytes as Uint8List?),
      avatarSizeInBytes: avatarSizeInBytes ?? this.avatarSizeInBytes,
      specialization: specialization is _Unset ? this.specialization : (specialization as String?),
      experience: experience ?? this.experience,
      education: education ?? this.education,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      workingHours: workingHours ?? this.workingHours,
      username: username ?? this.username,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
    );
  }
}

/// Private sentinel class — distinct from null, allows nullable copyWith fields
class _Unset {
  const _Unset();
}

// ─────────────────────────────────────────────────────────────────────────────
// Enum-based constants (no hardcoded rác strings)
// ─────────────────────────────────────────────────────────────────────────────
class DoctorDepartments {
  static const List<String> all = [
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'General Practice',
    'General Surgery',
    'Gynecology',
    'Hematology',
    'Internal Medicine',
    'Nephrology',
    'Neurology',
    'Oncology',
    'Ophthalmology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Pulmonology',
    'Radiology',
    'Rheumatology',
    'Urology',
  ];
}

class DoctorQualifications {
  static const List<String> all = [
    'MBBS',
    'MD',
    'MBBS, MD',
    'DO',
    'MBBS, MS',
    'MS',
    'PhD',
    'MBChB',
    'DM',
    'MCh',
    'DNB',
    'FRCS',
    'MRCP',
    'FACC',
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────
class AddDoctorProvider extends ChangeNotifier {
  AddDoctorFormState _state = AddDoctorFormState();

  AddDoctorFormState get state => _state;

  // --- Step 1 Setters ---
  void setFullName(String v) { _state = _state.copyWith(fullName: v); notifyListeners(); }
  void setEmail(String v) { _state = _state.copyWith(email: v); notifyListeners(); }
  void setPhoneNumber(String v) { _state = _state.copyWith(phoneNumber: v); notifyListeners(); }
  void setAddress(String v) { _state = _state.copyWith(address: v); notifyListeners(); }
  void setCity(String v) { _state = _state.copyWith(city: v); notifyListeners(); }
  void setGender(String v) { _state = _state.copyWith(gender: v); notifyListeners(); }

  void setCountry(String? country) {
    if (_state.country != country) {
      _state = _state.copyWith(country: country, state: null, city: '');
      notifyListeners();
    }
  }

  void setStateName(String? stateName) {
    if (_state.state != stateName) {
      _state = _state.copyWith(state: stateName, city: '');
      notifyListeners();
    }
  }

  void setAvatar({String? path, Uint8List? bytes, int size = 0}) {
    _state = _state.copyWith(avatarPath: path, avatarBytes: bytes, avatarSizeInBytes: size);
    notifyListeners();
  }

  // --- Step 2 Setters ---
  void setSpecialization(String? v) { _state = _state.copyWith(specialization: v); notifyListeners(); }
  void setExperience(String v) { _state = _state.copyWith(experience: v); notifyListeners(); }
  void setEducation(String v) { _state = _state.copyWith(education: v); notifyListeners(); }
  void setLicenseNumber(String v) { _state = _state.copyWith(licenseNumber: v); notifyListeners(); }
  void setWorkingHours(String v) { _state = _state.copyWith(workingHours: v); notifyListeners(); }

  // --- Step 3 Setters ---
  void setUsername(String v) { _state = _state.copyWith(username: v); notifyListeners(); }
  void setPassword(String v) { _state = _state.copyWith(password: v); notifyListeners(); }
  void setRepeatPassword(String v) { _state = _state.copyWith(repeatPassword: v); notifyListeners(); }

  // --- Actions ---
  void reset() {
    _state = AddDoctorFormState();
    notifyListeners();
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  bool validateBasicInfo(void Function(String) onError) {
    if (_state.fullName.trim().isEmpty) {
      onError('Please enter full name'); return false;
    }
    if (_state.email.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
      if (!emailRegex.hasMatch(_state.email.trim())) {
        onError('Please enter a valid email address'); return false;
      }
    }
    if (_state.country == null) { onError('Please select a country'); return false; }
    if (_state.state == null) { onError('Please select a state'); return false; }
    if (_state.city.trim().isEmpty) { onError('Please enter a city'); return false; }
    if (_state.avatarSizeInBytes > 5 * 1024 * 1024) {
      onError('Avatar image size must be less than 5 MB'); return false;
    }
    return true;
  }

  bool validateDetailInfo(void Function(String) onError) {
    if (_state.specialization == null || _state.specialization!.trim().isEmpty) {
      onError('Please choose a department'); return false;
    }
    if (_state.experience.trim().isEmpty) {
      onError('Please enter years of experience'); return false;
    }
    // Experience must contain at least one digit
    if (!RegExp(r'\d').hasMatch(_state.experience)) {
      onError('Experience must contain a number (e.g. "5 years" or "10+ Years")');
      return false;
    }
    if (_state.licenseNumber.trim().isEmpty) {
      onError('License number is required (legal field)'); return false;
    }
    return true;
  }

  bool validateSecurity(void Function(String) onError) {
    if (_state.username.trim().isEmpty) {
      onError('Please enter a username'); return false;
    }
    if (_state.username.trim().length < 4) {
      onError('Username must be at least 4 characters'); return false;
    }
    // username: only alphanumeric + underscore
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(_state.username.trim())) {
      onError('Username can only contain letters, numbers and underscore');
      return false;
    }
    if (_state.password.isEmpty) {
      onError('Please enter a password'); return false;
    }
    if (_state.password.length < 8) {
      onError('Password must be at least 8 characters'); return false;
    }
    if (_state.password != _state.repeatPassword) {
      onError('Passwords do not match'); return false;
    }
    return true;
  }

  /// Real-time password match check used for UI border coloring
  bool get passwordsMatch =>
      _state.repeatPassword.isEmpty || _state.password == _state.repeatPassword;
}
