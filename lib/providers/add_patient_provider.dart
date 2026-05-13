import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/patient.dart';
import '../models/doctor_model.dart';
import '../repositories/doctor_repository.dart';

class AddPatientFormState {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? country;
  final String? state;
  final String city;
  final Uint8List? avatarBytes;
  final String? avatarPath;

  final String? bloodType;
  final String? allergies;
  final String? specialistDepartment;
  final String? assignedDoctorId;
  final String status;
  final DateTime? appointmentDate;

  AddPatientFormState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
    this.country,
    this.state,
    this.city = '',
    this.avatarBytes,
    this.avatarPath,
    this.bloodType,
    this.allergies = '',
    this.specialistDepartment,
    this.assignedDoctorId,
    this.status = 'Under Treatment',
    this.appointmentDate,
  });

  AddPatientFormState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? country,
    String? state,
    String? city,
    Uint8List? avatarBytes,
    String? avatarPath,
    String? bloodType,
    String? allergies,
    String? specialistDepartment,
    String? assignedDoctorId,
    String? status,
    DateTime? appointmentDate,
  }) {
    return AddPatientFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      avatarPath: avatarPath ?? this.avatarPath,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      specialistDepartment: specialistDepartment ?? this.specialistDepartment,
      assignedDoctorId: assignedDoctorId ?? this.assignedDoctorId,
      status: status ?? this.status,
      appointmentDate: appointmentDate ?? this.appointmentDate,
    );
  }
}

class AddPatientProvider with ChangeNotifier {
  AddPatientFormState _state = AddPatientFormState();
  AddPatientFormState get state => _state;

  final DoctorRepository _doctorRepo = DoctorRepository();
  List<Doctor> _availableDoctors = [];
  List<Doctor> get availableDoctors => _availableDoctors;
  bool _isLoadingDoctors = false;
  bool get isLoadingDoctors => _isLoadingDoctors;

  // --- Step 1 Setters ---
  void setFullName(String v) { _state = _state.copyWith(fullName: v); notifyListeners(); }
  void setEmail(String v) { _state = _state.copyWith(email: v); notifyListeners(); }
  void setPhoneNumber(String v) { _state = _state.copyWith(phoneNumber: v); notifyListeners(); }
  void setAddress(String v) { _state = _state.copyWith(address: v); notifyListeners(); }
  void setCountry(String v) { _state = _state.copyWith(country: v); notifyListeners(); }
  void setStateName(String v) { _state = _state.copyWith(state: v); notifyListeners(); }
  void setCity(String v) { _state = _state.copyWith(city: v); notifyListeners(); }
  void setAvatar({String? path, Uint8List? bytes}) {
    _state = _state.copyWith(avatarPath: path, avatarBytes: bytes);
    notifyListeners();
  }

  // --- Step 2 Setters ---
  void setBloodType(String v) { _state = _state.copyWith(bloodType: v); notifyListeners(); }
  void setAllergies(String v) { _state = _state.copyWith(allergies: v); notifyListeners(); }
  
  // CASCADING LOGIC: setSpecialistDepartment triggers doctor fetch
  void setSpecialistDepartment(String v) async {
    _state = _state.copyWith(specialistDepartment: v, assignedDoctorId: null); // Reset doctor
    notifyListeners();
    
    _isLoadingDoctors = true;
    notifyListeners();
    
    try {
      _availableDoctors = await _doctorRepo.fetchDoctors(specialty: v);
    } catch (e) {
      print('Error fetching doctors for department $v: $e');
      _availableDoctors = [];
    } finally {
      _isLoadingDoctors = false;
      notifyListeners();
    }
  }

  void setAssignedDoctorId(String v) { _state = _state.copyWith(assignedDoctorId: v); notifyListeners(); }
  void setStatus(String v) { _state = _state.copyWith(status: v); notifyListeners(); }
  void setAppointmentDate(DateTime v) { _state = _state.copyWith(appointmentDate: v); notifyListeners(); }

  void reset() {
    _state = AddPatientFormState();
    _availableDoctors = [];
    notifyListeners();
  }

  void initWithExistingPatient(Patient p) {
    _state = AddPatientFormState(
      fullName: p.fullName,
      email: p.email ?? '',
      phoneNumber: p.phone ?? '',
      address: p.address ?? '',
      country: p.country,
      state: p.state,
      city: p.city ?? '',
      bloodType: p.bloodType,
      allergies: p.allergies ?? '',
      specialistDepartment: p.specialistDepartment,
      assignedDoctorId: p.assignedDoctorId,
      status: p.status,
      // registered_at is usually read-only, but we map it to appointmentDate if needed for UI display
    );
    
    // If we have a department, fetch doctors immediately
    if (p.specialistDepartment != null) {
      setSpecialistDepartment(p.specialistDepartment!);
    }
    
    notifyListeners();
  }

  // Validation
  bool validateBasicInfo(Function(String) onError) {
    if (_state.fullName.trim().isEmpty) { onError('Full name is required'); return false; }
    return true;
  }

  bool validateDetailInfo(Function(String) onError) {
    if (_state.specialistDepartment == null) { onError('Please choose a specialist department'); return false; }
    if (_state.assignedDoctorId == null) { onError('Please choose a doctor'); return false; }
    return true;
  }
}
