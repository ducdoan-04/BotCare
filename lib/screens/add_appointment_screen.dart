import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  int _currentStep = 0; // 0: Basic Info, 1: Detail Info
  String _selectedGender = 'Male';
  String? _selectedSpecialist;
  String? _selectedDoctor;
  String? _selectedTime;
  DateTime? _selectedDate;

  final List<String> _timeSlots = [
    '08.00:AM', '08.30:AM', '09.00:AM', '09.30:AM',
    '10.00:AM', '10.30:AM', '11.30:AM', '12.00:PM',
    '02.00:PM', '02.30:PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add new appointment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // --- CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- STEPPER ---
                  _buildStepper(),
                  const SizedBox(height: 32),

                  if (_currentStep == 0) ...[
                    // --- STEP 1: BASIC INFO ---
                    _buildTextField(hintText: 'Enter full name'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter age'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter email address'),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Enter address'),
                    const SizedBox(height: 24),
                    const Text(
                      'Gender',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildGenderCard('Male', Icons.face)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildGenderCard('Female', Icons.face_3)),
                      ],
                    ),
                  ] else ...[
                    // --- STEP 2: DETAIL INFO ---
                    _buildDropdownField(
                      _selectedSpecialist ?? 'Choose specialist',
                      isSelected: _selectedSpecialist != null,
                      onTap: () => _showOptionsSheet(
                        'Specialist',
                        ['General Practitioners', 'Cardiology', 'Dermatology', 'Neurology', 'Pediatrics', 'Orthopedics', 'Ophthalmology'],
                        _selectedSpecialist,
                        (val) => setState(() => _selectedSpecialist = val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      _selectedDoctor ?? 'Choose doctor',
                      isSelected: _selectedDoctor != null,
                      onTap: () => _showOptionsSheet(
                        'Choose doctor',
                        ['Dr. Courtney Henry', 'Dr. Jane Cooper', 'Dr. Raj Patel'],
                        _selectedDoctor,
                        (val) => setState(() => _selectedDoctor = val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 24),
                    const Text(
                      'Choose Time',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _timeSlots.map((time) => _buildTimeChip(time)).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(hintText: 'Enter treatment'),
                    const SizedBox(height: 16),
                    _buildTextField(hintText: 'Notes here...', maxLines: 4),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // --- FOOTER BUTTONS ---
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep == 0) {
                        Navigator.pop(context);
                      } else {
                        setState(() => _currentStep = 0);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.primary),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep == 0 ? 'Cancel' : 'Back',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep = 1);
                      } else {
                        _showSuccessDialog();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _currentStep == 0 ? 'Continue' : 'Save',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Basic Info',
              style: TextStyle(
                color: _currentStep >= 0 ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: _currentStep >= 0 ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            Text(
              'Detail Info',
              style: TextStyle(
                color: _currentStep >= 1 ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: _currentStep >= 1 ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(height: 4, width: double.infinity, color: AppColors.background),
            Positioned(
              left: 0,
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width * (_currentStep == 0 ? 0.05 : 0.8),
                color: AppColors.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator(0),
                _buildStepIndicator(1),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepIndicator(int step) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primary : (isActive ? AppColors.primaryLight : Colors.white),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: isCompleted ? 0 : 1),
      ),
      child: Icon(
        isCompleted ? Icons.check : (step == 0 ? Icons.person : Icons.assignment),
        size: 16,
        color: isCompleted ? Colors.white : AppColors.primary,
      ),
    );
  }

  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 15),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.flag, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('USD', style: TextStyle(fontWeight: FontWeight.w500)), // Matches design "USD" text
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
          Container(width: 1, height: 24, color: AppColors.border),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Input phone number',
                hintStyle: TextStyle(color: AppColors.textLight, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? AppColors.primary : AppColors.textLight),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, {required VoidCallback onTap, bool isSelected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hint,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.textLight,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const list = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return "${list[date.month - 1]} ${date.day}, ${date.year}";
  }

  Widget _buildDateField() {
    bool isSelected = _selectedDate != null;
    return GestureDetector(
      onTap: () => _showDatePickerSheet(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isSelected ? _formatDate(_selectedDate!) : 'Choose date',
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.textLight,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              )
            ),
            const Icon(Icons.calendar_month_outlined, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    bool isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showOptionsSheet(
    String title,
    List<String> options,
    String? current,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SpecialistPickerSheet(
        title: title,
        options: options,
        current: current,
        onSelect: onSelect,
      ),
    );
  }



  void _showDatePickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DatePickerSheet(
        current: _selectedDate,
        onSelect: (date) {
            setState(() => _selectedDate = date);
        },
      ),
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
              const Text('Success', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Appointment scheduled successfully!', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Dialog
                  Navigator.pop(context); // Sheet
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(double.infinity, 50)),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Picker Sheet — matches Figma "Specialist" design
// ─────────────────────────────────────────────
class _SpecialistPickerSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? current;
  final Function(String) onSelect;

  const _SpecialistPickerSheet({
    required this.title,
    required this.options,
    required this.current,
    required this.onSelect,
  });

  @override
  State<_SpecialistPickerSheet> createState() => _SpecialistPickerSheetState();
}

class _SpecialistPickerSheetState extends State<_SpecialistPickerSheet> {
  late String? _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        size: 18, color: Color(0xFF1A1A2E)),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFFF2F4F7), height: 1),

          // Options list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.options.length,
            separatorBuilder: (_, __) => const Divider(
                color: Color(0xFFF2F4F7), height: 1, indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final opt = widget.options[index];
              final isSelected = _tempSelected == opt;
              return InkWell(
                onTap: () => setState(() => _tempSelected = opt),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opt,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF008394)
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                      isSelected
                          ? Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF008394),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  size: 14, color: Colors.white),
                            )
                          : Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFD0D5DD), width: 1.5),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

          // Choose button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: GestureDetector(
              onTap: () {
                if (_tempSelected != null) {
                  widget.onSelect(_tempSelected!);
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _tempSelected != null
                      ? const Color(0xFF008394)
                      : const Color(0xFFB0BEC5),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Choose',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Date Picker Sheet — matches Figma "Visit date"
// ─────────────────────────────────────────────
class _DatePickerSheet extends StatefulWidget {
  final DateTime? current;
  final Function(DateTime) onSelect;

  const _DatePickerSheet({required this.current, required this.onSelect});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime? _tempDate;
  final ScrollController _scrollController = ScrollController();
  
  // Create a list of 12 months starting from current month
  late List<DateTime> _months;

  @override
  void initState() {
    super.initState();
    _tempDate = widget.current;
    
    // Generate current month + next 11 months
    DateTime now = DateTime.now();
    _months = List.generate(12, (index) {
        int year = now.year + (now.month + index - 1) ~/ 12;
        int month = (now.month + index - 1) % 12 + 1;
        return DateTime(year, month, 1);
    });
  }
  
  String _formatFullDate(DateTime? date) {
      if (date == null) return "Not selected";
      const list = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      return "${list[date.month - 1]} ${date.day}, ${date.year}";
  }
  
  String _getMonthName(int month) {
      const list = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      return list[month - 1];
  }

  int _getDaysInMonth(int year, int month) {
      if (month == 2) {
          bool isLeapYear = (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
          return isLeapYear ? 29 : 28;
      }
      const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      return days[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF1A1A2E)),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Visit date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(color: Color(0xFFF2F4F7), height: 1),
          
          // Calendar List
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _months.length,
                  itemBuilder: (context, index) {
                      return _buildMonthGrid(_months[index]);
                  },
              )
          ),
          
          const Divider(color: Color(0xFFF2F4F7), height: 1),
          
          // Footer Selection
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Row(
                children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                const Text("Visit date:", style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(_formatFullDate(_tempDate), style: const TextStyle(color: Color(0xFFA0A5A9), fontSize: 13)),
                            ],
                        ),
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                                if (_tempDate != null) {
                                    widget.onSelect(_tempDate!);
                                    Navigator.pop(context);
                                }
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                    color: _tempDate != null ? const Color(0xFF008394) : const Color(0xFFB0BEC5),
                                    borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                    'Choose',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                    ),
                                ),
                            ),
                        ),
                    ),
                ]
            ),
          ),
        ]
      ),
    );
  }
  
  Widget _buildMonthGrid(DateTime monthDate) {
      int year = monthDate.year;
      int month = monthDate.month;
      
      int daysInThisMonth = _getDaysInMonth(year, month);
      int firstDayOfWeek = DateTime(year, month, 1).weekday; // 1 = Monday, 7 = Sunday
      
      // Calculate days in previous month for padding
      int prevMonth = month == 1 ? 12 : month - 1;
      int prevYear = month == 1 ? year - 1 : year;
      int daysInPrevMonth = _getDaysInMonth(prevYear, prevMonth);
      
      // Days to show from previous month
      int paddingStart = firstDayOfWeek - 1; 
      
      // Total grid cells needed (rows * 7)
      int totalCells = paddingStart + daysInThisMonth;
      int rows = (totalCells / 7).ceil();
      if (totalCells % 7 != 0) rows++; // Fix for partial last row
      totalCells = rows * 7;
      
      List<Widget> dayWidgets = [];
      
      for (int i = 0; i < totalCells; i++) {
          if (i < paddingStart) {
              // Previous month days
              int day = daysInPrevMonth - paddingStart + 1 + i;
              dayWidgets.add(_buildDayCell(day, isCurrentMonth: false, fullDate: null));
          } else if (i < paddingStart + daysInThisMonth) {
              // Current month days
              int day = i - paddingStart + 1;
              DateTime currentDate = DateTime(year, month, day);
              
              bool isSelected = _tempDate != null && 
                  _tempDate!.year == currentDate.year &&
                  _tempDate!.month == currentDate.month &&
                  _tempDate!.day == currentDate.day;
                  
              dayWidgets.add(_buildDayCell(day, isCurrentMonth: true, isSelected: isSelected, fullDate: currentDate));
          } else {
              // Next month days
              int day = i - (paddingStart + daysInThisMonth) + 1;
              dayWidgets.add(_buildDayCell(day, isCurrentMonth: false, fullDate: null));
          }
      }
      
      return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                      "${_getMonthName(month)} $year",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF1A1A2E))
                  ),
                  const SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].map((d) {
                          return Expanded(
                              child: Center(
                                  child: Text(d, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)))
                              )
                          );
                      }).toList(),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                      crossAxisCount: 7,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.0,
                      children: dayWidgets,
                  ),
              ],
          ),
      );
  }
  
  Widget _buildDayCell(int day, {required bool isCurrentMonth, bool isSelected = false, DateTime? fullDate}) {
      return GestureDetector(
          onTap: () {
              if (isCurrentMonth && fullDate != null) {
                  setState(() => _tempDate = fullDate);
              }
          },
          child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF008394) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                  day.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : (isCurrentMonth ? FontWeight.w500 : FontWeight.normal),
                      color: isSelected ? Colors.white : (isCurrentMonth ? const Color(0xFF1A1A2E) : const Color(0xFFA0A5A9))
                  )
              ),
          ),
      );
  }
}
