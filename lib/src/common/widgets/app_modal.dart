import 'package:flutter/material.dart';
import 'package:tapyble/src/utils/index.dart';

class AppModal extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final EdgeInsets? padding;
  final double? maxWidth;

  const AppModal({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.padding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.zBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.zSecondaryBlackColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showCloseButton) ...[
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onClose ?? () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.zInputFieldBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.zSecondaryBlackColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: Container(
                width: double.infinity,
                padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: content,
              ),
            ),
            
            // Actions
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Static method to show modal
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget content,
    List<Widget>? actions,
    bool showCloseButton = true,
    VoidCallback? onClose,
    EdgeInsets? padding,
    double? maxWidth,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppModal(
        title: title,
        subtitle: subtitle,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
        onClose: onClose,
        padding: padding,
        maxWidth: maxWidth,
      ),
    );
  }
} 