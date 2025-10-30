// Base asset path
const String _basePath = 'assets';

/// App Logos and Branding
class AppLogos {
  // Private constructor to prevent instantiation
  AppLogos._();

  static const String icon = '$_basePath/icon.png';
  static const String logo = '$_basePath/logo.png';
  static const String logo1024 = '$_basePath/1024.png';
  static const String cardDesign = '$_basePath/card-design.png';
  static const String demoQR = '$_basePath/demoQR.png';
  
  // Card images
  static const String yellowCard = '$_basePath/yellowcard.png';
  static const String tealCard = '$_basePath/tealcard.png';
  static const String pinkCard = '$_basePath/pinkcard.png';
  static const String blackCard = '$_basePath/blackcard.png';
}

/// UI Icons
class AppIcons {
  // Private constructor to prevent instantiation
  AppIcons._();

  static const String _iconsPath = '$_basePath/icons';
  
  // Authentication icons
  static const String google = '$_iconsPath/google.png';
  static const String apple = '$_iconsPath/apple.png';
  
  // Navigation icons
  static const String home = '$_iconsPath/home.png';
  static const String homeFill = '$_iconsPath/home_fill.png';
  static const String back = '$_iconsPath/back.png';
  
  // Action icons
  static const String download = '$_iconsPath/download.png';
  static const String upload = '$_iconsPath/upload.png';
  static const String uploadFill = '$_iconsPath/upload_fill.png';
  static const String share = '$_iconsPath/share.png';
  static const String edit = '$_iconsPath/edit.png';
  
  // Link icons
  static const String link = '$_iconsPath/edit.png';
  static const String linkFill = '$_iconsPath/edit_fill.png';
  
  // Settings and system icons
  static const String setting = '$_iconsPath/setting.png';
  static const String settingFill = '$_iconsPath/setting_fill.png';
  static const String devices = '$_iconsPath/devices.png';
  static const String device = '$_iconsPath/device.png';
  static const String deviceFill = '$_iconsPath/device_fill.png';
  
  // NFC and QR icons
  static const String nfc = '$_iconsPath/nfc.png';
  static const String qr = '$_iconsPath/qr.png';
}

/// Social Media Icons
class AppSocialIcons {
  // Private constructor to prevent instantiation
  AppSocialIcons._();

  static const String _socialPath = '$_basePath/social-icons';
  
  // Popular social media
  static const String facebook = '$_socialPath/facebook.png';
  static const String instagram = '$_socialPath/instagram.png';
  static const String twitter = '$_socialPath/twitter.png';
  static const String linkedin = '$_socialPath/linkedin.png';
  static const String youtube = '$_socialPath/youtube.png';
  static const String tiktok = '$_socialPath/tiktok.png';
  static const String snapchat = '$_socialPath/snapchat.png';
  static const String pinterest = '$_socialPath/pinterest.png';
  static const String reddit = '$_socialPath/reddit.png';
  
  // Messaging apps
  static const String whatsapp = '$_socialPath/whatsapp.png';
  static const String telegram = '$_socialPath/telegram.png';
  static const String discord = '$_socialPath/discord.png';
  static const String wechat = '$_socialPath/wechat.png';
  static const String line = '$_socialPath/line.png';
  static const String kakao = '$_socialPath/kakao.png';
  static const String kik = '$_socialPath/kik.png';
  
  // Professional and creative
  static const String github = '$_socialPath/github.png';
  static const String dribbble = '$_socialPath/dribbble.png';
  static const String behance = '$_socialPath/behance.png';
  static const String medium = '$_socialPath/medium.png';
  static const String twitch = '$_socialPath/twitch.png';
  
  // Communication
  static const String email = '$_socialPath/email.png';
  static const String gmail = '$_socialPath/gmail.png';
  static const String outlook = '$_socialPath/outlook.png';
  static const String yahoo = '$_socialPath/yahoo.png';
  static const String phone = '$_socialPath/phone.png';
  static const String website = '$_socialPath/website.png';
}

/// Helper class for asset management
class AppAssets {
  // Private constructor to prevent instantiation
  AppAssets._();

