# Tapyble Utilities

This folder contains global utilities that can be used throughout the Tapyble application.

## Structure

```
lib/src/utils/
├── index.dart           # Export all utilities (import this for easy access)
├── assets.dart          # Asset paths for images and icons
├── colors.dart          # App color constants
├── constants.dart       # App constants (strings, numbers, etc.)
├── fonts.dart           # Font configuration using Google Fonts
├── example_usage.dart   # Usage examples (delete after understanding)
├── assets_example.dart  # Asset usage examples (delete after understanding)
└── README.md           # This documentation
```

## Usage

### Import all utilities at once:
```dart
import 'package:tapyble/src/utils/index.dart';
```

### Or import individual files:
```dart
import 'package:tapyble/src/utils/colors.dart';
import 'package:tapyble/src/utils/constants.dart';
import 'package:tapyble/src/utils/fonts.dart';
```

## Available Classes

### AppAssets, AppLogos, AppIcons, AppSocialIcons
**Asset Management Classes:**
- `AppLogos` - App logos and branding assets
  - `icon`, `logo`, `logo1024`, `cardDesign`
- `AppIcons` - UI icons for navigation, actions, etc.
  - `google`, `apple`, `home`, `download`, `upload`, `share`, `setting`, etc.
- `AppSocialIcons` - Social media platform icons
  - `facebook`, `instagram`, `twitter`, `linkedin`, `youtube`, etc.
- `AppAssets` - Helper methods for asset management
  - `getAllLogos()`, `getAllIcons()`, `getAllSocialIcons()`
  - `getSocialIconByName(String name)` - Dynamic icon lookup

### AppColors
- `zBgColor` - Background color (#FDFBEE)
- `zPrimaryBtnColor` - Primary button color (#FAD02C)
- `zSecondaryBtnColor` - Secondary button color (#1A1A1A)
- `zBlackColor` - Primary black color (#1A1A1A)
- `zSecondaryBlackColor` - Secondary black with transparency
- `zWhiteColor` - White color (#FFFFFF)
- `zInputFieldBgColor` - Input field background color

### AppConstants
- `zAppName` - Application name ("tapyble")
- `zApiBaseURL` - API base URL
- `zDefaultPadding` - Default padding (10px)
- `zDefaultMargin` - Default margin (10px)

### AppFonts
- `zAppFontFamily` - Font family name ("Rubik")
- `rubik()` - Method to get Rubik font with custom properties
- `getThemeData()` - Complete theme data with Rubik font

### AppTextStyles
- Heading styles: `heading1`, `heading2`, `heading3`, `heading4`
- Body styles: `bodyLarge`, `bodyMedium`, `bodySmall`
- Button styles: `buttonLarge`, `buttonMedium`, `buttonSmall`
- Misc styles: `caption`, `label`

## Examples

### Asset Usage Examples:
```dart
// Using logos
Image.asset(AppLogos.logo)
Image.asset(AppLogos.icon)

// Using UI icons
Image.asset(AppIcons.home)
Image.asset(AppIcons.setting)

// Using social media icons
Image.asset(AppSocialIcons.facebook)
Image.asset(AppSocialIcons.instagram)

// Dynamic social icon lookup
String? iconPath = AppAssets.getSocialIconByName('twitter');
if (iconPath != null) {
  Image.asset(iconPath)
}

// Get all assets of a type
List<String> allLogos = AppAssets.getAllLogos();
List<String> allSocialIcons = AppAssets.getAllSocialIcons();
```

See `example_usage.dart` and `assets_example.dart` for comprehensive usage examples. 