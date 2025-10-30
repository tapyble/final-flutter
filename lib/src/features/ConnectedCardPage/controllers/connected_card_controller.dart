import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'package:tapyble/src/utils/index.dart';

class ConnectedCardController extends GetxController {
  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool isAddingDevice = false.obs;
  
  // Device data
  final RxList<Map<String, dynamic>> devices = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadDevices();
  }
  
  // Load user devices
  Future<void> loadDevices() async {
    try {
      isLoading.value = true;
      final deviceList = await DeviceService.fetchUserDevices();
      
      if (deviceList != null) {
        devices.value = deviceList;
        print('Loaded ${deviceList.length} devices');
        // Debug: Print device data structure
        for (var device in deviceList) {
          print('Device data: $device');
        }
      }
    } catch (e) {
      print('Error loading devices: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Refresh devices
  Future<void> refreshDevices() async {
    await loadDevices();
  }
  
  // Remove device
  Future<void> removeDevice(String uid) async {
    try {
      final success = await DeviceService.removeDevice(uid);
      
      if (success) {
        // Remove device from local list
        devices.removeWhere((device) => device['uid'] == uid);
      }
    } catch (e) {
      print('Error removing device: $e');
    }
  }
  
  // Add device via NFC
  Future<void> addDeviceViaNFC() async {
    if (isAddingDevice.value) return;
    
    try {
      isAddingDevice.value = true;
      
      bool isAvailable = await NfcManager.instance.isAvailable();
      
      if (!isAvailable) {
        Get.snackbar(
          'NFC not available',
          'Please check your NFC settings',
          backgroundColor: Colors.green,
        colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      
      // Stop any existing session first
      try {
        await NfcManager.instance.stopSession();
      } catch (e) {
        // Ignore error if no session was active
      }
      
      // Show scanning dialog
      Get.dialog(
        AlertDialog(
          title: Text(
            'Scan NFC Card',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.zBlackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.nfc,
                size: 64,
                color: AppColors.zPrimaryBtnColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Hold your tapyble card near the device to connect it to your account.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.zBlackColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                NfcManager.instance.stopSession();
                Get.back();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.zSecondaryBlackColor),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      
      // Start NFC session
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            print('NFC tag discovered: $tag');
            
            Ndef? ndef = Ndef.from(tag);
            if (ndef == null) {
              print('Invalid card - no NDEF support');
              Get.back(); // Close dialog
              Get.snackbar(
                'Invalid Card',
                'This card is not compatible with our system',
                backgroundColor: Colors.red,
                colorText: AppColors.zWhiteColor,
                duration: const Duration(seconds: 3),
                snackPosition: SnackPosition.TOP,
              );
              return;
            }
            
            var cardMessage = '';
            final ndefRecords = ndef.cachedMessage?.records ?? [];
            
            for (var record in ndefRecords) {
              print('Record payload: ${record.payload}');
              if (record.payload.isNotEmpty) {
                cardMessage += String.fromCharCodes(record.payload, 1, record.payload.length);
              }
            }
            
            print('Card message: $cardMessage');
            
            // Validate card message format
            if (!cardMessage.contains('app.tapyble.com/share/')) {
              Get.back(); // Close dialog
              Get.snackbar(
                'Invalid Card',
                'This card is not a valid tapyble card',
                backgroundColor: Colors.red,
                colorText: AppColors.zWhiteColor,
                duration: const Duration(seconds: 3),
                snackPosition: SnackPosition.TOP,
              );
              return;
            }
            
            // Extract the full URL from the card message
            String deviceUrl = cardMessage.trim();
            print('Device URL: $deviceUrl');
            
            // Validate URL format
            if (!cardMessage.contains('app.tapyble.com/share/')) {
              Get.back(); // Close dialog
              Get.snackbar(
                'Invalid Card URL',
                'The card URL format is not valid',
                backgroundColor: Colors.red,
                colorText: AppColors.zWhiteColor,
                duration: const Duration(seconds: 3),
                snackPosition: SnackPosition.TOP,
              );
              return;
            }
            
            Get.back(); // Close scanning dialog
            
            // Add device to user account
            final updatedDevices = await DeviceService.addDevice("https://$deviceUrl");
            
            if (updatedDevices != null) {
              devices.value = updatedDevices;
            }
            
          } catch (e) {
            print('Error processing NFC tag: $e');
            Get.back(); // Close dialog
            Get.snackbar(
              'Error',
              'Failed to read the card: ${e.toString()}',
              backgroundColor: Colors.red,
              colorText: AppColors.zWhiteColor,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.TOP,
            );
          } finally {
            // Always stop the session when done
            await NfcManager.instance.stopSession();
          }
        },
      );
      
    } catch (e) {
      print('NFC Session Error: $e');
      Get.back(); // Close dialog if open
      Get.snackbar(
        'NFC Error',
        'Failed to start NFC: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: AppColors.zWhiteColor,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isAddingDevice.value = false;
    }
  }
  
  // Show remove device confirmation
  void showRemoveConfirmation(Map<String, dynamic> device) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Remove Card',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zBlackColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to remove this card from your account?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.zBlackColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Card ID: ${device['uid']}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.zSecondaryBlackColor,
                fontWeight: FontWeight.w600,
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
              removeDevice(device['uid']);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 