  /// Get all logo assets as a list
  static List<String> getAllLogos() {
    return [
      AppLogos.icon,
      AppLogos.logo,
      AppLogos.logo1024,
      AppLogos.cardDesign,
      AppLogos.yellowCard,
      AppLogos.tealCard,
      AppLogos.pinkCard,
      AppLogos.blackCard,
    ];
  }

  /// Get all UI icons as a list
  static List<String> getAllIcons() {
    return [
      AppIcons.google,
      AppIcons.apple,
      AppIcons.home,
      AppIcons.homeFill,
      AppIcons.back,
      AppIcons.download,
      AppIcons.upload,
      AppIcons.uploadFill,
      AppIcons.share,
      AppIcons.edit,
      AppIcons.link,
      AppIcons.linkFill,
      AppIcons.setting,
      AppIcons.settingFill,
      AppIcons.devices,
      AppIcons.device,
      AppIcons.deviceFill,
      AppIcons.nfc,
      AppIcons.qr,
    ];
  }

  /// Get all social media icons as a list
  static List<String> getAllSocialIcons() {
    return [
      AppSocialIcons.facebook,
      AppSocialIcons.instagram,
      AppSocialIcons.twitter,
      AppSocialIcons.linkedin,
      AppSocialIcons.youtube,
      AppSocialIcons.tiktok,
      AppSocialIcons.snapchat,
      AppSocialIcons.pinterest,
      AppSocialIcons.reddit,
      AppSocialIcons.whatsapp,
      AppSocialIcons.telegram,
      AppSocialIcons.discord,
      AppSocialIcons.wechat,
      AppSocialIcons.line,
      AppSocialIcons.kakao,
      AppSocialIcons.kik,
      AppSocialIcons.github,
      AppSocialIcons.dribbble,
      AppSocialIcons.behance,
      AppSocialIcons.medium,
      AppSocialIcons.twitch,
      AppSocialIcons.email,
      AppSocialIcons.gmail,
      AppSocialIcons.outlook,
      AppSocialIcons.yahoo,
      AppSocialIcons.phone,
      AppSocialIcons.website,
    ];
  }

  /// Get social media icon by name (case-insensitive)
  static String? getSocialIconByName(String name) {
    final lowerName = name.toLowerCase();
    switch (lowerName) {
      case 'facebook':
        return AppSocialIcons.facebook;
      case 'instagram':
        return AppSocialIcons.instagram;
      case 'twitter':
        return AppSocialIcons.twitter;
      case 'linkedin':
        return AppSocialIcons.linkedin;
      case 'youtube':
        return AppSocialIcons.youtube;
      case 'tiktok':
        return AppSocialIcons.tiktok;
      case 'snapchat':
        return AppSocialIcons.snapchat;
      case 'pinterest':
        return AppSocialIcons.pinterest;
      case 'reddit':
        return AppSocialIcons.reddit;
      case 'whatsapp':
        return AppSocialIcons.whatsapp;
      case 'telegram':
        return AppSocialIcons.telegram;
      case 'discord':
        return AppSocialIcons.discord;
      case 'wechat':
        return AppSocialIcons.wechat;
      case 'line':
        return AppSocialIcons.line;
      case 'kakao':
        return AppSocialIcons.kakao;
      case 'kik':
        return AppSocialIcons.kik;
      case 'github':
        return AppSocialIcons.github;
      case 'dribbble':
        return AppSocialIcons.dribbble;
      case 'behance':
        return AppSocialIcons.behance;
      case 'medium':
        return AppSocialIcons.medium;
      case 'twitch':
        return AppSocialIcons.twitch;
      case 'email':
        return AppSocialIcons.email;
      case 'gmail':
        return AppSocialIcons.gmail;
      case 'outlook':
        return AppSocialIcons.outlook;
      case 'yahoo':
        return AppSocialIcons.yahoo;
      case 'phone':
        return AppSocialIcons.phone;
      case 'website':
        return AppSocialIcons.website;
      default:
        return null;
    }
  }
} 