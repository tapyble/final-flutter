// Modern Assets Example with contemporary design
// Delete this file after understanding the usage patterns

import 'package:flutter/material.dart';
import 'package:tapyble/src/utils/index.dart';

class AssetsExamplePage extends StatefulWidget {
  const AssetsExamplePage({super.key});

  @override
  State<AssetsExamplePage> createState() => _AssetsExamplePageState();
}

class _AssetsExamplePageState extends State<AssetsExamplePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.zBgColor,
              AppColors.zBgColor.withOpacity(0.8),
              AppColors.zPrimaryBtnColor.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildModernAppBar(),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildHeroSection(),
                        const SizedBox(height: 32),
                        _buildModernSection(
                          'Brand Assets',
                          Icons.palette_outlined,
                          _buildLogosGrid(),
                        ),
                        const SizedBox(height: 32),
                        _buildModernSection(
                          'Interface Icons',
                          Icons.widgets_outlined,
                          _buildIconsGrid(),
                        ),
                        const SizedBox(height: 32),
                        _buildModernSection(
                          'Social Platforms',
                          Icons.share_outlined,
                          _buildSocialGrid(),
                        ),
                        const SizedBox(height: 32),
                        _buildStatsCard(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.zBlackColor.withOpacity(0.9),
              AppColors.zBlackColor.withOpacity(0.7),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: FlexibleSpaceBar(
          title: Text(
            'Asset Gallery',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.zWhiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ));
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.zPrimaryBtnColor.withOpacity(0.1),
            AppColors.zPrimaryBtnColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.zPrimaryBtnColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.zPrimaryBtnColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 40,
              color: AppColors.zBlackColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Modern Asset Management',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.zBlackColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Beautifully organized assets for your ${AppConstants.zAppName} application',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.zSecondaryBlackColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.zPrimaryBtnColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.zBlackColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.zBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        content,
      ],
    );
  }

  Widget _buildLogosGrid() {
    final logos = [
      {'name': 'App Icon', 'path': AppLogos.icon},
      {'name': 'Brand Logo', 'path': AppLogos.logo},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: logos.length,
      itemBuilder: (context, index) {
        return _buildModernAssetCard(
          logos[index]['name']!,
          logos[index]['path']!,
          index,
        );
      },
    );
  }

  Widget _buildIconsGrid() {
    final icons = [
      {'name': 'Google', 'path': AppIcons.google},
      {'name': 'Apple', 'path': AppIcons.apple},
      {'name': 'Home', 'path': AppIcons.home},
      {'name': 'Settings', 'path': AppIcons.setting},
      {'name': 'Download', 'path': AppIcons.download},
      {'name': 'Upload', 'path': AppIcons.upload},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return _buildModernAssetCard(
          icons[index]['name']!,
          icons[index]['path']!,
          index,
        );
      },
    );
  }

  Widget _buildSocialGrid() {
    final socialIcons = [
      {'name': 'Instagram', 'path': AppSocialIcons.instagram},
      {'name': 'Facebook', 'path': AppSocialIcons.facebook},
      {'name': 'Twitter', 'path': AppSocialIcons.twitter},
      {'name': 'LinkedIn', 'path': AppSocialIcons.linkedin},
      {'name': 'YouTube', 'path': AppSocialIcons.youtube},
      {'name': 'GitHub', 'path': AppSocialIcons.github},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: socialIcons.length,
      itemBuilder: (context, index) {
        return _buildModernAssetCard(
          socialIcons[index]['name']!,
          socialIcons[index]['path']!,
          index,
        );
      },
    );
  }

  Widget _buildModernAssetCard(String name, String assetPath, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () => _showAssetDialog(name, assetPath),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.zWhiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.zBlackColor.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.zPrimaryBtnColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.zPrimaryBtnColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                                 children: [
                   Expanded(
                     child: Container(
                       padding: const EdgeInsets.all(16),
                       child: Image.asset(
                         assetPath,
                         fit: BoxFit.contain,
                         errorBuilder: (context, error, stackTrace) {
                           return Container(
                             decoration: BoxDecoration(
                               color: AppColors.zInputFieldBgColor,
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Icon(
                               Icons.error_outline,
                               size: 24,
                               color: AppColors.zSecondaryBlackColor,
                             ),
                           );
                         },
                       ),
                     ),
                   ),
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                     decoration: BoxDecoration(
                       color: AppColors.zPrimaryBtnColor.withOpacity(0.05),
                       borderRadius: const BorderRadius.only(
                         bottomLeft: Radius.circular(20),
                         bottomRight: Radius.circular(20),
                       ),
                     ),
                     child: Text(
                       name,
                       style: AppTextStyles.caption.copyWith(
                         color: AppColors.zBlackColor,
                         fontWeight: FontWeight.w600,
                         fontSize: 11,
                       ),
                       textAlign: TextAlign.center,
                       maxLines: 2,
                       overflow: TextOverflow.ellipsis,
                     ),
                   ),
                 ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.zBlackColor,
            AppColors.zBlackColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.zBlackColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Asset Statistics',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.zWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Logos',
                AppAssets.getAllLogos().length.toString(),
                Icons.image_outlined,
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.zWhiteColor.withOpacity(0.2),
              ),
              _buildStatItem(
                'UI Icons',
                AppAssets.getAllIcons().length.toString(),
                Icons.widgets_outlined,
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.zWhiteColor.withOpacity(0.2),
              ),
              _buildStatItem(
                'Social',
                AppAssets.getAllSocialIcons().length.toString(),
                Icons.share_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.zPrimaryBtnColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.zPrimaryBtnColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.zWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.zWhiteColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildModernFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.zPrimaryBtnColor,
            AppColors.zPrimaryBtnColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.zPrimaryBtnColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showDynamicLookupDemo(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.auto_awesome,
          color: AppColors.zBlackColor,
          size: 28,
        ),
      ),
    );
  }

  void _showAssetDialog(String name, String assetPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.zWhiteColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.zBlackColor.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.zInputFieldBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.zBlackColor,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assetPath,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.zSecondaryBlackColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zPrimaryBtnColor,
                  foregroundColor: AppColors.zBlackColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: AppTextStyles.buttonMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDynamicLookupDemo() {
    // List of social platforms to demonstrate dynamic lookup
    final platforms = ['instagram', 'facebook', 'twitter', 'linkedin', 'github', 'youtube'];
    final randomPlatform = platforms[(DateTime.now().millisecondsSinceEpoch) % platforms.length];
    
    // Use the dynamic lookup method
    final iconPath = AppAssets.getSocialIconByName(randomPlatform);
    
    if (iconPath != null) {
      _showAssetDialog(
        'Dynamic Lookup: ${randomPlatform.toUpperCase()}',
        iconPath,
      );
    } else {
      // Show error dialog if lookup fails
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.zWhiteColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.zBlackColor.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.zInputFieldBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.search_off,
                    size: 40,
                    color: AppColors.zSecondaryBlackColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dynamic Lookup Failed',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.zBlackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Could not find icon for: $randomPlatform',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.zSecondaryBlackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zSecondaryBtnColor,
                    foregroundColor: AppColors.zWhiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
} 