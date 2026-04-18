import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;

  void _handleLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Header Image/Text Area
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00B4D8),
                    Color(0xFF0077B6),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1,200+',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Doctors Placed in the UK\nand counting!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Form Area
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button Icon
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF1F5F9), // AppColors.background approximation
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.textPrimary,
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Login to account',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Please enter your information to access your account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter email address',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Light border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remember me and Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF007A8A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF007A8A), // Teal
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007A8A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer Navigation to register
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF007A8A),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
