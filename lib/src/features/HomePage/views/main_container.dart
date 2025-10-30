import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/features/HomePage/controllers/home_controller.dart';
import 'package:tapyble/src/features/HomePage/views/home_page.dart';
import 'package:tapyble/src/features/SharePage/index.dart';
import 'package:tapyble/src/features/SocialLinksPage/index.dart';
import 'package:tapyble/src/features/ConnectedCardPage/index.dart';
import 'package:tapyble/src/features/SettingsPage/index.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        print('Body Obx rebuilding with index: ${controller.currentIndex.value}');
        return _buildCurrentPage(controller.currentIndex.value);
      }),
      bottomNavigationBar: Obx(() {
        print('BottomNav Obx rebuilding with index: ${controller.currentIndex.value}');
        return _buildBottomNavigation(controller);
      }),
    );
  }

  Widget _buildCurrentPage(int index) {
    print('_buildCurrentPage called with index: $index');
    switch (index) {
      case 0:
        print('Returning HomePage');
        return const HomePage();
      case 1:
        print('Returning SocialLinksPage');
        return const SocialLinksPage();
      case 2:
        print('Returning SharePage');
        return const SharePage();
      case 3:
        print('Returning ConnectedCardPage');
        return const ConnectedCardPage();
      case 4:
        print('Returning SettingsPage');
        return const SettingsPage();
      default:
        print('Returning default HomePage');
        return const HomePage();
    }
  }

  Widget _buildComingSoonPage(String pageName) {
    return Scaffold(
      backgroundColor: AppColors.zBgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 80,
                color: AppColors.zSecondaryBlackColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 20),
              Text(
                pageName,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.zBlackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Coming Soon',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.zSecondaryBlackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(HomeController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.zWhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.zBlackColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                controller: controller,
              ),
              _buildNavItem(
                index: 1,
                controller: controller,
              ),
              _buildNavItem(
                index: 2,
                controller: controller,
              ),
              _buildNavItem(
                index: 3,
                controller: controller,
              ),
              _buildNavItem(
                index: 4,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required HomeController controller,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print('Navigation item $index tapped');
            controller.changeTab(index);
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Obx(() => Image.asset(
                  controller.currentIndex.value == index 
                      ? _getFilledIcon(index)
                      : _getOutlineIcon(index),
                width: 24,
                height: 24,
                color: controller.currentIndex.value == index
                    ? AppColors.zPrimaryBtnColor
                    : AppColors.zSecondaryBlackColor,
                )),
              ],
              ),
          ),
        ),
      ),
    );
  }

  String _getFilledIcon(int index) {
    switch (index) {
      case 0: return AppIcons.homeFill;
      case 1: return AppIcons.linkFill;
      case 2: return AppIcons.uploadFill;
      case 3: return AppIcons.deviceFill;
      case 4: return AppIcons.settingFill;
      default: return AppIcons.homeFill;
    }
  }

  String _getOutlineIcon(int index) {
    switch (index) {
      case 0: return AppIcons.home;
      case 1: return AppIcons.link;
      case 2: return AppIcons.upload;
      case 3: return AppIcons.device;
      case 4: return AppIcons.setting;
      default: return AppIcons.home;
    }
  }
} 