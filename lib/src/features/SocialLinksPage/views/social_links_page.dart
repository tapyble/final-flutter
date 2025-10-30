import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'package:tapyble/src/features/SocialLinksPage/controllers/social_links_controller.dart';

class SocialLinksPage extends StatelessWidget {
  const SocialLinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SocialLinksController controller = Get.put(SocialLinksController());

    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  
                  Expanded(
                    child: Text(
                      'My Links',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.refreshLinks(),
                    icon: const Icon(Icons.refresh),
                    color: AppColors.zBlackColor,
                  ),
                ],
              ),
            ),

            // Mode selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildModeSelector(controller),
            ),

            const SizedBox(height: 20),

            // Loading indicator
            if (controller.isLoading.value)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.zWhiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.zPrimaryBtnColor,
                  ),
                ),
              ),

            // Links list
            if (!controller.isLoading.value)
              Expanded(
                child: controller.links.isEmpty
                    ? _buildEmptyState()
                    : _buildLinksList(controller),
              ),

            // Add link button
            if (!controller.isLoading.value)
              Container(
                margin: const EdgeInsets.all(20),
                child: AppButton(
                  text: 'Add New Link',
                  backgroundColor: AppColors.zPrimaryBtnColor,
                  icon: Icons.add,
                  onPressed: () => _showAddLinkDialog(context, controller),
                ),
              ),
          ],
        )),
      ),
    );
  }

  Widget _buildModeSelector(SocialLinksController controller) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.zBlackColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: controller.currentMode.value == 'PERSONAL'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: MediaQuery.of(Get.context!).size.width / 2 - 30,
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: controller.currentMode.value == 'PERSONAL'
                    ? AppColors.zPinkColor.withOpacity(0.18)
                    : AppColors.zTealColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (controller.currentMode.value == 'PERSONAL'
                            ? AppColors.zPinkColor
                            : AppColors.zTealColor)
                        .withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeMode('PERSONAL'),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                            color: controller.currentMode.value == 'PERSONAL'
                                ? AppColors.zPinkColor
                                : AppColors.zSecondaryBlackColor,
                            size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Personal',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: controller.currentMode.value == 'PERSONAL'
                                ? AppColors.zPinkColor
                                : AppColors.zSecondaryBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeMode('INFLUENCER'),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star,
                            color: controller.currentMode.value == 'INFLUENCER'
                                ? AppColors.zTealColor
                                : AppColors.zSecondaryBlackColor,
                            size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Influencer',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: controller.currentMode.value == 'INFLUENCER'
                                ? AppColors.zTealColor
                                : AppColors.zSecondaryBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.zBlackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 64,
            color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Social Links',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.zBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your social media links to share with others',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.zSecondaryBlackColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksList(SocialLinksController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: controller.links.length,
      itemBuilder: (context, index) {
        final link = controller.links[index];
        return _buildLinkCard(link, controller);
      },
    );
  }

  Widget _buildLinkCard(Map<String, dynamic> link, SocialLinksController controller) {
    final platform = link['platform'] as String;
    final data = link['data'] as String;
    final linkId = link['id'] as String;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.zBlackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/social-icons/${SocialLinksService.getPlatformIcon(platform)}',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.link,
                    size: 24,
                    color: AppColors.zPrimaryBtnColor,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          SocialLinksService.getPlatformName(platform),
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.zBlackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          SocialLinksService.getDisplayData(platform, data),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.zSecondaryBlackColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _buildCustomPopupMenu(Get.context!, controller, link),
      ),
    );
  }

  Widget _buildCustomPopupMenu(BuildContext context, SocialLinksController controller, Map<String, dynamic> link) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColors.zWhiteColor,
      offset: const Offset(0, 36),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.zTealColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: AppColors.zTealColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Edit', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Delete', style: AppTextStyles.bodyMedium.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          _showEditLinkDialog(context, controller, link);
        } else if (value == 'delete') {
          _showDeleteConfirmation(context, controller, link['id']);
        }
      },
      icon: const Icon(Icons.more_vert, color: AppColors.zSecondaryBlackColor),
    );
  }

  void _showAddLinkDialog(BuildContext context, SocialLinksController controller) {
    final selectedPlatform = RxString('');
    final linkData = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_link,
                      color: AppColors.zPrimaryBtnColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Add Link',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: AppColors.zSecondaryBlackColor,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Platform dropdown
              Obx(() => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedPlatform.value.isEmpty ? null : selectedPlatform.value,
                  decoration: const InputDecoration(
                    labelText: 'Select Platform',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: SocialLinksService.platforms.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/social-icons/${entry.value['icon']}',
                                width: 20,
                                height: 20,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.link,
                                    size: 20,
                                    color: AppColors.zPrimaryBtnColor,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            entry.value['name']!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.zBlackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPlatform.value = value;
                    }
                  },
                ),
              )),
              
              const SizedBox(height: 20),
              
              // // Platform instructions (show when platform is selected)
              // Obx(() => selectedPlatform.value.isNotEmpty
              //     ? Container(
              //         padding: const EdgeInsets.all(16),
              //         margin: const EdgeInsets.only(bottom: 16),
              //         decoration: BoxDecoration(
              //           color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.05),
              //           borderRadius: BorderRadius.circular(12),
              //           border: Border.all(
              //             color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
              //             width: 1,
              //           ),
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Row(
              //               children: [
              //                 Icon(
              //                   Icons.info_outline,
              //                   color: AppColors.zPrimaryBtnColor,
              //                   size: 20,
              //                 ),
              //                 const SizedBox(width: 8),
              //                 Text(
              //                   'How to get your link:',
              //                   style: AppTextStyles.bodyMedium.copyWith(
              //                     color: AppColors.zBlackColor,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             const SizedBox(height: 8),
              //             Text(
              //               SocialLinksService.getPlatformInstructions(selectedPlatform.value),
              //               style: AppTextStyles.bodySmall.copyWith(
              //                 color: AppColors.zSecondaryBlackColor,
              //                 height: 1.4,
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox.shrink()),
              
              // Link data input
              Obx(() => Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: linkData,
                  decoration: InputDecoration(
                    labelText: selectedPlatform.value.isNotEmpty
                        ? SocialLinksService.getPlatformLabel(selectedPlatform.value)
                        : 'Link or Username',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: selectedPlatform.value.isNotEmpty
                        ? SocialLinksService.getPlatformHint(selectedPlatform.value)
                        : 'https://example.com or @username',
                    hintStyle: const TextStyle(color: AppColors.zSecondaryBlackColor),
                  ),
                ),
              )),
              
              const SizedBox(height: 24),
              
              // Action buttons
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
                            color: AppColors.zSecondaryBlackColor,
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
                        onPressed: () async {
                          if (selectedPlatform.value.isNotEmpty && linkData.text.isNotEmpty) {
                            Get.back(); // Close dialog first
                            // Format data with appropriate prefix
                            final formattedData = SocialLinksService.formatPlatformData(
                              selectedPlatform.value,
                              linkData.text,
                            );
                            await controller.addLink(
                              platform: selectedPlatform.value,
                              data: formattedData,
                            );
                          }
                        },
                        child: Text(
                          'Add Link',
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

  void _showEditLinkDialog(BuildContext context, SocialLinksController controller, Map<String, dynamic> link) {
    // Show display data (without prefixes) for editing
    final displayData = SocialLinksService.getDisplayData(link['platform'], link['data']);
    final linkData = TextEditingController(text: displayData);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: AppColors.zPrimaryBtnColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Edit Link',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: AppColors.zSecondaryBlackColor,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Platform info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/social-icons/${SocialLinksService.getPlatformIcon(link['platform'])}',
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.link,
                              size: 24,
                              color: AppColors.zPrimaryBtnColor,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SocialLinksService.getPlatformName(link['platform']),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.zBlackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Platform',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.zSecondaryBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Link data input
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: linkData,
                  decoration: InputDecoration(
                    labelText: SocialLinksService.getPlatformLabel(link['platform']),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: 'https://example.com or @username',
                    hintStyle: const TextStyle(color: AppColors.zSecondaryBlackColor),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
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
                            color: AppColors.zSecondaryBlackColor,
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
                        onPressed: () async {
                          if (linkData.text.isNotEmpty) {
                            Get.back(); // Close dialog first
                            // Format data with appropriate prefix
                            final formattedData = SocialLinksService.formatPlatformData(
                              link['platform'],
                              linkData.text,
                            );
                            await controller.updateLink(
                              linkId: link['id'],
                              data: formattedData,
                            );
                          }
                        },
                        child: Text(
                          'Update Link',
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

  void _showDeleteConfirmation(BuildContext context, SocialLinksController controller, String linkId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Delete Link',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: AppColors.zSecondaryBlackColor,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Warning message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Are you sure you want to delete this social link? This action cannot be undone.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.zBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
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
                            color: AppColors.zSecondaryBlackColor,
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
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          Get.back(); // Close dialog first
                          await controller.removeLink(linkId);
                        },
                        child: Text(
                          'Delete',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.zWhiteColor,
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
} 