import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'package:tapyble/src/features/HomePage/controllers/home_controller.dart';
import 'package:tapyble/src/features/SettingsPage/controllers/settings_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    Get.put(SettingsController()); // Initialize settings controller
    
    // Ensure PageView syncs with current mode when page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.syncPageWithMode();
    });

    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // Loading indicator
            if (controller.isLoading.value)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.zSecondaryBtnColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            
            // Mode indicator banner
            if (!controller.isLoading.value)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.currentModeColor,
                      controller.currentModeColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: controller.currentModeColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  Text(
                                    controller.userMode.value,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.zBlackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: AppColors.zBlackColor.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${controller.totalVisits.value} visits',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.zBlackColor.withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.link,
                                    size: 16,
                                    color: AppColors.zBlackColor.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => controller.changeTab(1),
                                    child: Text(
                                      '${controller.linksCount.value} links',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.zBlackColor.withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.zWhiteColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.zWhiteColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () => controller.changeTab(1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.link,
                                  size: 14,
                                  color: AppColors.zBlackColor.withValues(alpha: 0.8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Links',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.zBlackColor.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            // Card section with swipe functionality
            Expanded(
              child: Column(
                children: [
                  // Card area with indicators
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card
                          Container(
                            child: AspectRatio(
                              aspectRatio: 3 / 2, // 3:2 ratio preserved
                              child: PageView(
                                controller: controller.pageController,
                                onPageChanged: controller.onPageChanged,
                                children: [
                                  _buildCard(context, controller, isPersonal: true),
                                  _buildCard(context, controller, isPersonal: false),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 10),
                          
                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIndicator(controller.currentMode.value == 0, controller),
                              const SizedBox(width: 8),
                              _buildIndicator(controller.currentMode.value == 1, controller),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Swipe instruction
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.swipe,
                                  size: 16,
                                  color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Swipe to change mode',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Edit mode button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      text: controller.isChangingMode.value ? 'Changing...' : 'Add New Link',
                      backgroundColor: controller.isChangingMode.value 
                          ? AppColors.zSecondaryBlackColor.withValues(alpha: 0.3)
                          : AppColors.zPrimaryBtnColor,
                      icon: controller.isChangingMode.value ? Icons.hourglass_empty : Icons.add_rounded,
                      onPressed: () {
                        // Change to Links tab (index 1)
                        controller.changeTab(1);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Preview profile button
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      text: 'Preview Profile',
                      icon: Icons.visibility_outlined,
                      backgroundColor: AppColors.zSecondaryBtnColor,
                      onPressed: () async {
                        final username = UserService.getUsername();
                        if (username.isNotEmpty) {
                          final url = 'https://app.tapyble.com/$username';
                          try {
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              Get.snackbar(
                                'Error',
                                'Could not open profile link',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Could not open profile link',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                              snackPosition: SnackPosition.TOP,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            'Username not available',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildCard(BuildContext context, HomeController controller, {required bool isPersonal}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zPrimaryBtnColor.withAlpha(26),
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode indicator at top
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPersonal ? AppColors.zPinkColor : AppColors.zTealColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPersonal ? Icons.person : Icons.star,
                      color: isPersonal ? AppColors.zPinkColor : AppColors.zTealColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPersonal ? 'Personal mode activated in card' : 'Influencer mode activated in card',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Content row with text and profile image
              Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, I am',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w200,
                            fontSize: 16
                          ),
                        ),
                        Obx(() => Text(
                          controller.userName.value.isNotEmpty 
                              ? controller.userName.value 
                              : 'tapyble',
                          style: AppTextStyles.heading4.copyWith(
                            color: AppColors.zBlackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            // linespacing
                            height: 1.1
                          ),
                        )),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Right side - Profile image with edit functionality
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        // Profile image (clickable for image upload)
                        GestureDetector(
                          onTap: () {
                            Get.find<SettingsController>().pickImage();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: isPersonal ? AppColors.zPinkColor : AppColors.zTealColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (isPersonal ? AppColors.zPinkColor : AppColors.zTealColor).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: controller.userAvatar?.value.isNotEmpty == true
                                  ? Image.network(
                                      controller.userAvatar!.value,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: isPersonal ? AppColors.zPinkColor : AppColors.zTealColor,
                                          child: Icon(
                                            Icons.person_outline_rounded,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: isPersonal ? AppColors.zPinkColor : AppColors.zTealColor,
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        
                        // Edit profile button (top right corner)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showEditProfileModal(Get.find<SettingsController>());
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.zPrimaryBtnColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.zWhiteColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.zWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive, HomeController controller) {
    // Get the appropriate color based on current mode
    final Color indicatorColor = controller.currentMode.value == 0 
        ? AppColors.zPinkColor 
        : AppColors.zTealColor;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 32 : 12,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive 
            ? LinearGradient(
                colors: [
                  indicatorColor,
                  indicatorColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive 
            ? null
            : AppColors.zSecondaryBlackColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        boxShadow: isActive ? [
          BoxShadow(
            color: indicatorColor.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: indicatorColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ] : null,
        border: isActive ? null : Border.all(
          color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
    );
  }

  void _showEditProfileModal(SettingsController controller) {
    // Refresh form data before showing modal
    controller.refreshFormData();
    
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.zInputFieldBgColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Edit Profile',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.zInputFieldBgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.zBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildProfileForm(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(SettingsController controller) {
    return Column(
      children: [
        // Name Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AppInputField(
              controller: controller.nameController,
              hintText: 'Enter your name',
              onChanged: (value) {
                if (value.length <= 15) {
                  controller.hasChanges.value = true;
                } else {
                  controller.nameController.text = value.substring(0, 15);
                  controller.nameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: 15),
                  );
                }
              },
            ),
            const SizedBox(height: 4),
            GetBuilder<SettingsController>(
              builder: (controller) => Text(
                '${controller.nameController.text.length}/15',
                style: AppTextStyles.bodySmall.copyWith(
                  color: controller.nameController.text.length > 15 
                      ? Colors.red 
                      : AppColors.zSecondaryBlackColor,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Bio Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AppInputField(
              controller: controller.bioController,
              hintText: 'Tell us about yourself',
              maxLines: 3,
              onChanged: (value) {
                if (value.length <= 50) {
                  controller.hasChanges.value = true;
                } else {
                  controller.bioController.text = value.substring(0, 50);
                  controller.bioController.selection = TextSelection.fromPosition(
                    TextPosition(offset: 50),
                  );
                }
              },
            ),
            const SizedBox(height: 4),
            GetBuilder<SettingsController>(
              builder: (controller) => Text(
                '${controller.bioController.text.length}/50',
                style: AppTextStyles.bodySmall.copyWith(
                  color: controller.bioController.text.length > 50 
                      ? Colors.red 
                      : AppColors.zSecondaryBlackColor,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Website Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Website',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            AppInputField(
              controller: controller.websiteController,
              hintText: 'yourwebsite.com',
              onChanged: (value) {
                controller.hasChanges.value = true;
              },
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.zBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => Container(
                height: 48,
                decoration: BoxDecoration(
                  color: controller.isSaving.value ? AppColors.zInputFieldBgColor : AppColors.zPrimaryBtnColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: controller.isSaving.value ? null : () {
                    controller.saveProfile();
                    Get.back();
                  },
                  child: Text(
                    controller.isSaving.value ? 'Saving...' : 'Save Changes',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.zBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ],
    );
  }

}