import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import 'http_service.dart';

class CardAuthService {
  static const String _signinCardEndpoint = '/users/signin_card';

  // Sign in with NFC card
  static Future<Map<String, dynamic>?> signInWithCard(String cardId) async {
    try {
      // Show loading indicator
      HttpService.showLoading('Authenticating...', 'Please wait while we verify your card');

      // Prepare request body
      final requestBody = {
        'uid': cardId,
      };

      // Make API request using centralized service
      final response = await HttpService.post(_signinCardEndpoint, requestBody);
      final responseData = HttpService.handleResponse(response);
      
      final token = responseData['token'];
      
      if (token != null) {
        // Store authentication data
        await StorageService.setLogin(true);
        await StorageService.setToken(token);
        
        // Show success message
        // HttpService.showSuccess('Authentication Successful!', 'Welcome back!');
        
        return responseData;
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Authentication Failed', e.toString());
      return null;
    }
  }

  // Validate card ID format
  static bool isValidCardId(String cardId) {
    // Add your card ID validation logic here
    // For example, check if it's not empty and has a specific format
    return cardId.isNotEmpty && cardId.length >= 3;
  }

  // Check if user is authenticated via card
  static bool get isCardAuthenticated => StorageService.isLogin && StorageService.token != null;

  // Get stored token
  static String? get token => StorageService.token;

  // Logout (clear card authentication)
  static Future<void> logout() async {
    await StorageService.logout();
    
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
} 