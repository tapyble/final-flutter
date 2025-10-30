import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _isLoginKey = 'isLogin';
  static const String _tokenKey = 'token';
  static const String _firebaseUidKey = 'firebase_uid';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Login status
  static bool get isLogin => _prefs?.getBool(_isLoginKey) ?? false;
  
  static Future<bool> setLogin(bool value) async {
    print("💾 setLogin: ${value.toString()}");
    final result = await _prefs?.setBool(_isLoginKey, value) ?? false;
    print("💾 setLogin result: $result");
    print("💾 Current login status: ${isLogin}");
    return result;
  }

  // Token
  static String? get token => _prefs?.getString(_tokenKey);
  
  static Future<bool> setToken(String? token) async {
    print("💾 setToken: ${token != null ? '${token.substring(0, 20)}...' : 'null'}");
    bool result;
    if (token == null) {
      result = await _prefs?.remove(_tokenKey) ?? false;
    } else {
      result = await _prefs?.setString(_tokenKey, token) ?? false;
    }
    print("💾 setToken result: $result");
    print("💾 Current token exists: ${StorageService.token != null}");
    return result;
  }

  // Firebase UID
  static String? get firebaseUid => _prefs?.getString(_firebaseUidKey);
  
  static Future<bool> setFirebaseUid(String? uid) async {
    if (uid == null) {
      return await _prefs?.remove(_firebaseUidKey) ?? false;
    }
    return await _prefs?.setString(_firebaseUidKey, uid) ?? false;
  }

  // Clear all data (logout)
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }

  // Check if user is properly logged in with all required data
  static bool get isProperlyLoggedIn => isLogin && token != null;
  
  // Logout (clear login status, token, and firebase uid)
  static Future<void> logout() async {
    await setLogin(false);
    await setToken(null);
    await setFirebaseUid(null);
  }
} 