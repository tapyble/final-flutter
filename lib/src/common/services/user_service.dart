import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import 'http_service.dart';

class UserService {
  static const String _getUserEndpoint = '/users/get-user';
  static const String _editUserEndpoint = '/users/edit-user';
  static const String _sendOtpEndpoint = '/users/send-otp';
  static const String _verifyUserEndpoint = '/users/verify-user';
  static const String _deleteAccountEndpoint = '/users/delete-account';

  // User data model
  static Map<String, dynamic>? _userData;
  static String? _currentMode;

  // Get user data
  static Map<String, dynamic>? get userData => _userData;
  static String? get currentMode => _currentMode;

  // Fetch user profile from API
  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.post(_getUserEndpoint, {
        'token': token,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      _userData = responseData;
      _currentMode = responseData['mode'];
      
      print('User profile loaded: ${responseData['name']} - Mode: ${responseData['mode']}');
      return responseData;
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Profile Error', e.toString());
      return null;
    }
  }

  // Change user mode
  static Future<bool> changeUserMode(String newMode) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.postForm(_editUserEndpoint, {
        'token': token,
        'mode': newMode,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      _userData = responseData;
      _currentMode = responseData['mode'];
      
      return true;
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Update Failed', e.toString());
      return false;
    }
  }

  // Get mode index (0 = PERSONAL, 1 = INFLUENCER)
  static int getModeIndex() {
    if (_currentMode == null) return 0;
    return _currentMode == 'PERSONAL' ? 0 : 1;
  }

  // Get mode name for display
  static String getModeName() {
    if (_currentMode == null) return 'PERSONAL';
    return _currentMode!;
  }

  // Get user name
  static String getUserName() {
    return _userData?['name'] ?? 'User';
  }

  // Get user avatar
  static String? getUserAvatar() {
    return _userData?['avatar'];
  }

  // Get user bio
  static String getUserBio() {
    return _userData?['bio'] ?? '';
  }

  // Get username
  static String getUsername() {
    return _userData?['username'] ?? '';
  }

  // Get user website
  static String getUserWebsite() {
    return _userData?['website'] ?? '';
  }

  // Get total visits from _count object
  static int getTotalVisits() {
    final count = _userData?['_count'] as Map<String, dynamic>?;
    return count?['visits'] ?? _userData?['totalVisits'] ?? 0;
  }

  // Get links count from _count object
  static int getLinksCount() {
    final count = _userData?['_count'] as Map<String, dynamic>?;
    return count?['links'] ?? 0;
  }

  // Check if user is verified (handle both boolean and integer values)
  static bool get isUserVerified {
    final verifiedValue = _userData?['isVerified'];
    if (verifiedValue is bool) {
      return verifiedValue;
    } else if (verifiedValue is int) {
      return verifiedValue == 1;
    }
    return false;
  }

  // Get user email verification status
  static bool get isEmailVerified => _userData?['emailVerified'] ?? false;

