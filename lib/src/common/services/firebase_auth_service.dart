import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import 'http_service.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? '568180813025-psr80mnaem5h9pt4hr4li4m0g93r4ha4.apps.googleusercontent.com'
        : null,
  );
  
  static const String _signinFirebaseEndpoint = '/users/signin_firebase';

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => currentUser != null;
  
  // Sign in with Firebase UID via backend API
  static Future<Map<String, dynamic>?> _signInWithFirebaseUid(String firebaseUid) async {
    try {
      print('🔐 Starting backend authentication with Firebase UID: $firebaseUid');
      
      final requestBody = {
        'firebase_uid': firebaseUid,
      };
      
      print('📤 Request Body: $requestBody');
      print('🌐 API Endpoint: $_signinFirebaseEndpoint');

      final response = await HttpService.post(_signinFirebaseEndpoint, requestBody);
      print('📥 API Response Status: ${response.statusCode}');
      print('📥 API Response Body: ${response.body}');
      
      final responseData = HttpService.handleResponse(response);
      print('✅ Parsed Response Data: $responseData');
      
      final token = responseData['token'];
      
      if (token != null) {
        print('🎟️ Backend token received: ${token.substring(0, 20)}...');
        // Store backend authentication token
        await StorageService.setToken(token);
        print('💾 Token stored successfully');
        return responseData;
      } else {
        print('❌ No token found in response');
        throw Exception('Backend token not found in response');
      }
    } catch (e) {
      print('💥 Error signing in with Firebase UID: $e');
      print('💥 Error type: ${e.runtimeType}');
      throw e;
    }
  }

  // Initialize Firebase Auth listener
  static void initAuthListener() {
    print('🎧 Initializing Firebase Auth listener...');
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        print('🔔 Auth state changed: User signed in - ${user.uid}');
        // User is signed in - Firebase UID will be stored by sign-in methods
        // The backend token is handled by the sign-in methods, not here
        await StorageService.setFirebaseUid(user.uid);
        print('💾 Firebase UID stored in local storage');
      } else {
        print('🔔 Auth state changed: User signed out');
        // User is signed out - only logout if user was previously logged in
        if (StorageService.isLogin) {
          print('🚪 Logging out user from local storage');
          await StorageService.logout();
        } else {
          print('👤 User was not logged in locally, no action needed');
        }
      }
    });
  }

  // Sign in with Google
  static Future<User?> signInWithGoogle() async {
    try {
      print('🚀 Starting Google Sign-In...');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ User canceled Google Sign-In');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('🔑 Google auth tokens obtained');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('🎫 Firebase credential created');

      // Sign in to Firebase with the Google user credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('🔥 Firebase authentication successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user: ${user.uid} (${user.email})');
        
        // Call backend API with Firebase UID to get backend token
        print('📞 Calling backend API...');
        await _signInWithFirebaseUid(user.uid);
        print('✅ Backend authentication completed');
        
        // Update storage
        await StorageService.setLogin(true);
        await StorageService.setFirebaseUid(user.uid);
        print('💾 Local storage updated');
      } else {
        print('❌ No Firebase user returned');
      }
      
      print('🎉 Google Sign-In process completed successfully');
      return user;
    } catch (e) {
      print('💥 Google Sign-In failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Sign in with Apple
  static Future<User?> signInWithApple() async {
    try {
      print('🍎 Starting Apple Sign-In...');
      
      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // Web authentication options are required for Android
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.tapyble.signin',
          redirectUri: Uri.parse('https://tapyble-app.firebaseapp.com/__/auth/handler'),
        ),
      );

      print('✅ Apple credential obtained');

      // Create an OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      print('🎫 Apple OAuth credential created');

      // Sign in to Firebase with the Apple user credential
      final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
      print('🔥 Firebase authentication successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user: ${user.uid} (${user.email})');
        
        // Call backend API with Firebase UID to get backend token
        print('📞 Calling backend API...');
        await _signInWithFirebaseUid(user.uid);
        print('✅ Backend authentication completed');
        
        // Update storage
        await StorageService.setLogin(true);
        await StorageService.setFirebaseUid(user.uid);
        print('💾 Local storage updated');
      } else {
        print('❌ No Firebase user returned');
      }
      
      print('🎉 Apple Sign-In process completed successfully');
      return user;
    } catch (e) {
      print('💥 Apple Sign-In failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      Get.snackbar(
        'Error',
        'Failed to sign in with Apple',
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Sign in with Email and Password
  static Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('📧 Starting Email/Password Sign-In...');
      print('📧 Email: $email');
      
      // Sign in to Firebase with email and password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('🔥 Firebase authentication successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user: ${user.uid} (${user.email})');
        
        // Call backend API with Firebase UID to get backend token
        print('📞 Calling backend API...');
        await _signInWithFirebaseUid(user.uid);
        print('✅ Backend authentication completed');
        
        // Update storage
        await StorageService.setLogin(true);
        await StorageService.setFirebaseUid(user.uid);
        print('💾 Local storage updated');
        
        print('🎉 Email/Password Sign-In process completed successfully');
        return user;
      } else {
        print('❌ No Firebase user returned');
        return null;
      }
    } catch (e) {
      print('💥 Email/Password Sign-In failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      String errorMessage = 'Failed to sign in';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email address';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many failed attempts. Try again later';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Check your connection';
            break;
          default:
            errorMessage = 'Authentication failed: ${e.message}';
        }
      }
      
      Get.snackbar(
        'Authentication Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Connect with Google (authentication only, no backend signin)
  static Future<User?> connectWithGoogle() async {
    try {
      print('🔗 Starting Google connection (auth only)...');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ User canceled Google Sign-In');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('🔑 Google auth tokens obtained');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('🎫 Firebase credential created');

      // Sign in to Firebase with the Google user credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('🔥 Firebase authentication successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user connected: ${user.uid} (${user.email})');
        print('🎉 Google connection (auth only) completed successfully');
        return user;
      } else {
        print('❌ No Firebase user returned');
        return null;
      }
    } catch (e) {
      print('💥 Google connection failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      throw e; // Rethrow to be handled by caller
    }
  }

  // Connect with Apple (authentication only, no backend signin)
  static Future<User?> connectWithApple() async {
    try {
      print('🔗 Starting Apple connection (auth only)...');
      
      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // Web authentication options are required for Android
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.tapyble.signin',
          redirectUri: Uri.parse('https://tapyble-app.firebaseapp.com/__/auth/handler'),
        ),
      );

      print('✅ Apple credential obtained');

      // Create an OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      print('🎫 Apple OAuth credential created');

      // Sign in to Firebase with the Apple user credential
      final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
      print('🔥 Firebase authentication successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user connected: ${user.uid} (${user.email})');
        print('🎉 Apple connection (auth only) completed successfully');
        return user;
      } else {
        print('❌ No Firebase user returned');
        return null;
      }
    } catch (e) {
      print('💥 Apple connection failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      throw e; // Rethrow to be handled by caller
    }
  }

  // Create account with Email and Password
  static Future<User?> createAccountWithEmailAndPassword(String email, String password) async {
    try {
      print('📧 Starting Email/Password Registration...');
      print('📧 Email: $email');
      
      // Create account in Firebase
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('🔥 Firebase account creation successful');
      
      final user = userCredential.user;
      if (user != null) {
        print('👤 Firebase user created: ${user.uid} (${user.email})');
        
        // Call backend API with Firebase UID to get backend token
        print('📞 Calling backend API...');
        await _signInWithFirebaseUid(user.uid);
        print('✅ Backend authentication completed');
        
        // Update storage
        await StorageService.setLogin(true);
        await StorageService.setFirebaseUid(user.uid);
        print('💾 Local storage updated');
        
        print('🎉 Email/Password Registration process completed successfully');
        return user;
      } else {
        print('❌ No Firebase user returned');
        return null;
      }
    } catch (e) {
      print('💥 Email/Password Registration failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      String errorMessage = 'Failed to create account';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'An account already exists with this email address';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak. Use at least 6 characters';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Check your connection';
            break;
          default:
            errorMessage = 'Account creation failed: ${e.message}';
        }
      }
      
      Get.snackbar(
        'Registration Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );
      return null;
    }
  }

  // Send password reset email
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      print('📧 Sending password reset email...');
      print('📧 Email: $email');
      print('📧 Firebase Auth instance: ${_auth.app.name}');
      
      // Debug: Check current Firebase user and project
      print('🔍 Debug Info:');
      print('   - Firebase Project: ${_auth.app.options.projectId}');
      print('   - Current User: ${_auth.currentUser?.email ?? 'No user signed in'}');
      print('   - Email to reset: $email');
      
      // Send password reset email (Firebase will silently handle non-existent emails for security)
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
        // Uncomment actionCodeSettings if you want custom email templates
        // actionCodeSettings: ActionCodeSettings(
        //   url: 'https://tapyble-app.firebaseapp.com/',
        //   handleCodeInApp: false,
        //   iOSBundleId: 'com.tapyble.app',
        //   androidPackageName: 'com.tapyble.app',
        // ),
      );
      
      print('✅ Password reset email process completed for: $email');
      print('📧 IMPORTANT: Firebase will only send email if:');
      print('   1. Account exists with this email');
      print('   2. Email/Password authentication is enabled in Firebase Console');
      print('   3. Email templates are configured in Firebase Console');
      print('📧 If no email arrives, check Firebase Console settings!');
      
      return true;
    } catch (e) {
      print('💥 Password reset email failed: $e');
      print('💥 Error type: ${e.runtimeType}');
      
      String errorMessage = 'Failed to send reset email';
      if (e is FirebaseAuthException) {
        print('💥 Firebase error code: ${e.code}');
        print('💥 Firebase error message: ${e.message}');
        
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email address format';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests. Please wait a few minutes before trying again';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Check your internet connection';
            break;
          case 'auth/user-disabled':
            errorMessage = 'This account has been disabled';
            break;
          default:
            errorMessage = 'Error: ${e.message ?? 'Unknown error occurred'}';
        }
      }
      
      Get.snackbar(
        'Reset Email Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Sign out from Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
      // Sign out from Firebase
      await _auth.signOut();
      
      // Clear storage
      await StorageService.logout();
      
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: const Color(0xFFFFFFFF),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Get user info
  static Map<String, dynamic>? getUserInfo() {
    final user = currentUser;
    if (user == null) return null;
    
    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'emailVerified': user.emailVerified,
    };
  }

  // Refresh user token
  static Future<String?> refreshToken() async {
    try {
      final user = currentUser;
      if (user == null) return null;
      
      final token = await user.getIdToken(true); // Force refresh
      await StorageService.setToken(token);
      return token;
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      return null;
    }
  }
} 