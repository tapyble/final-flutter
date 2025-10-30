import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/settings_controller.dart';
import '../../../utils/index.dart';
import '../../../common/widgets/index.dart';
import '../../HomePage/controllers/home_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  Text(
                    'Settings',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.zBlackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      _buildProfileSection(controller),
                      
                      const SizedBox(height: 24),
                      
                      // Account Settings
                      _buildAccountSection(controller),
                      
                      const SizedBox(height: 24),
                      
                      // Device & Purchase Section
                      _buildDeviceSection(controller),
                      
                      const SizedBox(height: 24),
                      
                      // Legal & Account Section
                      _buildSupportSection(controller),
                      
                      const SizedBox(height: 32),
                      
                      // Logout Button
                      _buildLogoutButton(controller),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(SettingsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar Section
          GestureDetector(
            onTap: () => controller.pickImage(),
            child: Stack(
              children: [
                Obx(() => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.zPrimaryBtnColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.zPrimaryBtnColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: controller.userAvatar.value.isNotEmpty
                        ? Image.network(
                            controller.userAvatar.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.zPrimaryBtnColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.zWhiteColor, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // User Info
          Obx(() => Column(
            children: [
              Text(
                controller.userName.value.isNotEmpty ? controller.userName.value : 'Your Name',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.zBlackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'app.tapyble.com/${controller.userUsername.value.isNotEmpty ? controller.userUsername.value : 'username'}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.zSecondaryBlackColor,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildAccountSection(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernSettingsItem(
            icon: Icons.person_outline,
            iconColor: AppColors.zPrimaryBtnColor,
            title: 'Edit profile',
            onTap: () => _showEditProfileModal(controller),
            isFirst: true,
          ),
          _buildDivider(),
          _buildModernSettingsItem(
            icon: Icons.alternate_email,
            iconColor: Colors.blue,
            title: 'Change username',
            onTap: () => _showChangeUsernameModal(controller),
            isLast: !controller.shouldShowConnectSocial, // Last if no connect button
          ),
          // Only show Connect with Apple/Google if firebase_uid is empty
          if (controller.shouldShowConnectSocial) ...[
            _buildDivider(),
            _buildModernSettingsItem(
              icon: Icons.link,
              iconColor: Colors.green,
              title: 'Connect with Apple / Google',
              onTap: () => controller.connectSocialAccount(),
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceSection(SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernSettingsItem(
            icon: Icons.devices_outlined,
            iconColor: Colors.blue,
            title: 'My cards',
            onTap: () {
              Get.back(); // Close settings
              final homeController = Get.find<HomeController>();
              homeController.currentIndex.value = 3; // Navigate to ConnectedCardPage
            },
            isFirst: true,
          ),
          _buildDivider(),
          _buildModernSettingsItem(
            icon: Icons.shopping_cart_outlined,
            iconColor: Colors.green,
            title: 'Purchase a tapyble device',
            onTap: () => controller.launchUrl('https://tapyble.com/products/tapyble-nfc-card'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(SettingsController controller) {
    // Legal & Account section with Terms of Service, Privacy Policy, and Delete Account
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernSettingsItem(
            icon: Icons.description_outlined,
            iconColor: Colors.purple,
            title: 'Terms of Service',
            onTap: () => controller.launchUrl('https://tapyble.com/policies/terms-of-service'),
            isFirst: true,
          ),
          _buildDivider(),
          _buildModernSettingsItem(
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.teal,
            title: 'Privacy Policy',
            onTap: () => controller.launchUrl('https://tapyble.com/policies/privacy-policy'),
          ),
          _buildDivider(),
          _buildModernSettingsItem(
            icon: Icons.delete_forever,
            iconColor: Colors.red.shade700,
            title: 'Delete Account',
            onTap: () => controller.deleteAccount(),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.zBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.zSecondaryBlackColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 56),
      height: 1,
      color: AppColors.zInputFieldBgColor,
    );
  }

  Widget _buildLogoutButton(SettingsController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.logout(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Log out',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  void _showChangeUsernameModal(SettingsController controller) {
    final TextEditingController usernameController = TextEditingController();
    usernameController.text = controller.usernameController.text;
    
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.6,
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
                      'Change Username',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.zBlackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppInputField(
                        controller: usernameController,
                        hintText: 'Enter username',
                        onChanged: (value) {
                          // Username validation will be handled in save
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Username must be 6-20 characters',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.zSecondaryBlackColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.zInputFieldBgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.zPrimaryBtnColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: AppColors.zSecondaryBlackColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'app.tapyble.com/${usernameController.text.isEmpty ? 'username' : usernameController.text}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.zSecondaryBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                onPressed: controller.isSaving.value ? null : () async {
                                  final username = usernameController.text.trim();
                                  
                                  // Call the API to update username
                                  final success = await controller.updateUsername(username);
                                  
                                  // Wait 3 seconds before closing the modal
                                  await Future.delayed(const Duration(seconds: 3));
                                  Get.back();
                                  
                                },
                                child: Text(
                                  controller.isSaving.value ? 'Updating...' : 'Update Username',
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _showRatingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rate tapyble',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.zBlackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We\'d love to hear your feedback!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.zSecondaryBlackColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.zInputFieldBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Later',
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
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.zPrimaryBtnColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                          // TODO: Open app store rating
                        },
                        child: Text(
                          'Rate Now',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.zBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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