import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'select_country_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedTab = 0; // 0: Appearance, 1: Account, 2: Notification, 3: API

  // Form states for API tab
  int _apiAccessGroup = 0; // 0 for Enabled, 1 for Disabled
  String _apiDropdownVal = 'Never';

  // Toggle states
  bool _emailNoti = true;
  bool _inAppNoti = true;
  bool _newChatNoti = false;
  bool _apptNoti = false;
  bool _systemNoti = false;

  bool _twoStepVeri = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .white, // In Figma background looks totally white or very similar
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildTabsRow(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSelectedTabContent(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back,
                  size: 20, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Settings',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTabButton('Appearance', 0),
          const SizedBox(width: 12),
          _buildTabButton('Account', 1),
          const SizedBox(width: 12),
          _buildTabButton('Notification', 2),
          const SizedBox(width: 12),
          _buildTabButton('API & Integration', 3),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
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
          color:
              isSelected ? const Color(0xFF0F172A) : Colors.transparent, // dark
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0F172A) : const Color(0xFFDCDFE3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildAppearanceTab();
      case 1:
        return _buildAccountTab();
      case 2:
        return _buildNotificationTab();
      case 3:
        return _buildApiTab();
      default:
        return const SizedBox();
    }
  }

  // ============== TAB 1: APPEARANCE ==============

  Widget _buildAppearanceTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Appearance',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text('Change how your dashboard looks and feels',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0), thickness: 1), // Light border
        const SizedBox(height: 24),
        const Text('Display Preferences',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Switch between light & dark mode.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildLightModeCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildDarkModeCard()),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Theme',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Choose prefered theme for the app.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildThemeColorCircle(const Color(0xFFD94625), false),
            const SizedBox(width: 12),
            _buildThemeColorCircle(const Color(0xFFEAB308), false),
            const SizedBox(width: 12),
            _buildThemeColorCircle(const Color(0xFF10B981), false),
            const SizedBox(width: 12),
            _buildThemeColorCircle(const Color(0xFF2563EB), false),
            const SizedBox(width: 12),
            _buildThemeColorCircle(
                const Color(0xFF06B6D4), false), // light blue
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Custom',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            _buildThemeColorCircle(AppColors.primary, true), // Teal chosen
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('#2B82FF',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
            )
          ],
        ),
        const SizedBox(height: 32),
        const Text('Language & Region',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text(
            'Choose prefered theme for the app.', // Kept the typo from img
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        _buildDropdownSetting(
          '',
          _selectedLanguage,
          iconWidget: _buildFlag(_selectedLanguage),
          onTap: () async {
            final result = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SelectCountryScreen(
                  initialSelection: _selectedLanguage == 'English'
                      ? 'United States'
                      : _selectedLanguage),
            );
            if (result != null) {
              setState(() {
                _selectedLanguage = result;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownSetting('🌐', 'UTC +07:00 - Asia / Jakarta'),
      ],
    );
  }

  Widget _buildFlag(String country) {
    if (country == 'English') country = 'United States';
    String assetName = country.toLowerCase().replaceAll(' ', '_');
    if (country == 'Uzbekistan') {
      assetName = 'uzbekistan'; // Match spelling in assets
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('images/flags/Nation=$assetName.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDropdownSetting(String emoji, String text,
      {VoidCallback? onTap, Widget? iconWidget}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              const SizedBox(width: 16),
            ] else if (emoji.isNotEmpty) ...[
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLightModeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F2F4), // Light teal background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(height: 16),
          // Window mock
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Button',
                        style: TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.light_mode_outlined,
                  color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text('Light Mode',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDarkModeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCDFE3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle_outlined, color: Color(0xFFDCDFE3), size: 20),
          const SizedBox(height: 16),
          // Window mock dark
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Button',
                        style: TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.dark_mode, color: AppColors.textPrimary, size: 16),
              SizedBox(width: 8),
              Text('Dark Mode',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildThemeColorCircle(Color color, bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.grey.shade400, width: 2)
            : null,
      ),
    );
  }

  // ============== TAB 2: ACCOUNT INFO ==============

  Widget _buildAccountTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Account Info',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
            'Manage your personal details and secure your\nlogin credentials.',
            style: TextStyle(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0), thickness: 1), // Light border
        const SizedBox(height: 24),
        const Text('Profil Picture',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Upload a photo so your team can recognize you.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'images/avatars/avatar-1.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 60, height: 60, color: Colors.grey.shade200),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                      ),
                      child: const Text('Change Image',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('We support JPG & PNG under 2MB',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 32),
        const Text('Email',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Used for login and receiving notifications.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: 'nola.hawkins@gmail.com',
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
          ),
          style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 32),
        const Text('2-Step Verifications',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Add an additional layer of security to your account',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Switch(
          value: _twoStepVeri,
          onChanged: (val) {
            setState(() {
              _twoStepVeri = val;
            });
          },
          activeColor: AppColors.primary,
        ),
        const SizedBox(height: 32),
        const Text('Delete My Account',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Permanently delete the account',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD94625), // Red
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Delete Account',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // ============== TAB 3: NOTIFICATION ==============

  Widget _buildNotificationTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Notification',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
            'Control how and when you receive updates from\nthe platform.',
            style: TextStyle(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0), thickness: 1),
        const SizedBox(height: 24),
        _buildNotificationSetting(
            'Email Notifications',
            'Stay informed via email about important activities\nand updates.',
            _emailNoti,
            (v) => setState(() => _emailNoti = v)),
        const SizedBox(height: 24),
        _buildNotificationSetting(
            'In-App Notifications',
            'Instant alerts within the app to help you stay on\ntop of things.',
            _inAppNoti,
            (v) => setState(() => _inAppNoti = v)),
        const SizedBox(height: 24),
        _buildNotificationSetting(
            'New Chat Messages',
            'Get notified when someone sends you a message.',
            _newChatNoti,
            (v) => setState(() => _newChatNoti = v)),
        const SizedBox(height: 24),
        _buildNotificationSetting(
            'Appointment Changes',
            'Be alerted if an appointment is updated or\ncanceled.',
            _apptNoti,
            (v) => setState(() => _apptNoti = v)),
        const SizedBox(height: 24),
        _buildNotificationSetting(
            'System Warnings',
            'Important system-related alerts that may need\nyour attention.',
            _systemNoti,
            (v) => setState(() => _systemNoti = v)),
      ],
    );
  }

  Widget _buildNotificationSetting(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
        const SizedBox(height: 12),
        Transform.scale(
          scale: 0.9,
          alignment: Alignment.centerLeft,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFDCDFE3),
          ),
        ),
      ],
    );
  }

  // ============== TAB 4: API & INTEGRATION ==============

  Widget _buildApiTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('API & Integration',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
            'Connect your system to third-party services and\nmanage developer access.',
            style: TextStyle(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFE2E8F0), thickness: 1),
        const SizedBox(height: 24),
        const Text('API Access',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Enable or disable API access for your account.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        const Text(
            'API Access (Allow developers to fetch or update data via API endpoints)',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildCustomRadio(0, 'Enabled'),
            const SizedBox(width: 24),
            _buildCustomRadio(1, 'Disabled'),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'pk_live_239c-xxxxxx-xxxx',
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            suffixIcon:
                const Icon(Icons.copy, size: 20, color: AppColors.textPrimary),
          ),
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        _buildDropdownSetting('', 'Never'), // No emoji here
        const SizedBox(height: 32),
        const Text('Third-Party Integrations',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text(
            'Connect popular platforms to extend your system\nfunctionality.',
            style: TextStyle(
                fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
        const SizedBox(height: 24),
        _buildIntegrationItem(
          icon: Icons.calendar_today,
          iconColor: const Color(0xFF4285F4),
          title: 'Google Calendar',
          subtitle: 'Sync appointments to personal or team calendar.',
        ),
        const SizedBox(height: 24),
        _buildIntegrationItem(
          icon: Icons.tag,
          iconColor: const Color(0xFFE01E5A),
          title: 'Slack Notifications',
          subtitle: 'Receive booking updates directly in your Slack\nchannel',
        ),
        const SizedBox(height: 24),
        _buildIntegrationItem(
          icon: Icons.bolt,
          iconColor: const Color(0xFFFF4F00),
          title: 'Zapier',
          subtitle: 'Automate workflows without writing code.',
        ),
      ],
    );
  }

  Widget _buildCustomRadio(int value, String label) {
    bool isSelected = _apiAccessGroup == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _apiAccessGroup = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFDCDFE3),
                width: isSelected ? 6 : 1.5,
              ),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildIntegrationItem(
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 32),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                side: const BorderSide(color: AppColors.primary, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('Connect',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 42,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Cancel',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Save Changes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
