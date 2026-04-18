import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading time (e.g. fetching config or auth state)
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Logo ở trung tâm
          Center(
            child: Image.asset(
              'images/logo/logo-v1.png',
              width: 250,
              fit: BoxFit.contain,
            ),
          ),
          
          // Hiệu ứng Loading và Text Version
          Positioned(
            left: 0,
            right: 0,
            bottom: 48, // Đẩy lên một chút để chừa chỗ cho chữ
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    color: AppColors.primary, // Teal
                    strokeWidth: 3.5,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Version 1.0.1',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF90A4AE), // Light gray-blue string
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
