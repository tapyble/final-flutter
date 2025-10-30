import 'package:get/get.dart';
import 'storage_service.dart';
import 'http_service.dart';

class SocialLinksService {
  // API endpoints
  static const String _addLinksEndpoint = '/users/add_links';
  static const String _updateLinksEndpoint = '/users/update_links';
  static const String _showLinksEndpoint = '/users/show_links';
  static const String _removeLinksEndpoint = '/users/remove_links';

  // Social platforms data with instructions
  static const Map<String, Map<String, String>> PLATFORMS = {
    'behance': {'name': 'Behance', 'icon': 'behance.png', 'instructions': 'Go to your Behance profile\nCopy the profile URL from browser'},
    'discord': {'name': 'Discord', 'icon': 'discord.png', 'instructions': 'Open Discord → User Settings → Copy User ID\nOr share your Discord server invite link'},
    'dribbble': {'name': 'Dribbble', 'icon': 'dribbble.png', 'instructions': 'Go to your Dribbble profile\nCopy the profile URL from browser'},
    'email': {'name': 'Email', 'icon': 'email.png', 'instructions': 'Enter your email address\nPeople can contact you directly'},
    'facebook': {'name': 'Facebook', 'icon': 'facebook.png', 'instructions': 'Go to your Facebook profile\nCopy the profile URL from browser'},
    'github': {'name': 'GitHub', 'icon': 'github.png', 'instructions': 'Go to your GitHub profile\nCopy the profile URL from browser'},
    'gmail': {'name': 'Gmail', 'icon': 'gmail.png', 'instructions': 'Enter your Gmail address\nPeople can email you directly'},
    'instagram': {'name': 'Instagram', 'icon': 'instagram.png', 'instructions': 'Go to your Instagram profile\nCopy the profile URL or enter @username'},
    'kakao': {'name': 'KakaoTalk', 'icon': 'kakao.png', 'instructions': 'Open KakaoTalk → More → QR Code\nShare your KakaoTalk ID or profile link'},
    'kik': {'name': 'Kik', 'icon': 'kik.png', 'instructions': 'Open Kik → Settings → Your Kik Code\nShare your Kik username'},
    'line': {'name': 'LINE', 'icon': 'line.png', 'instructions': 'Open LINE → Home → QR Code\nShare your LINE ID or add friend link'},
    'linkedin': {'name': 'LinkedIn', 'icon': 'linkedin.png', 'instructions': 'Go to your LinkedIn profile\nCopy the profile URL from browser'},
    'medium': {'name': 'Medium', 'icon': 'medium.png', 'instructions': 'Go to your Medium profile\nCopy the profile URL from browser'},
    'outlook': {'name': 'Outlook', 'icon': 'outlook.png', 'instructions': 'Enter your Outlook email address\nPeople can email you directly'},
    'phone': {'name': 'Phone', 'icon': 'phone.png', 'instructions': 'Enter your phone number\nInclude country code (e.g., +1234567890)'},
    'pinterest': {'name': 'Pinterest', 'icon': 'pinterest.png', 'instructions': 'Go to your Pinterest profile\nCopy the profile URL from browser'},
    'reddit': {'name': 'Reddit', 'icon': 'reddit.png', 'instructions': 'Go to your Reddit profile\nCopy the profile URL or enter u/username'},
    'snapchat': {'name': 'Snapchat', 'icon': 'snapchat.png', 'instructions': 'Open Snapchat → Profile → Share\nCopy your Snapchat profile link'},
    'telegram': {'name': 'Telegram', 'icon': 'telegram.png', 'instructions': 'Open Telegram → Settings → Username\nShare your @username or t.me link'},
    'tiktok': {'name': 'TikTok', 'icon': 'tiktok.png', 'instructions': 'Go to your TikTok profile\nCopy the profile URL or enter @username'},
    'twitch': {'name': 'Twitch', 'icon': 'twitch.png', 'instructions': 'Go to your Twitch channel\nCopy the channel URL from browser'},
    'twitter': {'name': 'Twitter (X)', 'icon': 'twitter.png', 'instructions': 'Go to your Twitter/X profile\nCopy the profile URL or enter @username'},
    'website': {'name': 'Website', 'icon': 'website.png', 'instructions': 'Enter your website URL\nMake sure it starts with https://'},
    'wechat': {'name': 'WeChat', 'icon': 'wechat.png', 'instructions': 'Open WeChat → Me → QR Code\nShare your WeChat ID or QR code link'},
    'whatsapp': {'name': 'WhatsApp', 'icon': 'whatsapp.png', 'instructions': 'Enter your WhatsApp phone number\nInclude country code (e.g., +1234567890)'},
    'yahoo': {'name': 'Yahoo', 'icon': 'yahoo.png', 'instructions': 'Enter your Yahoo email address\nPeople can email you directly'},
    'youtube': {'name': 'YouTube', 'icon': 'youtube.png', 'instructions': 'Go to your YouTube channel\nCopy the channel URL from browser'},
    'cashapp': {'name': 'Cash App', 'icon': 'cashapp.png', 'instructions': 'Open Cash App and view your \$Cashtag\nCopy the link https://cash.app/\$cashtag'},
    'venmo': {'name': 'Venmo', 'icon': 'venmo.png', 'instructions': 'Open Venmo → Me tab\nCopy your profile link https://venmo.com/username'},
    'paypal': {'name': 'PayPal', 'icon': 'paypal.png', 'instructions': 'Open PayPal and create a PayPal.Me link\nCopy the link https://paypal.me/username'},
    'custom_link': {'name': 'CUSTOM', 'icon': 'tapyblelink.png', 'instructions': 'Enter any custom link or text\nThis will be displayed as-is'},
  };

