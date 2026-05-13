import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class AddDoctorFormState {
  // Step 1: Basic Info
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? country;
  final String? state;
  final String city;
  final String gender;
  final String? avatarPath;      // Local file path (mobile)
  final Uint8List? avatarBytes;  // Local file bytes (web/preview)
  final int avatarSizeInBytes;

  // Step 2: Detail Info
  final String? specialization;
  final String experience;
  final String education;
  final String licenseNumber;
  final String workingHours;

  // Step 3: Security
  final String password;
  final String repeatPassword;

  AddDoctorFormState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.country,
    this.state,
    this.city = '',
    this.gender = 'Male',
    this.avatarPath,
    this.avatarBytes,
    this.avatarSizeInBytes = 0,
    this.specialization,
    this.experience = '5+ Years',
    this.education = 'MD degree',
    this.licenseNumber = '',
    this.workingHours = '9AM - 2PM',
    this.password = '',
    this.repeatPassword = '',
  });

  AddDoctorFormState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    Object? country = undefined,
    Object? state = undefined,
    String? city,
    String? gender,
    Object? avatarPath = undefined,
    Object? avatarBytes = undefined,
    int? avatarSizeInBytes,
    String? specialization,
    String? experience,
    String? education,
    String? licenseNumber,
    String? workingHours,
    String? password,
    String? repeatPassword,
  }) {
    return AddDoctorFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      country: country == undefined ? this.country : (country as String?),
      state: state == undefined ? this.state : (state as String?),
      city: city ?? this.city,
      gender: gender ?? this.gender,
      avatarPath: avatarPath == undefined ? this.avatarPath : (avatarPath as String?),
      avatarBytes: avatarBytes == undefined ? this.avatarBytes : (avatarBytes as Uint8List?),
      avatarSizeInBytes: avatarSizeInBytes ?? this.avatarSizeInBytes,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      workingHours: workingHours ?? this.workingHours,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
    );
  }
}

// Sentinel value to handle setting nullable properties to null in copyWith
const Object? undefined = Object();

class AddDoctorProvider extends ChangeNotifier {
  AddDoctorFormState _state = AddDoctorFormState();

  AddDoctorFormState get state => _state;

  // --- Step 1 Setters ---
  void setFullName(String value) {
    _state = _state.copyWith(fullName: value);
    notifyListeners();
  }

  void setEmail(String value) {
    _state = _state.copyWith(email: value);
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _state = _state.copyWith(phoneNumber: value);
    notifyListeners();
  }

  void setAddress(String value) {
    _state = _state.copyWith(address: value);
    notifyListeners();
  }

  void setCountry(String? country) {
    // Cascading Dropdown: If country changes, automatically clear state and city
    if (_state.country != country) {
      _state = _state.copyWith(
        country: country,
        state: null, // Clear state
        city: '',    // Clear city
      );
      notifyListeners();
    }
  }

  void setStateName(String? stateName) {
    if (_state.state != stateName) {
      _state = _state.copyWith(
        state: stateName,
        city: '', // Clear city as state changed
      );
      notifyListeners();
    }
  }

  void setCity(String value) {
    _state = _state.copyWith(city: value);
    notifyListeners();
  }

  void setGender(String value) {
    _state = _state.copyWith(gender: value);
    notifyListeners();
  }

  void setAvatar({String? path, Uint8List? bytes, int size = 0}) {
    _state = _state.copyWith(
      avatarPath: path,
      avatarBytes: bytes,
      avatarSizeInBytes: size,
    );
    notifyListeners();
  }

  // --- Step 2 Setters ---
  void setSpecialization(String value) {
    _state = _state.copyWith(specialization: value);
    notifyListeners();
  }

  void setExperience(String value) {
    _state = _state.copyWith(experience: value);
    notifyListeners();
  }

  void setEducation(String value) {
    _state = _state.copyWith(education: value);
    notifyListeners();
  }

  void setLicenseNumber(String value) {
    _state = _state.copyWith(licenseNumber: value);
    notifyListeners();
  }

  void setWorkingHours(String value) {
    _state = _state.copyWith(workingHours: value);
    notifyListeners();
  }

  // --- Step 3 Setters ---
  void setPassword(String value) {
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  void setRepeatPassword(String value) {
    _state = _state.copyWith(repeatPassword: value);
    notifyListeners();
  }

  // --- Actions ---
  void reset() {
    _state = AddDoctorFormState();
    notifyListeners();
  }

  // Helper validation methods
  bool validateBasicInfo(void Function(String) onError) {
    if (_state.fullName.trim().isEmpty) {
      onError('Please enter full name');
      return false;
    }
    if (_state.email.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_state.email.trim())) {
        onError('Please enter a valid email address');
        return false;
      }
    }
    if (_state.country == null) {
      onError('Please select a country');
      return false;
    }
    if (_state.state == null) {
      onError('Please select a state');
      return false;
    }
    if (_state.city.trim().isEmpty) {
      onError('Please enter a city');
      return false;
    }
    if (_state.avatarSizeInBytes > 5 * 1024 * 1024) {
      onError('Avatar image size must be less than 5 MB');
      return false;
    }
    return true;
  }
}
