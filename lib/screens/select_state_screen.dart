import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/location_service.dart';

class SelectStateScreen extends StatefulWidget {
  final String country;
  final String initialSelection;

  const SelectStateScreen({
    super.key,
    this.country = 'United States',
    this.initialSelection = '',
  });

  @override
  State<SelectStateScreen> createState() => _SelectStateScreenState();
}

class _SelectStateScreenState extends State<SelectStateScreen> {
  late String _selectedState;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;
  List<String> _states = [];

  @override
  void initState() {
    super.initState();
    _selectedState = widget.initialSelection;
    _states = LocationService.getStatesForCountry(widget.country);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  List<String> get _filteredStates {
    if (_searchQuery.isEmpty) return _states;
    return _states
        .where((st) => st.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F4F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'State',
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
                // Search Bar with actual interactive TextField & Debouncing
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: const InputDecoration(
                              hintText: 'Search state...',
                              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            child: const Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
                          ),
                      ],
                    ),
                  ),
                ),

                // State List
                Expanded(
                  child: _states.isEmpty
                      ? const Center(
                          child: Text(
                            'Please select country first',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        )
                      : _filteredStates.isEmpty
                          ? const Center(
                              child: Text(
                                'No states found',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _filteredStates.length,
                              separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 1),
                              itemBuilder: (context, index) {
                                final stateName = _filteredStates[index];
                                final isSelected = stateName == _selectedState;

                                return InkWell(
                                  onTap: () {
                                    setState(() => _selectedState = stateName);
                                    Navigator.pop(context, stateName);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            stateName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isSelected ? const Color(0xFF008394) : AppColors.textSecondary,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle, color: Color(0xFF008394), size: 24)
                                        else
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: AppColors.border, width: 2),
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
              onTap: () => Navigator.pop(context, _selectedState),
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
}