  // Get all platforms
  static Map<String, Map<String, String>> get platforms => PLATFORMS;

  // Get platform name by key
  static String getPlatformName(String platformKey) {
    return PLATFORMS[platformKey]?['name'] ?? platformKey;
  }

  // Get platform icon by key
  static String getPlatformIcon(String platformKey) {
    return PLATFORMS[platformKey]?['icon'] ?? 'website.png';
  }

  // Get platform instructions
  static String getPlatformInstructions(String platform) {
    return PLATFORMS[platform]?['instructions'] ?? 'Enter your link or username for this platform';
  }

  // Get platform hint (single-line)
  static String getPlatformHint(String platform) {
    switch (platform.toLowerCase()) {
      case 'phone':
        return '+1234567890'; // Will be converted to tel:+ prefix silently
      case 'whatsapp':
        return '+1234567890';
      case 'email':
      case 'gmail':
      case 'outlook':
      case 'yahoo':
        return 'example@domain.com';
      case 'instagram':
        return 'https://instagram.com/username';
      case 'twitter':
        return 'https://twitter.com/username';
      case 'tiktok':
        return 'https://www.tiktok.com/@username';
      case 'reddit':
        return 'https://reddit.com/u/username';
      case 'linkedin':
        return 'https://linkedin.com/in/username';
      case 'github':
        return 'https://github.com/username';
      case 'youtube':
        return 'https://youtube.com/channel/CHANNEL_ID';
      case 'cashapp':
        return 'https://cash.app/\$cashtag';
      case 'venmo':
        return 'https://venmo.com/username';
      case 'paypal':
        return 'https://paypal.me/username';
      case 'behance':
        return 'https://www.behance.net/username';
      case 'discord':
        return 'https://discord.gg/invite-code';
      case 'dribbble':
        return 'https://dribbble.com/username';
      case 'facebook':
        return 'https://facebook.com/username';
      case 'kakao':
        return 'https://open.kakao.com/o/handle';
      case 'kik':
        return 'https://kik.me/username';
      case 'line':
        return 'https://line.me/ti/p/ID';
      case 'medium':
        return 'https://medium.com/@username';
      case 'pinterest':
        return 'https://pinterest.com/username';
      case 'snapchat':
        return 'https://www.snapchat.com/add/username';
      case 'telegram':
        return 'https://t.me/username';
      case 'twitch':
        return 'https://twitch.tv/username';
      case 'website':
        return 'https://example.com';
      case 'wechat':
        return 'WeChatID';
      case 'custom_link':
        return 'https://your-link.com';
      default:
        return 'https://example.com/username';
    }
  }

  // Get platform label for input field
  static String getPlatformLabel(String platform) {
    switch (platform.toLowerCase()) {
      case 'phone':
        return 'Phone Number';
      case 'whatsapp':
        return 'WhatsApp Number';
      case 'email':
      case 'gmail':
      case 'outlook':
      case 'yahoo':
        return 'Email Address';
      case 'cashapp':
        return 'CashTag ink';
      case 'venmo':
        return 'Link';
      case 'paypal':
        return 'Link';
      default:
        return 'Link';
    }
  }

