import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import 'connectivity_service.dart';

class HttpService {
  // Private constructor to prevent instantiation
  HttpService._();

  // Base URL for all API calls
  static const String _baseUrl = 'https://app.tapyble.com/api';
  
  // Timeout duration for requests
  static const Duration _timeout = Duration(seconds: 30);

  // Common headers for all requests
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
  };

  // Get authorization headers with token
  static Map<String, String> _getAuthHeaders() {
    final token = StorageService.token;
    final headers = Map<String, String>.from(_defaultHeaders);
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // GET request
  static Future<http.Response> get(String endpoint) async {
    // Check internet connectivity first
    final hasConnection = await ConnectivityService.checkBeforeApiCall();
    if (!hasConnection) {
      throw Exception('No internet connection');
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getAuthHeaders(),
      ).timeout(_timeout);
      
      return response;
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

  // POST request with JSON body
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    // Check internet connectivity first
    final hasConnection = await ConnectivityService.checkBeforeApiCall();
    if (!hasConnection) {
      throw Exception('No internet connection');
    }
    
    try {
      // Handle full URLs vs relative endpoints
      final String url = endpoint.startsWith('http') ? endpoint : '$_baseUrl$endpoint';
      final headers = _getAuthHeaders();
      final jsonBody = jsonEncode(body);
      
      print('🌐 HTTP POST Request:');
      print('  URL: $url');
      print('  Headers: $headers');
      print('  Body: $jsonBody');
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
      ).timeout(_timeout);
      
      print('📥 HTTP Response:');
      print('  Status: ${response.statusCode}');
      print('  Body: ${response.body}');
      
      return response;
    } catch (e) {
      print('💥 HTTP POST Error: $e');
      print('💥 Error type: ${e.runtimeType}');
      throw _handleNetworkError(e);
    }
  }

  // POST request with form data
  static Future<http.Response> postForm(String endpoint, Map<String, String> fields) async {
    // Check internet connectivity first
    final hasConnection = await ConnectivityService.checkBeforeApiCall();
    if (!hasConnection) {
      throw Exception('No internet connection');
    }
    
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl$endpoint'),
      );

      // Add headers
      request.headers.addAll(_getAuthHeaders());

      // Add form fields
      request.fields.addAll(fields);

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return response;
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

    // POST request with multipart form data and file upload
  static Future<http.Response> postFormWithFile(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add form fields
      data.forEach((key, value) {
        if (key != 'avatar' && value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add file
      if (data['avatar'] != null && data['avatar'] is File) {
        final File file = data['avatar'];
        
        if (!await file.exists()) {
          throw Exception('File does not exist');
        }
        
        final bytes = await file.readAsBytes();
        if (bytes.isEmpty) {
          throw Exception('File is empty');
        }
        
        final fileName = file.path.split('/').last;
        final fileExtension = fileName.toLowerCase().split('.').last;
        
        String mimeType;
        switch (fileExtension) {
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
            break;
          case 'png':
            mimeType = 'image/png';
            break;
          case 'gif':
            mimeType = 'image/gif';
            break;
          case 'webp':
            mimeType = 'image/webp';
            break;
          default:
            mimeType = 'image/jpeg';
        }
        
        final multipartFile = http.MultipartFile.fromBytes(
            'avatar',
          bytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
          );
        
          request.files.add(multipartFile);
      } else {
        throw Exception('No valid file provided for avatar');
      }

      // Send request
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return response;
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

  // PUT request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getAuthHeaders(),
        body: jsonEncode(body),
      ).timeout(_timeout);
      
      return response;
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

  // DELETE request
  static Future<http.Response> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _getAuthHeaders(),
      ).timeout(_timeout);
      
      return response;
    } catch (e) {
      throw _handleNetworkError(e);
    }
  }

  // Handle network errors
  static Exception _handleNetworkError(dynamic error) {
    String errorMessage = 'Network error. Please check your connection.';
    
    if (error.toString().contains('SocketException')) {
      errorMessage = 'No internet connection. Please check your network.';
    } else if (error.toString().contains('TimeoutException')) {
      errorMessage = 'Request timeout. Please try again.';
    } else if (error.toString().contains('Exception:')) {
      errorMessage = error.toString().replaceAll('Exception: ', '');
    }
    
    return Exception(errorMessage);
  }

  // Handle API response and common error codes
  static Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'Request failed';
      
      switch (response.statusCode) {
        case 400:
          errorMessage = 'Bad request. Please check your input.';
          break;
        case 401:
          errorMessage = 'Authentication failed. Please login again.';
          // Clear stored data and redirect to login
          StorageService.logout();
          Get.offAllNamed('/login');
          break;
        case 403:
          errorMessage = 'Access denied.';
          break;
        case 404:
          errorMessage = 'Resource not found.';
          break;
        case 500:
          errorMessage = 'Server error. Please try again later.';
          break;
        default:
          errorMessage = 'Request failed (${response.statusCode})';
      }
      
      throw Exception(errorMessage);
    }
  }

  // Show error snackbar
  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
  }

  // Show success snackbar
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }

  // Show loading snackbar
  static void showLoading(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
} 