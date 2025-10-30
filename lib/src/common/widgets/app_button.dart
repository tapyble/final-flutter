import 'package:flutter/material.dart';
import 'package:tapyble/src/utils/index.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? iconAsset;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.icon,
    this.iconAsset,
    this.backgroundColor,
    required this.onPressed,
    this.textColor,
    this.width,
    this.height = 56,
  }) : assert(icon == null || iconAsset == null, 'Cannot provide both icon and iconAsset');

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.zPrimaryBtnColor;
    final txtColor = textColor ?? _getTextColor(bgColor);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: txtColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: (icon != null || iconAsset != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      size: 20,
                      color: txtColor,
                    )
                  else if (iconAsset != null)
                    Image.asset(
                      iconAsset!,
                      width: 20,
                      height: 20,
                      color: txtColor,
                    ),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: AppTextStyles.bodySmall.copyWith(
                                  color: txtColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                  ),
                ],
              )
            : Text(
                text,
                style: AppTextStyles.bodySmall.copyWith(
                                 color: txtColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
              ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    // If background is dark (like zSecondaryBtnColor), use white text
    if (backgroundColor == AppColors.zSecondaryBtnColor ||
        backgroundColor == AppColors.zBlackColor) {
      return AppColors.zWhiteColor;
    }
    // If background is light (like zPrimaryBtnColor), use black text
    return AppColors.zBlackColor;
  }
} 