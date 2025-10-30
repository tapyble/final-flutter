import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import 'http_service.dart';

class DeviceService {
  static const String _showDeviceEndpoint = '/users/show_device';
  static const String _addDeviceEndpoint = '/users/add_device';
  static const String _removeDeviceEndpoint = '/users/remove_device';

  // Fetch user devices from API
  static Future<List<Map<String, dynamic>>?> fetchUserDevices() async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.post(_showDeviceEndpoint, {
        'token': token,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      final devices = responseData['data'] as List?;
      
      if (devices != null) {
        return devices.map((device) => Map<String, dynamic>.from(device)).toList();
      }
      
      return [];
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Device Error', e.toString());
      return null;
    }
  }

  // Add device to user account
  static Future<List<Map<String, dynamic>>?> addDevice(String url) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.post(_addDeviceEndpoint, {
        'token': token,
        'url': url,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      final devices = responseData['data'] as List?;
      
      if (devices != null) {
        Get.snackbar(
          'Success',
          responseData['msg'] ?? 'Device has been added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        return devices.map((device) => Map<String, dynamic>.from(device)).toList();
      }
      
      return [];
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Add Device Failed', e.toString());
      return null;
    }
  }

  // Remove device from user account
  static Future<bool> removeDevice(String uid) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      // Make API request using centralized service
      final response = await HttpService.post(_removeDeviceEndpoint, {
        'token': token,
        'uid': uid,
      });

      // Handle response using centralized service
      final responseData = HttpService.handleResponse(response);
      
      Get.snackbar(
        'Success',
        responseData['msg'] ?? 'Device has been removed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      
      return true;
    } catch (e) {
      // Handle errors using centralized service
      HttpService.showError('Remove Device Failed', e.toString());
      return false;
    }
  }

  // Extract card ID from URL
  static String? extractCardIdFromUrl(String url) {
    try {
      // Extract the card ID from URL like "https://app.tapyble.com/share/10300"
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.length >= 2 && pathSegments[0] == 'share') {
        return pathSegments[1];
      }
      
      return null;
    } catch (e) {
      print('Error extracting card ID from URL: $e');
      return null;
    }
  }

  // Validate device URL format
  static bool isValidDeviceUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host == 'app.tapyble.com' && 
             uri.pathSegments.length >= 2 && 
             uri.pathSegments[0] == 'share';
    } catch (e) {
      return false;
    }
  }
} 