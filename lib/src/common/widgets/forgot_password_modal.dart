import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';

class ForgotPasswordModal {
  // Static method to show the modal
  static Future<void> show(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    
    return AppModal.show(
      context: context,
      title: 'Reset Password',
      subtitle: 'Enter your email address and we\'ll send you a link to reset your password.',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppInputField(
            hintText: 'Email address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) async => await _handleSendResetLink(context, emailController),
          ),
        ],
      ),
      actions: [
        // Send reset link button
        AppButton(
          text: 'Send Reset Link',
          backgroundColor: AppColors.zPrimaryBtnColor,
          onPressed: () async => await _handleSendResetLink(context, emailController),
        ),
        const SizedBox(height: 12),
        // Cancel button
        AppButton(
          text: 'Cancel',
          backgroundColor: AppColors.zInputFieldBgColor,
          textColor: AppColors.zSecondaryBlackColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      barrierDismissible: true,
    );
  }

  static Future<void> _handleSendResetLink(BuildContext context, TextEditingController emailController) async {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      print('🔐 Starting password reset process...');
      
      // Send password reset email via Firebase
      final success = await FirebaseAuthService.sendPasswordResetEmail(email);
      
      if (success) {
        // Close modal first
        Navigator.of(context).pop();
        
        print('✅ Password reset email sent successfully');
        
        // Show success message after modal closes
        Get.dialog(
          AlertDialog(
            title: Text(
              'Reset Email Sent!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('If an account exists with this email:'),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Text('You will receive a password reset email.'),
                const SizedBox(height: 12),
                Text('Please check:'),
                const SizedBox(height: 8),
                Text('• Your inbox (may take 2-5 minutes)'),
                Text('• Your spam/junk folder'),
                Text('• Promotions tab (Gmail)'),
                const SizedBox(height: 16),
                Text(
                  'If you don\'t receive an email, the account may not exist or try again in a few minutes.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Got it'),
              ),
            ],
          ),
        );
      } else {
        print('❌ Password reset email failed');
        // Error message is already shown by FirebaseAuthService
      }
    } catch (e) {
      print('💥 Password reset error: $e');
      
      Get.snackbar(
        'Error',
        'Failed to send reset email. Please try again.',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
} 