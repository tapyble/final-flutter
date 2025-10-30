import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/connected_card_controller.dart';
import '../../../utils/index.dart';
import '../../../common/widgets/index.dart';
import 'package:tapyble/src/common/services/storage_service.dart';

class ConnectedCardPage extends StatelessWidget {
  const ConnectedCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConnectedCardController());

    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Column(
          children: [
             Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  
                  Expanded(
                    child: Text(
                      'My Cards',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // refresh the connected cards
                    },
                    icon: const Icon(Icons.refresh),
                    color: AppColors.zBlackColor,
                  ),
                ],
              ),
            ),


            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.zPrimaryBtnColor),
                    ),
                  );
                }

                if (controller.devices.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return _buildDevicesList(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ConnectedCardController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Elevated illustration container
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.zWhiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.nfc_outlined,
              size: 80,
              color: AppColors.zSecondaryBlackColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No Connected Cards',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.zBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Connect your first NFC card to get started.\nTap the button below to scan a new card.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.zSecondaryBlackColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildConnectButton(controller),
        ],
      ),
    );
  }

  Widget _buildDevicesList(ConnectedCardController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: controller.devices.length + 1, // +1 for connect button
      itemBuilder: (context, index) {
        if (index == controller.devices.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildConnectButton(controller),
          );
        }

        final device = controller.devices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildDeviceCard(device, controller),
        );
      },
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, ConnectedCardController controller) {
    // Try different possible field names for the image
    final imageUrl = device['image_url'] as String? ?? 
                    device['image'] as String? ?? 
                    device['card_image'] as String? ??
                    device['card_image_url'] as String?;
    final uid = device['uid'] as String;
    
    // Debug: Print device data and image URL
    print('Device card data: $device');
    print('Image URL: $imageUrl');
    print('Available keys: ${device.keys.toList()}');
    
    // Additional debugging for image URL
    if (imageUrl != null && imageUrl.isNotEmpty) {
      print('Image URL is valid: $imageUrl');
      print('Image URL length: ${imageUrl.length}');
      print('Image URL starts with http: ${imageUrl.startsWith('http')}');
    } else {
      print('Image URL is null or empty');
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Card Image or Gradient
            Container(
              height: 220,
              width: double.infinity,
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      headers: {
                        'User-Agent': 'Mozilla/5.0 (compatible; Tapyble/1.0)',
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: AppColors.zWhiteColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.zPrimaryBtnColor),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image loading error: $error');
                        print('Image URL that failed: $imageUrl');
                        return _buildGradientFallback();
                      },
                    )
                  : _buildGradientFallback(),
            ),
            
            // Close button with enhanced elevation
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                final firebaseUid = StorageService.firebaseUid;
                if (firebaseUid == null || firebaseUid.isEmpty) {
                  Get.snackbar(
                    'Not Allowed',
                    'Connect your account first before deleting cards.',
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }
                _showDeleteCardConfirmation(Get.context!, controller, uid);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red[600],
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // Connected badge with enhanced elevation
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Connected',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.zPrimaryBtnColor.withOpacity(0.8),
            AppColors.zPrimaryBtnColor.withOpacity(0.6),
            AppColors.zPrimaryBtnColor.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.nfc,
          size: 48,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildConnectButton(ConnectedCardController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.zPrimaryBtnColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.zPrimaryBtnColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GetBuilder<ConnectedCardController>(
        builder: (controller) => controller.isAddingDevice.value
            ? Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.zPrimaryBtnColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.zBlackColor),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Scanning...',
                        style: TextStyle(
                          color: AppColors.zBlackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppButton(
                text: 'Connect New Card',
                backgroundColor: AppColors.zPrimaryBtnColor,
                textColor: AppColors.zBlackColor,
                iconAsset: AppIcons.nfc,
                onPressed: controller.addDeviceViaNFC,
              ),
      ),
    );
  }

  void _showDeleteCardConfirmation(BuildContext context, ConnectedCardController controller, String uid) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Delete Card',
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
              // Warning Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Are you sure you want to delete this NFC card? This action cannot be undone.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.zBlackColor),
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
                        border: Border.all(color: AppColors.zSecondaryBlackColor.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.zSecondaryBlackColor, fontWeight: FontWeight.w600)),
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
                          Get.back();
                          await controller.removeDevice(uid);
                        },
                        child: Text('Delete', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
} 