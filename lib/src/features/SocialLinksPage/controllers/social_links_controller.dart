import 'package:get/get.dart';
import 'package:tapyble/src/common/services/index.dart';
import '../../HomePage/controllers/home_controller.dart';

class SocialLinksController extends GetxController {
  // Observable variables
  final RxList<Map<String, dynamic>> links = <Map<String, dynamic>>[].obs;
  final RxString currentMode = 'INFLUENCER'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Sync mode with HomeController if available and listen for changes
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      // Initial sync
      currentMode.value = home.currentMode.value == 0 ? 'PERSONAL' : 'INFLUENCER';
      // Listen to further changes
      ever<int>(home.currentMode, (modeIdx) {
        final newMode = modeIdx == 0 ? 'PERSONAL' : 'INFLUENCER';
        if (newMode != currentMode.value) {
          currentMode.value = newMode;
          loadLinks();
        }
      });
    }
    loadLinks();
  }

  // Load links for current mode
  Future<void> loadLinks() async {
    try {
      isLoading.value = true;
      
      final linksData = await SocialLinksService.getLinksByMode(currentMode.value);
      links.assignAll(linksData);
      
    } catch (e) {
      print('Error loading links: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Change mode and reload links
  Future<void> changeMode(String mode) async {
    if (mode != currentMode.value) {
      currentMode.value = mode;
      await loadLinks();
    }
  }

  // Refresh links
  Future<void> refreshLinks() async {
    await loadLinks();
  }

  // Add new link
  Future<void> addLink({
    required String platform,
    required String data,
  }) async {
    try {
      final result = await SocialLinksService.addLink(
        platform: platform,
        data: data,
        mode: currentMode.value,
      );
      
      if (result != null) {
        // Reload links to show the new one
        await loadLinks();
        
        // Refresh home page to update links count
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          print('HomeController not found, skipping refresh');
        }
      }
    } catch (e) {
      print('Error adding link: $e');
    }
  }

  // Update existing link
  Future<void> updateLink({
    required String linkId,
    required String data,
  }) async {
    try {
      final result = await SocialLinksService.updateLink(
        linkId: linkId,
        data: data,
        mode: currentMode.value,
      );
      
      if (result != null) {
        // Reload links to show the updated one
        await loadLinks();
        
        // Refresh home page to update links count
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          print('HomeController not found, skipping refresh');
        }
      }
    } catch (e) {
      print('Error updating link: $e');
    }
  }

  // Remove link
  Future<void> removeLink(String linkId) async {
    try {
      final success = await SocialLinksService.removeLink(linkId);
      
      if (success) {
        // Remove from local list
        links.removeWhere((link) => link['id'] == linkId);
        
        // Refresh home page to update links count
        try {
          final homeController = Get.find<HomeController>();
          homeController.refreshUserProfile();
        } catch (e) {
          print('HomeController not found, skipping refresh');
        }
      }
    } catch (e) {
      print('Error removing link: $e');
    }
  }

  // Check if platform is already added
  bool isPlatformAdded(String platform) {
    return links.any((link) => link['platform'] == platform);
  }

  // Get available platforms (not yet added)
  List<String> getAvailablePlatforms() {
    final addedPlatforms = links.map((link) => link['platform'] as String).toSet();
    return SocialLinksService.platforms.keys
        .where((platform) => !addedPlatforms.contains(platform))
        .toList();
  }
} 