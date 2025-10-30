import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/user_service.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  String? username;
  String? profileUrl;
  bool isLoading = true;
  final GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserService.fetchUserProfile();
      if (userData != null && userData['username'] != null) {
        setState(() {
          username = userData['username'];
          profileUrl = 'https://app.tapyble.com/$username';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          'Error',
          'Could not load user data',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load user data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _shareProfile() {
    if (profileUrl == null) {
      Get.snackbar(
        'Error',
        'Profile URL not available',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      Share.share(
        profileUrl!,
        subject: 'Check out my tapyble profile!',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not share profile link',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> _saveQRCode() async {
    try {
      // Capture the QR code widget as an image
      final RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save to gallery using gal package
      await Gal.putImageBytes(
        pngBytes,
        name: 'tapyble_qr_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      Get.snackbar(
        'Success',
        'QR code saved to gallery',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Error saving QR code: $e');
      Get.snackbar(
        'Error',
        'Could not save QR code: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Share Profile',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.zBlackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // QR Code section
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isLoading)
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.zPrimaryBtnColor),
                              )
                            else if (profileUrl != null)
                              // QR Code with logo
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.zWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.zBlackColor.withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: RepaintBoundary(
                                  key: qrKey,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      QrImageView(
                                        data: profileUrl!,
                                        version: QrVersions.auto,
                                        size: 200,
                                        backgroundColor: AppColors.zWhiteColor,
                                        foregroundColor: Colors.black,
                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.circle, // rounded square corners
                                          color: Colors.black,
                                        ),
                                        dataModuleStyle: const QrDataModuleStyle(
                                          dataModuleShape: QrDataModuleShape.circle, // circular dots
                                          color: Colors.black,
                                        ),
                                      ),
                                      // Tapyble logo overlay
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.zWhiteColor,
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Image.asset(
                                            AppLogos.icon,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.zWhiteColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.zBlackColor.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.zBlackColor,
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 30),
                            
                            // Instructions
                            Text(
                              'Scan this QR code to visit\nyour tapyble profile',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.zBlackColor,
                                height: 1.4,
                              ),
                            ),
                            
                            if (profileUrl != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.zPrimaryBtnColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "@${username!}",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.zBlackColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    // Buttons
                    Column(
                      children: [
                        // Save QR code button
                        AppButton(
                          text: 'Save QR code',
                          backgroundColor: AppColors.zPrimaryBtnColor,
                          textColor: AppColors.zBlackColor,
                          iconAsset: AppIcons.download,
                          onPressed: profileUrl != null ? () => _saveQRCode() : () {},
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Share your profile button
                        AppButton(
                          text: 'Share your profile',
                          backgroundColor: AppColors.zSecondaryBtnColor,
                          textColor: AppColors.zWhiteColor,
                          iconAsset: AppIcons.upload,
                          onPressed: profileUrl != null ? () => _shareProfile() : () {},
                        ),
                        
                        const SizedBox(height: 20),
                      ],
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
}

 