  // Format data with appropriate prefix
  static String formatPlatformData(String platform, String data) {
    final trimmedData = data.trim();
    
    switch (platform.toLowerCase()) {
      case 'phone':
        // Add tel: prefix for phone numbers
        if (!trimmedData.startsWith('tel:')) {
          return 'tel:$trimmedData';
        }
        return trimmedData;
        
      case 'whatsapp':
        // Add https://wa.me/ prefix for WhatsApp
        if (!trimmedData.startsWith('https://wa.me/')) {
          // Remove any existing prefixes and clean the number
          String cleanNumber = trimmedData
              .replaceAll('https://wa.me/', '')
              .replaceAll('https://', '')
              .replaceAll('wa.me/', '')
              .replaceAll('+', '')
              .replaceAll(' ', '')
              .replaceAll('-', '')
              .replaceAll('(', '')
              .replaceAll(')', '');
          return 'https://wa.me/$cleanNumber';
        }
        return trimmedData;
        
      case 'email':
      case 'gmail':
      case 'outlook':
      case 'yahoo':
        // Add mailto: prefix for email addresses
        if (!trimmedData.startsWith('mailto:')) {
          return 'mailto:$trimmedData';
        }
        return trimmedData;
        
      default:
        return trimmedData;
    }
  }

  // Get display data (remove prefixes for display)
  static String getDisplayData(String platform, String data) {
    switch (platform.toLowerCase()) {
      case 'phone':
        return data.replaceFirst('tel:', '');
        
      case 'whatsapp':
        return data.replaceFirst('https://wa.me/', '+');
        
      case 'email':
      case 'gmail':
      case 'outlook':
      case 'yahoo':
        return data.replaceFirst('mailto:', '');
        
      default:
        return data;
    }
  }

  // Add a new social link
  static Future<Map<String, dynamic>?> addLink({
    required String platform,
    required String data,
    required String mode,
  }) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await HttpService.post(_addLinksEndpoint, {
        'token': token,
        'platform': platform,
        'mode': mode,
        'data': data,
      });

      final responseData = HttpService.handleResponse(response);
      HttpService.showSuccess('Link Added', 'Social link added successfully');
      
      return responseData;
    } catch (e) {
      HttpService.showError('Add Link Failed', e.toString());
      return null;
    }
  }

  // Update an existing social link
  static Future<Map<String, dynamic>?> updateLink({
    required String linkId,
    required String data,
    required String mode,
  }) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await HttpService.post(_updateLinksEndpoint, {
        'token': token,
        'linkId': linkId,
        'mode': mode,
        'data': data,
      });

      final responseData = HttpService.handleResponse(response);
      HttpService.showSuccess('Link Updated', 'Social link updated successfully');
      
      return responseData;
    } catch (e) {
      HttpService.showError('Update Link Failed', e.toString());
      return null;
    }
  }

  // Get all social links
  static Future<List<Map<String, dynamic>>?> getLinks() async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await HttpService.post(_showLinksEndpoint, {
        'token': token,
      });

      final responseData = HttpService.handleResponse(response);
      final links = responseData['links'] as List?;
      
      if (links != null) {
        return links.map((link) => Map<String, dynamic>.from(link)).toList();
      }
      
      return [];
    } catch (e) {
      HttpService.showError('Get Links Failed', e.toString());
      return null;
    }
  }

  // Remove a social link
  static Future<bool> removeLink(String linkId) async {
    try {
      final token = StorageService.token;
      if (token == null) {
        throw Exception('No authentication token available');
      }

      final response = await HttpService.post(_removeLinksEndpoint, {
        'token': token,
        'linkId': linkId,
      });

      HttpService.handleResponse(response);
      HttpService.showSuccess('Link Removed', 'Social link removed successfully');
      
      return true;
    } catch (e) {
      HttpService.showError('Remove Link Failed', e.toString());
      return false;
    }
  }

  // Get links by mode
  static Future<List<Map<String, dynamic>>> getLinksByMode(String mode) async {
    final allLinks = await getLinks();
    if (allLinks == null) return [];
    
    return allLinks.where((link) => link['mode'] == mode).toList();
  }

  // Check if platform is already added
  static Future<bool> isPlatformAdded(String platform, String mode) async {
    final links = await getLinksByMode(mode);
    return links.any((link) => link['platform'] == platform);
  }

  // Get link by platform and mode
  static Future<Map<String, dynamic>?> getLinkByPlatform(String platform, String mode) async {
    final links = await getLinksByMode(mode);
    try {
      return links.firstWhere((link) => link['platform'] == platform);
    } catch (e) {
      return null;
    }
  }
} 