import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top: Hero Image Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom:
                MediaQuery.of(context).size.height * 0.4, // Cover upper portion
            child: Image.asset(
              'images/screens/login.jpg',
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Bottom: Bottom Sheet overlaying the image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Hug content vertically
                    children: [
                      // Title
                      Text(
                        'Welcome to CareBot',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: const Color(0xFF10141A),
                                ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Simplify your daily tasks from patient records\nto team coordination, all in one place.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF808081),
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Sign up with Google
                      _buildSocialButton(
                        onTap: () {},
                        icon: Image.asset('images/logo/google.png',
                            width: 28, height: 28),
                        label: 'Sign up with Google',
                      ),
                      const SizedBox(height: 16),

                      // Continue with Apple
                      _buildSocialButton(
                        onTap: () {},
                        icon: Image.asset('images/logo/apple.png',
                            width: 24, height: 24),
                        label: 'Continue with Apple',
                      ),
                      const SizedBox(height: 16),

                      // Sign up with Email
                      _buildSocialButton(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignupScreen()),
                          );
                        },
                        icon: Image.asset('images/logo/email.png',
                            width: 22, height: 22),
                        label: 'Sign up with Email',
                      ),
                      const SizedBox(height: 32),

                      // Already have an Account? Sign In
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an Account? ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF808081),
                                  fontSize: 14,
                                ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary, // Teal
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required Widget icon,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(60),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F7), // Light grey background
          borderRadius: BorderRadius.circular(60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10141A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
