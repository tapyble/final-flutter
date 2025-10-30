import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/features/RegisterPage/index.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';

class LoginPageForm extends StatelessWidget {
  LoginPageForm({super.key});

  // Controllers for input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 
                     MediaQuery.of(context).padding.top - 
                     MediaQuery.of(context).padding.bottom,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Back button section
                  Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded, 
                          size: 24, 
                          color: AppColors.zBlackColor
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Logo section
                  Image.asset(
                    AppLogos.logo,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Input fields
                  AppInputField(
                    hintText: 'Email or phone',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  AppInputField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(context),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => ForgotPasswordModal.show(context),
                      child: Text(
                        'Forgot password?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.zSecondaryBlackColor,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Log in button
                  AppButton(
                    text: 'Log in',
                    backgroundColor: AppColors.zSecondaryBtnColor,
                    onPressed: () => _handleLogin(context),
                  ),

                  const SizedBox(height: 32),

                  Column(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.zSecondaryBlackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => RegisterPage());
                        },
                        child: Text(
                          'Create account',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.zPrimaryBtnColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Social login section
                  Column(
                    children: [
                      Text(
                        'Or Log in with',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.zSecondaryBlackColor,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            AppIcons.apple,
                            () => _handleSocialLogin(context, 'Apple'),
                          ),
                          const SizedBox(width: 32),
                          _buildSocialButton(
                            AppIcons.google,
                            () => _handleSocialLogin(context, 'Google'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.zWhiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.zBlackColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Basic email validation
    if (!email.contains('@')) {
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

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      print('🔐 Starting email/password login...');
      
      // Sign in with Firebase email/password
      final user = await FirebaseAuthService.signInWithEmailAndPassword(email, password);
      
      if (user != null) {
        print('✅ Firebase login successful, checking user verification...');
        
        // Check user verification status after successful login
        await _checkUserVerificationStatus(user.uid);
      } else {
        print('❌ Firebase login failed - no user returned');
      }
    } catch (e) {
      print('💥 Login error: $e');
      // Error handling is already done in FirebaseAuthService
    }
  }

  Future<void> _checkUserVerificationStatus(String firebaseUid) async {
    try {
      print('🔍 Checking user verification status...');
      
      // Fetch user profile to check verification status
      final userData = await UserService.fetchUserProfile();
      
      if (userData != null) {
        final isVerified = userData['isVerified'] ?? false;
        print('📋 User verification status: $isVerified');
        
        if (isVerified) {
          // User is verified, navigate to home
          print('✅ User is verified, navigating to home...');
          Get.offAllNamed('/home');
          
          // Show success message
          Get.snackbar(
            'Welcome Back!',
            'Login successful!',
            backgroundColor: Colors.green,
            colorText: AppColors.zWhiteColor,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );
        } else {
          // User is not verified, show OTP verification modal
          print('❗ User is not verified, showing OTP modal...');
          _showOtpVerificationModal(firebaseUid);
        }
      } else {
        print('❌ Failed to fetch user profile');
        // If we can't fetch user profile, still navigate to home
        // The home screen can handle verification checks too
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('💥 Error checking verification status: $e');
      // If there's an error, still navigate to home
      // The home screen can handle verification checks too
      Get.offAllNamed('/home');
    }
  }

  void _showOtpVerificationModal(String firebaseUid) {
    Get.dialog(
      OtpVerificationModal(
        firebaseUid: firebaseUid,
        onVerificationSuccess: () {
          print('🎉 User verification completed successfully');
          // The modal handles navigation to home
        },
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  Future<void> _handleSocialLogin(BuildContext context, String provider) async {
    try {
      print('🎯 Social login triggered for: $provider');
      
      // Dismiss keyboard
      FocusScope.of(context).unfocus();
      
      if (provider == 'Google') {
        print('📱 Initiating Google Sign-In...');
        final user = await FirebaseAuthService.signInWithGoogle();
        if (user != null) {
          print('✅ Google Sign-In successful, navigating to home...');
          print('🏠 Current login status: ${StorageService.isLogin}');
          print('🎟️ Current token exists: ${StorageService.token != null}');
          Get.offAllNamed('/home');
          print('🧭 Navigation to home completed');
        } else {
          print('❌ Google Sign-In returned null user');
        }
      } else if (provider == 'Apple') {
        print('📱 Initiating Apple Sign-In...');
        final user = await FirebaseAuthService.signInWithApple();
        if (user != null) {
          print('✅ Apple Sign-In successful, navigating to home...');
          print('🏠 Current login status: ${StorageService.isLogin}');
          print('🎟️ Current token exists: ${StorageService.token != null}');
          Get.offAllNamed('/home');
          print('🧭 Navigation to home completed');
        } else {
          print('❌ Apple Sign-In returned null user');
        }
      }
    } catch (e) {
      print('💥 Social login error for $provider: $e');
      print('💥 Error type: ${e.runtimeType}');
      Get.snackbar(
        'Error',
        'Failed to sign in with $provider',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
} 