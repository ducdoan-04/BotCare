import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/doctor_model.dart';

class SharedDetailInfoForm extends StatelessWidget {
  final TextEditingController allergiesController;
  final String? bloodType;
  final String? specialistDepartment;
  final String? assignedDoctorId;
  final String status;
  final DateTime? appointmentDate;
  final List<Doctor> availableDoctors;
  final bool isLoadingDoctors;

  final Function(String) onBloodTypeChanged;
  final Function(String) onAllergiesChanged;
  final Function(String) onDepartmentChanged;
  final Function(String) onDoctorChanged;
  final Function(String) onStatusChanged;
  final Function(DateTime) onDateChanged;

  const SharedDetailInfoForm({
    super.key,
    required this.allergiesController,
    this.bloodType,
    this.specialistDepartment,
    this.assignedDoctorId,
    required this.status,
    this.appointmentDate,
    required this.availableDoctors,
    this.isLoadingDoctors = false,
    required this.onBloodTypeChanged,
    required this.onAllergiesChanged,
    required this.onDepartmentChanged,
    required this.onDoctorChanged,
    required this.onStatusChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BLOOD TYPE ---
        _buildDropdown(
          label: 'Blood type',
          value: bloodType,
          items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
          onChanged: onBloodTypeChanged,
          hint: 'Select blood type',
        ),
        const SizedBox(height: 16),

        // --- ALLERGIES ---
        _buildTextField(
          hintText: 'Enter allergies (e.g. Penicillin, Pollen)',
          controller: allergiesController,
          onChanged: onAllergiesChanged,
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        // --- SPECIALIST DEPARTMENT ---
        _buildDropdown(
          label: 'Specialist Department',
          value: specialistDepartment,
          items: ['General Practitioner', 'Cardiology', 'Dermatology', 'Pediatrics', 'Neurology', 'Hematology', 'Gynecology'],
          onChanged: onDepartmentChanged,
          hint: 'Choose department',
        ),
        const SizedBox(height: 16),

        // --- ASSIGNED DOCTOR ---
        isLoadingDoctors
            ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()))
            : _buildDropdown(
                label: 'Assigned Doctor',
                value: assignedDoctorId,
                items: availableDoctors.map((d) => d.id).toList(),
                itemLabels: availableDoctors.map((d) => "${d.fullName} (${d.specialization} - ${d.experience})").toList(),
                onChanged: onDoctorChanged,
                hint: 'Choose doctor',
              ),
        const SizedBox(height: 16),

        // --- STATUS ---
        _buildDropdown(
          label: 'Status',
          value: status,
          items: ['Inpatient', 'Outpatient', 'Discharged', 'Under Treatment', 'Recovered'],
          onChanged: onStatusChanged,
          hint: 'Select status',
        ),
        const SizedBox(height: 16),

        // --- DATE PICKER ---
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointmentDate != null 
                      ? DateFormat('MMMM dd, yyyy').format(appointmentDate!) 
                      : 'Choose date',
                  style: TextStyle(
                    color: appointmentDate != null ? AppColors.textPrimary : const Color(0xFFA0A5A9),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, color: Color(0xFFA0A5A9), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: appointmentDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF008394),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    List<String>? itemLabels,
    required Function(String) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 15)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA0A5A9)),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: items.asMap().entries.map((entry) {
            final idx = entry.key;
            final val = entry.value;
            final text = itemLabels != null ? itemLabels[idx] : val;
            return DropdownMenuItem<String>(
              value: val,
              child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
