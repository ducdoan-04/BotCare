import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

void showUpdateAccountBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const UpdateAccountSheet(),
  );
}

class UpdateAccountSheet extends StatefulWidget {
  const UpdateAccountSheet({super.key});

  @override
  State<UpdateAccountSheet> createState() => _UpdateAccountSheetState();
}

class _UpdateAccountSheetState extends State<UpdateAccountSheet> {
  int _selectedTab = 0; // 0: Basic Info, 1: Detail Info

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
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Update account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 20),
          
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTab('Basic Info', 0),
                const SizedBox(width: 8),
                _buildTab('Detail Info', 1),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _selectedTab == 0 ? _buildBasicInfo() : _buildDetailInfo(),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF007A8A), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF007A8A), fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF007A8A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Save Change', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF6F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF007A8A) : const Color(0xFFDCDFE3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF007A8A) : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Ralph Edwards'),
        const SizedBox(height: 16),
        _buildTextField('November 28, 2015', icon: Icons.calendar_today_outlined),
        const SizedBox(height: 16),
        _buildTextField('ralph.edwards@gmail.com'),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Text('🇺🇸 USD', style: TextStyle(fontSize: 15, color: AppColors.textPrimary)),
                  SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField('(217) 555-0113')),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('2118 Thornridge Cir. Syracuse, Connecticut 35624'),
        const SizedBox(height: 24),
        const Text('Gender', style: TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGenderCard('Male', Icons.face, true)),
            const SizedBox(width: 16),
            Expanded(child: _buildGenderCard('Female', Icons.face_4, false)),
          ],
        )
      ],
    );
  }

  Widget _buildDetailInfo() {
    return Column(
      children: [
        _buildTextField('February 9, 2015', icon: Icons.calendar_today_outlined),
        const SizedBox(height: 16),
        _buildTextField('Pharmacist', icon: Icons.keyboard_arrow_down),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('US', icon: Icons.keyboard_arrow_down)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Alabama', icon: Icons.keyboard_arrow_down)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Birmingham')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('B1 1BD')),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Johan is a dedicated and detail-oriented pharmacist with over 6 years of experience in both clinical and retail pharmacy settings.',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          if (icon != null) Icon(icon, color: AppColors.textPrimary, size: 20),
        ],
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEEF6F7) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFF007A8A) : const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: isSelected ? const Color(0xFF007A8A) : AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFF007A8A) : AppColors.textSecondary)),
        ],
      ),
    );
  }
}
