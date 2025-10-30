import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'dart:io';
import 'dart:typed_data';
import '../../../utils/index.dart';
import '../../../common/services/index.dart';
import '../../HomePage/controllers/home_controller.dart';

class SettingsController extends GetxController {
  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  
  // Reactive variables
  final RxString userAvatar = ''.obs;
  final RxString userName = ''.obs;
  final RxString userUsername = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool hasChanges = false.obs;
  
  // Image picker
  final ImagePicker _picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    
    // Add listeners to update reactive variables
    nameController.addListener(() {
      userName.value = nameController.text;
      update(); // Update UI for character count
    });
    
    usernameController.addListener(() {
      userUsername.value = usernameController.text;
      print('Username controller changed: ${usernameController.text} -> ${userUsername.value}');
    });
    
    bioController.addListener(() {
      update(); // Update UI for character count
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Ensure data is loaded when the controller is ready
    if (userName.value.isEmpty) {
      loadUserProfile();
    }
  }
  
  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    websiteController.dispose();
    super.onClose();
  }
  
  // Load user profile data
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      
      final userData = await UserService.fetchUserProfile();
      
      if (userData != null) {
        // Populate form fields
        nameController.text = UserService.getUserName();
        usernameController.text = UserService.getUsername();
        bioController.text = UserService.getUserBio();
        websiteController.text = UserService.getUserWebsite();
        userAvatar.value = UserService.getUserAvatar() ?? '';
        
        // Update reactive variables
        userName.value = UserService.getUserName();
        userUsername.value = UserService.getUsername();
        
        print('User profile loaded for settings');
        print('Name: ${nameController.text}');
        print('Username: ${usernameController.text}');
        print('Bio: ${bioController.text}');
        print('Website: ${websiteController.text}');
      }
    } catch (e) {
      print('Error loading user profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh form data (useful for modal opening)
  void refreshFormData() {
    if (UserService.userData != null) {
      nameController.text = UserService.getUserName();
      usernameController.text = UserService.getUsername();
      bioController.text = UserService.getUserBio();
      websiteController.text = UserService.getUserWebsite();
      userAvatar.value = UserService.getUserAvatar() ?? '';
      
      // Update reactive variables
      userName.value = UserService.getUserName();
      userUsername.value = UserService.getUsername();
      
      hasChanges.value = false;
      
      print('Form data refreshed:');
      print('Name: ${nameController.text} -> ${userName.value}');
      print('Username: ${usernameController.text} -> ${userUsername.value}');
    } else {
      print('UserService.userData is null, cannot refresh form data');
    }
  }
  
  // Show image picker options
  Future<void> pickImage() async {
    try {
      // Show options dialog
      final result = await Get.dialog<ImageSource>(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.zWhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Simple title
                Text(
                  'Choose Photo',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.zBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Options - simple buttons
                Row(
                  children: [
                    // Camera option
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(result: ImageSource.camera),
                          borderRadius: BorderRadius.circular(12),
                      child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.zInputFieldBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: AppColors.zBlackColor,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                            'Camera',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.zBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Gallery option
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(result: ImageSource.gallery),
                          borderRadius: BorderRadius.circular(12),
                      child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.zPrimaryBtnColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: AppColors.zBlackColor,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Text(
                            'Gallery',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.zBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Cancel button
                TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.zSecondaryBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (result != null) {
        await _pickImageFromSource(result);
      }
    } catch (e) {
      print('Error showing image picker options: $e');
      // Fallback to gallery only
      await _pickImageFromSource(ImageSource.gallery);
    }
  }

  // Pick image from specific source
  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,  // Reasonable size for testing
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        final originalFile = File(image.path);
        
        // Show processing message
        Get.snackbar(
          'Processing',
          'Compressing image...',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
        );
        
        // Compress and upload
        final compressedFile = await _compressImage(originalFile);
        await uploadAvatar(compressedFile ?? originalFile);
      }
    } catch (e) {
      print('Error picking image from ${source.name}: $e');
      
      // Handle specific iOS simulator error
      if (e.toString().contains('channel-error') || e.toString().contains('Unable to establish connection')) {
        Get.snackbar(
          'Simulator Limitation',
          'Image picker is not available in iOS Simulator. Please test on a physical device.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else if (e.toString().contains('photo_access_denied') || e.toString().contains('camera_access_denied')) {
        Get.snackbar(
          'Permission Denied',
          'Please allow access to ${source == ImageSource.camera ? 'camera' : 'photos'} in Settings.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to pick image. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
  
    // Compress image before uploading
  Future<File?> _compressImage(File imageFile) async {
    try {
      final originalSize = await imageFile.length();
      
      // Generate compressed file path
      final originalPath = imageFile.path;
      final fileName = originalPath.split('/').last;
      final nameWithoutExtension = fileName.split('.').first;
      final extension = fileName.split('.').last;
      final compressedPath = originalPath.replaceAll(
        fileName, 
        '${nameWithoutExtension}_compressed.$extension'
      );
      
      // Compress the image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        originalPath,
        minWidth: 800,
        minHeight: 600,
        quality: 70,
      );
      
      if (compressedBytes != null && compressedBytes.isNotEmpty) {
        final compressedFile = File(compressedPath);
        await compressedFile.writeAsBytes(compressedBytes);
        
        final compressedSize = compressedBytes.length;
        print('Image compressed: ${originalSize} → ${compressedSize} bytes');
        
        return compressedFile;
      }
      
      return null;
    } catch (e) {
      print('Image compression failed: $e');
      return null;
    }
  }
  
  // Upload avatar to server
  Future<void> uploadAvatar(File imageFile) async {
    bool isCompressedFile = imageFile.path.contains('_compressed');
    
    try {
      isLoading.value = true;
      
      final success = await UserService.uploadAvatar(imageFile);
      
      if (success) {
        // Update local avatar
        final newAvatar = UserService.getUserAvatar();
        if (newAvatar != null) {
          userAvatar.value = newAvatar;
        }
        
        Get.snackbar(
          'Success',
          'Avatar updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        
        // Update home page if available
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          // Home controller not available, skip
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload avatar',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload avatar',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      
      // Clean up compressed temporary file
      if (isCompressedFile) {
        try {
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          // Cleanup failed, but not critical
        }
      }
    }
  }
  
  // Update username specifically
  Future<bool> updateUsername(String newUsername) async {
    try {
      isSaving.value = true;
      
      // Validate username
      if (newUsername.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Username is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
                  );
          return false;
        }
        
        if (newUsername.length < 6 || newUsername.length > 20) {
        Get.snackbar(
          'Error',
          'Username must be between 6 and 20 characters',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
      
      // Call the API using UserService
      bool success = false;
      try {
        success = await UserService.updateProfile({
          'username': newUsername.trim(),
        });
      } catch (apiError) {
        print('API error during username update: $apiError');
        success = false;
      }
      
      if (success) {
        // Update local state
        usernameController.text = newUsername.trim();
        userUsername.value = newUsername.trim();
        hasChanges.value = false;
        
        Get.snackbar(
          'Success',
          'Successfully changed',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Update home page data if controller exists
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          print('HomeController not found, skipping home page update');
        }
        
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update username',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error updating username: $e');
      Get.snackbar(
        'Error',
        'Failed to update username',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSaving.value = false;
    }
    return false;
  }
  
  // Save profile changes
  Future<void> saveProfile() async {
    try {
      isSaving.value = true;
      
      // Validate username
      if (usernameController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Username is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }
      
      // Prepare form data
      final Map<String, String> formData = {};
      
      if (nameController.text.trim().isNotEmpty) {
        formData['name'] = nameController.text.trim();
      }
      
      if (usernameController.text.trim().isNotEmpty) {
        formData['username'] = usernameController.text.trim();
      }
      
      if (bioController.text.trim().isNotEmpty) {
        formData['bio'] = bioController.text.trim();
      }
      
      if (websiteController.text.trim().isNotEmpty) {
        formData['primary_website'] = websiteController.text.trim();
      }
      
      final success = await UserService.updateProfile(formData);
      
      if (success) {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Reload profile data to get updated information
        await loadUserProfile();
        hasChanges.value = false;
        
        // Update home page data if controller exists
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          print('HomeController not found, skipping home page update');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Failed to save profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSaving.value = false;
    }
  }
  
  // Launch URL in browser
  Future<void> launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await url_launcher.canLaunchUrl(uri)) {
        await url_launcher.launchUrl(uri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open link',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      Get.snackbar(
        'Error',
        'Could not open link',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // Logout user
  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Logout',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zBlackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.zBlackColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.zSecondaryBlackColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  
  // Perform actual logout
  void _performLogout() async {
    try {
      await FirebaseAuthService.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Delete account with confirmation
  void deleteAccount() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Account',
          style: AppTextStyles.heading3.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete your account?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone. All your data will be permanently removed.',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.zSecondaryBlackColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performDeleteAccount();
            },
            child: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Perform actual account deletion
  void _performDeleteAccount() async {
    try {
      // Show loading
      Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Deleting account...'),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Call delete account API
      final success = await UserService.deleteAccount();
      
      // Close loading dialog
      Get.back();

      if (success) {
        // Sign out from Firebase and clear all data
        await FirebaseAuthService.signOut();
        
        // Navigate to login screen
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      print('Error during account deletion: $e');
      Get.snackbar(
        'Error',
        'Failed to delete account. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Check if user has Firebase UID connected
  bool get shouldShowConnectSocial {
    final firebaseUid = StorageService.firebaseUid;
    return firebaseUid == null || firebaseUid.isEmpty;
  }

  // Connect social account (Apple/Google)
  void connectSocialAccount() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Connect Account',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zBlackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connect your Apple or Google account for easier sign-in.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Google Connect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  _connectWithGoogle();
                },
                icon: Image.asset(
                  'assets/icons/google.png',
                  width: 20,
                  height: 20,
                ),
                label: Text('Connect with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zWhiteColor,
                  foregroundColor: AppColors.zBlackColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.zBlackColor.withOpacity(0.2)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Apple Connect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  _connectWithApple();
                },
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.zWhiteColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/icons/apple.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                label: Text('Connect with Apple'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zBlackColor,
                  foregroundColor: AppColors.zWhiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.zSecondaryBlackColor),
            ),
          ),
        ],
      ),
    );
  }

  // Connect with Google
  Future<void> _connectWithGoogle() async {
    try {
      print('🔗 Starting Google account connection...');
      
      final user = await FirebaseAuthService.connectWithGoogle();
      
      if (user != null && user.uid.isNotEmpty) {
        print('✅ Google authentication successful, updating Firebase UID...');
        await _updateFirebaseUid(user.uid);
      } else {
        print('❌ Google authentication failed - no user returned');
        _showConnectionError();
      }
    } catch (e) {
      print('💥 Google connection error: $e');
      _showConnectionError();
    }
  }

  // Connect with Apple
  Future<void> _connectWithApple() async {
    try {
      print('🔗 Starting Apple account connection...');
      
      final user = await FirebaseAuthService.connectWithApple();
      
      if (user != null && user.uid.isNotEmpty) {
        print('✅ Apple authentication successful, updating Firebase UID...');
        await _updateFirebaseUid(user.uid);
      } else {
        print('❌ Apple authentication failed - no user returned');
        _showConnectionError();
      }
    } catch (e) {
      print('💥 Apple connection error: $e');
      _showConnectionError();
    }
  }

  // Update Firebase UID via API
  Future<void> _updateFirebaseUid(String firebaseUid) async {
    try {
      // Show loading
      Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Connecting account...'),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final success = await UserService.updateFirebaseUid(firebaseUid);
      
      // Close loading dialog
      Get.back();

      if (success) {
        // Store Firebase UID locally
        await StorageService.setFirebaseUid(firebaseUid);
        
        Get.snackbar(
          'Success',
          'Social account connected successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
        
        // Refresh profile to update UI
        await loadUserProfile();
      } else {
        _showConnectionError();
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      print('💥 Error updating Firebase UID: $e');
      _showConnectionError();
    }
  }

  // Show connection error message
  void _showConnectionError() {
    Get.snackbar(
      'Connection Failed',
      'Please try with another account or you don\'t have active internet.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
  }
} 