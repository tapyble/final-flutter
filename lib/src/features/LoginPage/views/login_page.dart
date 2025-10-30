import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/common/widgets/index.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'package:tapyble/src/features/RegisterPage/index.dart';
import 'package:tapyble/src/features/LoginPageForm/index.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
            children: [
              // Logo section
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    AppLogos.logo,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              // Buttons section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Log in button (dark)
                    AppButton(
                      text: 'Log in',
                      backgroundColor: AppColors.zSecondaryBtnColor,
                      textColor: AppColors.zWhiteColor,
                      onPressed: () {
                        Get.to(() => LoginPageForm());
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Log in with card button (yellow)
                    AppButton(
                      text: 'Log in with card',
                      icon: Icons.credit_card,
                      backgroundColor: AppColors.zPrimaryBtnColor,
                      onPressed: () async {
                        bool isAvailable = await NfcManager.instance.isAvailable();

                        if (isAvailable) {
                          try {
                            // Stop any existing session first to avoid conflicts
                            try {
                              await NfcManager.instance.stopSession();
                            } catch (e) {
                              // Ignore error if no session was active
                            }
                            
                            // // Show user guidance
                            // Get.snackbar(
                            //   'NFC Ready',
                            //   'Hold your NFC card near the device',
                            //   backgroundColor: AppColors.zPrimaryBtnColor,
                            //   colorText: AppColors.zWhiteColor,
                            //   duration: const Duration(seconds: 3),
                            //   snackPosition: SnackPosition.TOP,
                            // );
                            
                            // Start NFC session
                            await NfcManager.instance.startSession(
                              pollingOptions: {
                                NfcPollingOption.iso14443,
                                NfcPollingOption.iso15693,
                                NfcPollingOption.iso18092,
                              },
                                                              onDiscovered: (NfcTag tag) async {
                                  try {
                                    debugPrint(tag.toString());
                                    Ndef? ndef = Ndef.from(tag);
                                    if (ndef == null) {
                                      print('Invalid card.');
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
                                      debugPrint('message: ${record.payload}');
                                      // assumes that the message is a list of integers representing valid UTF-16 code units. 
                                      // If you want to read the payload as a string, you can decode it here
                                      if (record.payload.isNotEmpty) {
                                        cardMessage += String.fromCharCodes(record.payload, 1, record.payload.length);
                                      }
                                    }
                                    print('message: $cardMessage');
                                    
                                    // cardMessage contains 'app.tapyble.com/share/'
                                    if (!cardMessage.contains('app.tapyble.com/share/')) {
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

                                    // get the card id from string after last '/' character
                                    String cardId = cardMessage.split('/').last;
                                    print('cardId: $cardId');
                                    
                                    // Validate card ID format
                                    if (!CardAuthService.isValidCardId(cardId)) {
                                      Get.snackbar(
                                        'Invalid Card ID',
                                        'The card ID format is not valid',
                                        backgroundColor: Colors.red,
                                        colorText: AppColors.zWhiteColor,
                                        duration: const Duration(seconds: 3),
                                        snackPosition: SnackPosition.TOP,
                                      );
                                      return;
                                    }
                                    
                                    // Show card detected message
                                    // Get.snackbar(
                                    //   'Tapyble Card Detected!',
                                    //   'Authenticating your card...',
                                    //   backgroundColor: Colors.blue,
                                    //   colorText: AppColors.zWhiteColor,
                                    //   duration: const Duration(seconds: 2),
                                    //   snackPosition: SnackPosition.TOP,
                                    // );
                                    
                                    // Authenticate with the card
                                    final authResult = await CardAuthService.signInWithCard(cardId);
                                    
                                    if (authResult != null) {
                                      // Authentication successful - navigate to home
                                      Get.offAllNamed('/home');
                                    }
                                    // If authentication failed, the error is already shown by CardAuthService
                                    
                                  } catch (e) {
                                  print('Error processing NFC tag: $e');
                                  Get.snackbar(
                                    'Error',
                                    'Failed to read the card: ${e.toString()}',
                                    backgroundColor: Colors.red,
                                    colorText: AppColors.zWhiteColor,
                                    duration: const Duration(seconds: 2),
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
                            Get.snackbar(
                              'NFC Error',
                              'Failed to start NFC: ${e.toString()}',
                              backgroundColor: Colors.red,
                              colorText: AppColors.zWhiteColor,
                              duration: const Duration(seconds: 3),
                              snackPosition: SnackPosition.TOP,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'NFC not available',
                            'Please check your NFC settings',
                            backgroundColor: AppColors.zSecondaryBtnColor,
                            colorText: AppColors.zWhiteColor,
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Create account section
                    _buildCreateAccountSection(context),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildCreateAccountSection(BuildContext context) {
    return Column(
      children: [
        Text(
          "Don't have an account?",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.zSecondaryBlackColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Get.to(() => RegisterPage());
          },
          child: Text(
            'Create account',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.zPrimaryBtnColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 