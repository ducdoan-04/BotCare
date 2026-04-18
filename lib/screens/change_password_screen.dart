import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // F8FAFC or similar off-white
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ensure your account remains protected by updating your password regularly.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildPasswordField('Enter old password', _obscureOld, () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildPasswordField('Enter new password', _obscureNew, () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildPasswordField('Confirm new password', _obscureConfirm, () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    }),
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
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Change password',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String hint, bool isObscured, VoidCallback toggleVisibility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // slightly darker than plain white
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        obscureText: isObscured,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 15),
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: toggleVisibility,
            child: Icon(
              isObscured ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _showStatusDialog(
                  context,
                  isSuccess: false,
                  title: 'Canceled',
                  message: 'Password change canceled. No changes were made.',
                );
              },
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
              onPressed: () {
                _showStatusDialog(
                  context,
                  isSuccess: true,
                  title: 'Successfully',
                  message: 'Your password was changed successfully.\nYour account is now more secure.',
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF007A8A),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Reset Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, {required bool isSuccess, required String title, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), // very light green/red
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSuccess ? const Color(0xFF10B981) : const Color(0xFFD94625), // Green vs Darkish Red (from design)
                      shape: BoxShape.circle,
                    ),
                    // Used check icon instead of trash bin for success, since it makes more logical sense
                    child: Icon(
                      isSuccess ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),
                if (isSuccess)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Pop dialog, then pop the change password screen to go back to Dashboard
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF007A8A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context); // Go back to dashboard
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF007A8A), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Back to Dashboard', style: TextStyle(color: Color(0xFF007A8A), fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx); // Just close the dialog to try again
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF007A8A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Try Again', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
