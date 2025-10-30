import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';

class HomeController extends GetxController {
  // Bottom navigation
  final RxInt currentIndex = 0.obs;
  
  // Mode switching (0 = Personal, 1 = Influencer)
  final RxInt currentMode = 0.obs;
  
  // User data
  final RxString userName = ''.obs;
  final RxString userMode = ''.obs;
  final RxInt totalVisits = 0.obs;
  final RxInt linksCount = 0.obs;
  final RxString userBio = ''.obs;
  final RxString? userAvatar = RxString('');
  
  // Loading state
  final RxBool isLoading = true.obs;
  
  // Mode change loading state
  final RxBool isChangingMode = false.obs;
  
  // Page controller for swipe functionality
  late PageController pageController;
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentMode.value);
    _loadUserProfile();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Ensure PageView syncs with current mode when page becomes ready
    syncPageWithMode();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  // Bottom navigation methods
  void changeTab(int index) {
    print('changeTab called with index: $index');
    print('Current index before change: ${currentIndex.value}');
    
    // Handle settings tab specially to show dialog
    // if (index == 4) {
    //   _showSettingsDialog();
    //   return;
    // }
    
    currentIndex.value = index;
    print('Current index after change: ${currentIndex.value}');
  }
  
  // Mode switching methods
  void changeMode(int mode) {
    if (mode != currentMode.value) {
      // Use API call to change mode
      changeModeWithAPI(mode);
    }
  }
  
  // Sync PageView with current mode
  void syncPageWithMode() {
    if (pageController.hasClients && pageController.page?.round() != currentMode.value) {
      pageController.animateToPage(
        currentMode.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void onPageChanged(int page) {
    // Prevent multiple API calls - only allow if not currently changing mode
    if (page != currentMode.value && !isChangingMode.value) {
      currentMode.value = page;
      // Call API to change mode
      changeModeWithAPI(page);
    } else if (isChangingMode.value) {
      // Revert to previous page if mode change is in progress
      if (pageController.hasClients) {
      pageController.animateToPage(
        currentMode.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      }
    }
  }
  
  // Get current mode name
  String get currentModeName {
    return currentMode.value == 0 ? 'Personal Mode Activated' : 'Influencer Mode Activated';
  }
  
  // Get current mode color
  Color get currentModeColor {
    return currentMode.value == 0 
        ? const Color(0xFFFFB6C1) // Light pink for personal
        : const Color(0xFF7FCDCD); // Teal for influencer
  }
  
  // Show coming soon snackbar
  void _showComingSoon(String feature) {
    Get.snackbar(
      'Coming Soon',
      '$feature functionality will be available soon',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Show settings dialog
  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Settings',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zBlackColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Get.back(); // Close dialog
                logout(); // Perform logout
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Get.back();
                _showComingSoon('About');
              },
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
  
  // Load user profile from API
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      
      final userData = await UserService.fetchUserProfile();
      
      if (userData != null) {
        // Update user data
        userName.value = UserService.getUserName();
        userMode.value = UserService.getModeName();
        totalVisits.value = UserService.getTotalVisits();
        userBio.value = UserService.getUserBio();
        userAvatar?.value = UserService.getUserAvatar() ?? '';
        
        // Update current mode based on API data
        final modeIndex = UserService.getModeIndex();
        currentMode.value = modeIndex;
        
        // Update links count based on current mode
        _updateLinksCountForCurrentMode();
        
        // Only animate if PageController is attached to a PageView
        if (pageController.hasClients) {
        pageController.animateToPage(
          modeIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        }
        
        print('User profile loaded: ${userName.value} - Mode: ${userMode.value}');
        
        // Check user verification status
        _checkUserVerificationStatus();
      }
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user needs verification
  void _checkUserVerificationStatus() {
    try {
      final isVerified = UserService.isUserVerified;
      final firebaseUid = StorageService.firebaseUid;
      
      print('🔍 Home: Checking user verification status...');
      print('📋 Home: User verified: $isVerified');
      print('🆔 Home: Firebase UID: $firebaseUid');
      
      if (!isVerified && firebaseUid != null) {
        print('❗ Home: User not verified, showing OTP modal...');
        _showOtpVerificationModal(firebaseUid);
      } else if (!isVerified) {
        print('⚠️ Home: User not verified but no Firebase UID available');
      } else {
        print('✅ Home: User is verified, no action needed');
      }
    } catch (e) {
      print('💥 Home: Error checking verification status: $e');
    }
  }

  void _showOtpVerificationModal(String firebaseUid) {
    Get.dialog(
      OtpVerificationModal(
        firebaseUid: firebaseUid,
        onVerificationSuccess: () {
          print('🎉 Home: User verification completed successfully');
          // Refresh user profile to get updated verification status
          refreshUserProfile();
        },
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  // Update links count based on current mode
  void _updateLinksCountForCurrentMode() {
    final currentModeString = currentMode.value == 0 ? 'PERSONAL' : 'INFLUENCER';
    linksCount.value = UserService.getLinksCountByMode(currentModeString);
  }

  // Refresh user profile
  Future<void> refreshUserProfile() async {
    await _loadUserProfile();
  }

  // Change mode with API call
  Future<void> changeModeWithAPI(int mode) async {
    // Set loading state to prevent multiple calls
    isChangingMode.value = true;
    
    try {
      final newMode = mode == 0 ? 'PERSONAL' : 'INFLUENCER';
      
      final success = await UserService.changeUserMode(newMode);
      
      if (success) {
        // Update local state
        currentMode.value = mode;
        userMode.value = newMode;
        
        // Update links count for the new mode
        _updateLinksCountForCurrentMode();
        
        // Animate page change
        if (pageController.hasClients) {
        pageController.animateToPage(
          mode,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        }
        
        // Show success feedback
        Get.snackbar(
          'Card Mode Changed',
          newMode.toLowerCase() == "personal" ?  'Links you added in your personal mode will be shared when you tap the card.' : 'Links you added in influencer mode will be shared when you tap the card.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Revert to previous mode if API call failed
        if (pageController.hasClients) {
        pageController.animateToPage(
          currentMode.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        }
        
        Get.snackbar(
          'Error',
          'Failed to change mode. Please try again.',
          backgroundColor: Colors.red.shade400,
          colorText: AppColors.zWhiteColor,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('Error changing mode: $e');
      
      // Revert to previous mode if API call failed
      if (pageController.hasClients) {
      pageController.animateToPage(
        currentMode.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      }
      
      Get.snackbar(
        'Error',
        'Failed to change mode. Please try again.',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      // Always reset loading state
      isChangingMode.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Clear user data
      UserService.clearUserData();
      
      // Sign out from Firebase
      await FirebaseAuthService.signOut();
      
      // Navigate to login page and clear navigation stack
      Get.offAllNamed('/login');
    } catch (e) {
      // Handle logout error
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        backgroundColor: Colors.red.shade400,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
} 