  // Send OTP for user verification
  static Future<bool> sendOtp(String otp, String firebaseUid) async {
    try {
      print('📨 Sending OTP...');
      print('📨 Firebase UID: $firebaseUid');
      print('📨 OTP: $otp');

      // Prepare request body
      final requestBody = {
        'otp': otp,
        'firebase_uid': firebaseUid,
      };

      print('📤 Request Body: $requestBody');
      print('🌐 API Endpoint: $_sendOtpEndpoint');

      // Make API request using centralized service
      final response = await HttpService.post(_sendOtpEndpoint, requestBody);
      print('📥 API Response Status: ${response.statusCode}');
      print('📥 API Response Body: ${response.body}');

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      print('✅ OTP sent successfully: $responseData');

      // Show success message
      Get.snackbar(
        'OTP Sent',
        'Verification code has been sent successfully',
        backgroundColor: Colors.green,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      print('💥 Error sending OTP: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      // Handle errors using centralized service
      HttpService.showError('OTP Send Failed', e.toString());
      return false;
    }
  }

  // Verify user with OTP
  static Future<bool> verifyUser(String firebaseUid) async {
    try {
      print('✅ Verifying user...');
      print('✅ Firebase UID: $firebaseUid');

      // Prepare request body
      final requestBody = {
        'firebase_uid': firebaseUid,
      };

      print('📤 Request Body: $requestBody');
      print('🌐 API Endpoint: $_verifyUserEndpoint');

      // Make API request using centralized service
      final response = await HttpService.post(_verifyUserEndpoint, requestBody);
      print('📥 API Response Status: ${response.statusCode}');
      print('📥 API Response Body: ${response.body}');

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      print('✅ User verified successfully: $responseData');

      // Update user data if response contains updated user info
      if (responseData is Map<String, dynamic>) {
        _userData = responseData;
        print('📝 User data updated with verification status');
      }

      // Show success message
      Get.snackbar(
        'Verification Successful',
        'Your account has been verified successfully!',
        backgroundColor: Colors.green,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      print('💥 Error verifying user: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      // Handle errors using centralized service
      HttpService.showError('Verification Failed', e.toString());
      return false;
    }
  }

  // Get links count by mode
  static int getLinksCountByMode(String mode) {
    final links = getUserLinks();
    return links.where((link) => link['mode'] == mode).length;
  }

  // Get user links
  static List<Map<String, dynamic>> getUserLinks() {
    final links = _userData?['links'] as List?;
    if (links == null) return [];
    
    return links.map((link) => Map<String, dynamic>.from(link)).toList();
  }

  // Get user links by mode
  static List<Map<String, dynamic>> getUserLinksByMode(String mode) {
    final links = getUserLinks();
    return links.where((link) => link['mode'] == mode).toList();
  }

  // Update user profile
  static Future<bool> updateProfile(Map<String, String> formData) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Add token to form data
      formData['token'] = token;

      // Make API request using centralized service
      final response = await HttpService.postForm(_editUserEndpoint, formData);

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      _userData = responseData;
      _currentMode = responseData['mode'];
      
      return true;
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Update Failed', e.toString());
      return false;
    }
  }

  // Upload user avatar
  static Future<bool> uploadAvatar(dynamic imageFile) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.postFormWithFile(_editUserEndpoint, {
        'token': token,
        'avatar': imageFile,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      _userData = responseData;
      
      return true;
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Upload Failed', e.toString());
      return false;
    }
  }

  // Update Firebase UID
  static Future<bool> updateFirebaseUid(String firebaseUid) async {
    try {
      print('🔗 Updating Firebase UID...');
      print('🔗 Firebase UID: $firebaseUid');

      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Prepare form data
      final Map<String, String> formData = {
        'token': token,
        'firebase_uid': firebaseUid,
      };

      print('📤 Form Data: $formData');
      print('🌐 API Endpoint: $_editUserEndpoint');

      // Make API request using form data
      final response = await HttpService.postForm(_editUserEndpoint, formData);
      print('📥 API Response Status: ${response.statusCode}');
      print('📥 API Response Body: ${response.body}');

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      print('✅ Firebase UID updated successfully: $responseData');

      // Update user data if response contains updated user info
      if (responseData is Map<String, dynamic>) {
        _userData = responseData;
        print('📝 User data updated with Firebase UID');
      }

      return true;
    } catch (e) {
      print('💥 Error updating Firebase UID: $e');
      print('💥 Error type: ${e.runtimeType}');
      return false;
    }
  }

  // Delete user account
  static Future<bool> deleteAccount() async {
    try {
      print('🗑️ Starting account deletion...');

      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Prepare request body
      final requestBody = {
        'token': token,
      };

      print('📤 Request Body: $requestBody');
      print('🌐 API Endpoint: $_deleteAccountEndpoint');

      // Make API request using centralized service
      final response = await HttpService.post(_deleteAccountEndpoint, requestBody);
      print('📥 API Response Status: ${response.statusCode}');
      print('📥 API Response Body: ${response.body}');

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      print('✅ Account deleted successfully: $responseData');

      // Clear user data
      clearUserData();

      // Show success message
      Get.snackbar(
        'Account Deleted',
        'Your account has been permanently deleted',
        backgroundColor: Colors.green,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      return true;
    } catch (e) {
      print('💥 Error deleting account: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      // Handle errors using centralized service
      HttpService.showError('Account Deletion Failed', e.toString());
      return false;
    }
  }

  // Clear user data (for logout)
  static void clearUserData() {
    _userData = null;
    _currentMode = null;
  }
} 