import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../utils/index.dart';
import '../../../common/widgets/index.dart';

class InternetSupportPage extends StatefulWidget {
  const InternetSupportPage({super.key});

  @override
  State<InternetSupportPage> createState() => _InternetSupportPageState();
}

class _InternetSupportPageState extends State<InternetSupportPage> {
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Expanded content area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // No Internet Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.zWhiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 60,
                        color: Colors.orange.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      'No Internet Connection',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      'Please check your internet connection and try again. Make sure you\'re connected to Wi-Fi or mobile data.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.zSecondaryBlackColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Connection Tips
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.zWhiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Try these steps:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.zBlackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTipItem('Check your Wi-Fi connection'),
                          _buildTipItem('Turn mobile data on/off'),
                          _buildTipItem('Restart your router if using Wi-Fi'),
                          _buildTipItem('Move to an area with better signal'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Retry Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: _isChecking ? 'Checking Connection...' : 'Try Again',
                  onPressed: _isChecking ? () {} : _checkConnection,
                  backgroundColor: AppColors.zPrimaryBtnColor,
                  textColor: AppColors.zBlackColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Settings Button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Open Network Settings',
                  onPressed: _openNetworkSettings,
                  backgroundColor: AppColors.zWhiteColor,
                  textColor: AppColors.zBlackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: AppColors.zPrimaryBtnColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.zSecondaryBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
    });

    try {
      // Check internet connectivity using built-in dart:io
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Connection successful, go back to previous page
        Get.back();
        
        // Show success message
        Get.snackbar(
          'Connected!',
          'Internet connection restored',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Still no connection
      Get.snackbar(
        'Still No Connection',
        'Please check your internet settings and try again',
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _openNetworkSettings() {
    // Show dialog with instructions to open settings manually
    Get.dialog(
      AlertDialog(
        title: Text(
          'Network Settings',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zBlackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To fix your connection, please:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '• Go to your device Settings\n• Select Wi-Fi or Mobile Data\n• Check your connection status\n• Toggle Wi-Fi/Mobile Data off and on',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.zSecondaryBlackColor,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Got it',
              style: TextStyle(color: AppColors.zPrimaryBtnColor),
            ),
          ),
        ],
      ),
    );
  }
} 