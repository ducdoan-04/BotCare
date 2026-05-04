import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'main_navigation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // For Web: listen to changes when using the rendered GIS button
    if (kIsWeb) {
      GoogleSignIn.instance.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
        if (account != null) {
          _processGoogleAccount(account);
        }
      });
    }
  }

  Future<void> _processGoogleAccount(GoogleSignInAccount googleUser) async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final result = await _authService.loginWithGoogle(idToken);
        
        if (result['success'] && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
          return;
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Google sign in failed')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (kIsWeb) return; // On web, the button handles this automatically
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      await _processGoogleAccount(googleUser);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String appleId = credential.userIdentifier ?? '';
      final String? email = credential.email;
      final String? name = credential.givenName != null 
          ? '${credential.givenName} ${credential.familyName ?? ''}'.trim() 
          : null;

      final result = await _authService.loginWithApple(appleId, email, name);

      if (result['success'] && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Apple sign in failed')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            bottom: MediaQuery.of(context).size.height * 0.4, // Cover upper portion
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
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
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

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        )
                      else ...[
                        // Sign up with Google
                        if (kIsWeb)
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: web.renderButton(
                              configuration: web.GSIButtonConfiguration(
                                theme: web.GSIButtonTheme.outline,
                                size: web.GSIButtonSize.large,
                                shape: web.GSIButtonShape.pill,
                              ),
                            ),
                          )
                        else
                          _buildSocialButton(
                            onTap: _handleGoogleSignIn,
                            icon: Image.asset('images/logo/google.png',
                                width: 28, height: 28),
                            label: 'Sign up with Google',
                          ),
                        const SizedBox(height: 16),

                        // Continue with Apple
                        _buildSocialButton(
                          onTap: _handleAppleSignIn,
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
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF808081),
                                    fontSize: 14,
                                  ),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
