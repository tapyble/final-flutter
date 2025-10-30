import 'dart:io';
import 'package:get/get.dart';
import '../../features/InternetSupportPage/views/internet_support_page.dart';

class ConnectivityService {
  static bool _isCheckingConnection = false;
  
  // Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  // Check connection and show support page if no internet
  static Future<bool> checkConnectionAndShowSupport() async {
    if (_isCheckingConnection) return true; // Prevent multiple checks
    
    _isCheckingConnection = true;
    
    try {
      final hasConnection = await hasInternetConnection();
      
      if (!hasConnection) {
        // Show internet support page
        Get.to(() => const InternetSupportPage());
        return false;
      }
      
      return true;
    } finally {
      _isCheckingConnection = false;
    }
  }
  
  // Check connection before API calls
  static Future<bool> checkBeforeApiCall() async {
    final hasConnection = await hasInternetConnection();
    
    if (!hasConnection) {
      Get.to(() => const InternetSupportPage());
      return false;
    }
    
    return true;
  }
  
  // Show internet support page directly
  static void showInternetSupportPage() {
    Get.to(() => const InternetSupportPage());
  }
} 