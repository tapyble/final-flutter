import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';

class OtpVerificationModal extends StatefulWidget {
  final String firebaseUid;
  final VoidCallback? onVerificationSuccess;

  const OtpVerificationModal({
    super.key,
    required this.firebaseUid,
    this.onVerificationSuccess,
  });

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();
}

class _OtpVerificationModalState extends State<OtpVerificationModal> {
  // Controllers for OTP input fields
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  bool _isLoading = false;
  bool _isResending = false;
  bool _otpSent = false; // Track if OTP has been sent

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _handleOtpChange(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all fields are filled (only if OTP has been sent)
    if (_otpSent && _otpCode.length == 4) {
      _handleVerifyOtp();
    }
  }

  Future<void> _handleSendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a random 4-digit OTP for demonstration
      // In production, this would be generated on the backend
      final otpCode = (1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor().toString();
      
      print('📨 Generated OTP: $otpCode'); // For debugging - remove in production
      
      // Send OTP to backend
      final success = await UserService.sendOtp(otpCode, widget.firebaseUid);
      
      if (success) {
        setState(() {
          _otpSent = true;
        });
        
        // Focus first OTP field
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      print('Error sending OTP: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerifyOtp() async {
    final otpCode = _otpCode;
    
    if (otpCode.length != 4) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter a 4-digit verification code',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verify the user with backend
      await _handleVerifyUser();
    } catch (e) {
      print('Error verifying OTP: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVerifyUser() async {
    try {
      // Verify user with backend
      final success = await UserService.verifyUser(widget.firebaseUid);
      
      if (success) {
        // Close modal
        Get.back();
        
        // Call success callback
        if (widget.onVerificationSuccess != null) {
          widget.onVerificationSuccess!();
        }
        
        // Navigate to home
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('Error verifying user: $e');
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      // Clear current OTP
      for (var controller in _otpControllers) {
        controller.clear();
      }

      // Resend OTP by calling the send method again
      await _handleSendOtp();
      
      Get.snackbar(
        'OTP Resent',
        'A new verification code has been sent',
        backgroundColor: Colors.green,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Error resending OTP: $e');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final modalWidth = screenSize.width * 0.9;
    final maxWidth = modalWidth > 400 ? 400.0 : modalWidth;
    
    return Dialog(
      backgroundColor: AppColors.zBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: maxWidth,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Center(
                  child: Text(
                    'Verify Your Account',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.zBlackColor,
                    ),
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 12 : 16),
                
                // Description
                Text(
                  _otpSent 
                    ? 'Enter the 4-digit verification code sent to verify your account'
                    : 'Click the button below to receive a verification code',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: AppColors.zBlackColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: isSmallScreen ? 24 : 32),
                
                // Conditional Content
                if (!_otpSent) ...[
                  // Send OTP Button (Initial State)
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: _isLoading ? 'Sending...' : 'Send OTP',
                      onPressed: _isLoading ? () {} : _handleSendOtp,
                      backgroundColor: AppColors.zPrimaryBtnColor,
                      textColor: AppColors.zBlackColor,
                    ),
                  ),
                ] else ...[
                  // OTP Input Fields (After OTP Sent)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isSmallScreen ? 8 : 12,
                    children: List.generate(4, (index) {
                      final fieldWidth = isSmallScreen ? 35.0 : 45.0;
                      final fieldHeight = isSmallScreen ? 45.0 : 55.0;
                      
                      return SizedBox(
                        width: fieldWidth,
                        height: fieldHeight,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.zBlackColor,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.zBlackColor.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.zPrimaryBtnColor, width: 2),
                            ),
                            filled: true,
                            fillColor: AppColors.zWhiteColor,
                          ),
                          onChanged: (value) => _handleOtpChange(value, index),
                        ),
                      );
                    }),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  
                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: _isLoading ? 'Verifying...' : 'Verify OTP',
                      onPressed: _isLoading ? () {} : _handleVerifyOtp,
                      backgroundColor: AppColors.zPrimaryBtnColor,
                      textColor: AppColors.zBlackColor,
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  
                  // Resend OTP
                  TextButton(
                    onPressed: _isResending ? null : _handleResendOtp,
                    child: Text(
                      _isResending ? 'Resending...' : 'Resend Code',
                      style: TextStyle(
                        color: AppColors.zPrimaryBtnColor,
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                
                SizedBox(height: isSmallScreen ? 8 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 