// Example usage of utilities
// Delete this file after understanding the usage patterns

import 'package:flutter/material.dart';
import 'package:tapyble/src/utils/index.dart';

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using app colors
      backgroundColor: AppColors.zBgColor,
      appBar: AppBar(
        title: Text(
          AppConstants.zAppName, // Using app constants
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.zWhiteColor,
          ),
        ),
        backgroundColor: AppColors.zBlackColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.zDefaultPadding), // Using constants
        child: Column(
          children: [
            // Example heading
            Text(
              'Welcome to ${AppConstants.zAppName}',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.zBlackColor,
              ),
            ),
            
            SizedBox(height: AppConstants.zDefaultMargin),
            
            // Example body text
            Text(
              'This is an example of using our utility classes.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.zSecondaryBlackColor,
              ),
            ),
            
            SizedBox(height: AppConstants.zDefaultMargin * 2),
            
            // Example primary button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zPrimaryBtnColor,
                foregroundColor: AppColors.zBlackColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.zDefaultPadding * 2,
                  vertical: AppConstants.zDefaultPadding,
                ),
              ),
              child: Text(
                'Primary Button',
                style: AppTextStyles.buttonLarge,
              ),
            ),
            
            SizedBox(height: AppConstants.zDefaultMargin),
            
            // Example secondary button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.zSecondaryBtnColor,
                foregroundColor: AppColors.zWhiteColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.zDefaultPadding * 2,
                  vertical: AppConstants.zDefaultPadding,
                ),
              ),
              child: Text(
                'Secondary Button',
                style: AppTextStyles.buttonLarge,
              ),
            ),
            
            SizedBox(height: AppConstants.zDefaultMargin * 2),
            
            // Example input field
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your text here',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.zSecondaryBlackColor,
                ),
                filled: true,
                fillColor: AppColors.zInputFieldBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppConstants.zDefaultPadding),
              ),
              style: AppTextStyles.bodyMedium,
            ),
            
            SizedBox(height: AppConstants.zDefaultMargin * 2),
            
            // Example custom styled text using AppFonts directly
            Text(
              'Custom styled text using AppFonts.rubik()',
              style: AppFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.zPrimaryBtnColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 