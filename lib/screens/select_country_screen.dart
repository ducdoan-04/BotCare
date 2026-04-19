import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SelectCountryScreen extends StatefulWidget {
  final String initialSelection;

  const SelectCountryScreen(
      {super.key, this.initialSelection = 'United States'});

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  late String _selectedCountry;

  final List<String> _countries = [
    'China',
    'India',
    'Indonesia',
    'Japan',
    'Malaysia',
    'Philippines',
    'Singapore',
    'South Korea',
    'Thailand',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Venezuela',
    'Vietnam',
    'Wales',
    'Yemen',
    'Zambia',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialSelection;
  }

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
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        size: 20, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Country',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // --- CONTENT ---
          Expanded(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        const Text(
                          'Search country...',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),

                // Country List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _countries.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: AppColors.border, height: 1),
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      final isSelected = country == _selectedCountry;

                      return InkWell(
                        onTap: () => setState(() => _selectedCountry = country),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              _buildFlag(country),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  country,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? const Color(0xFF008394)
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: Color(0xFF008394), size: 24)
                              else
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.border, width: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- FOOTER ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () => Navigator.pop(context, _selectedCountry),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF008394),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Choose',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

  Widget _buildFlag(String country) {
    String assetName = country.toLowerCase().replaceAll(' ', '_');
    if (country == 'Uzbekistan') {
      assetName = 'uzbekistan'; // Match spelling in assets
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('images/flags/Nation=$assetName.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
