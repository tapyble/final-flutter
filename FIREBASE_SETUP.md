# Firebase Setup Instructions for Tapyble

## ✅ **Setup Complete with FlutterFire CLI**

The Firebase configuration has been completed using FlutterFire CLI, which automatically generated the `firebase_options.dart` file and configured both Android and iOS platforms.

**Current Configuration:**
- **Project ID**: `tapyble-app`
- **Package/Bundle ID**: `com.tapyble.app`
- **Android App ID**: `1:568180813025:android:2bb36789a7e8ef9d97dba0`
- **iOS App ID**: `1:568180813025:ios:2e3c73995aa6496997dba0`

## Prerequisites Met
- ✅ Flutter project with package name: `com.tapyble.app`
- ✅ Firebase project created and configured
- ✅ Android and iOS apps added to Firebase
- ✅ Configuration files generated via FlutterFire CLI

## Step 1: Enable Authentication (Required)

**You still need to manually enable authentication providers in Firebase Console:**

1. Go to [Firebase Console](https://console.firebase.google.com/) → **tapyble-app** project
2. Navigate to **Authentication** → **Sign-in method**
3. **Enable Google Sign-In:**
   - Click on **Google**
   - Toggle **"Enable"**
   - Enter support email (your email)
   - Click **Save**
4. **Enable Apple Sign-In:**
   - Click on **Apple**
   - Toggle **"Enable"**
   - Click **Save**

## Step 2: Verify Google Sign-In Configuration

### ✅ **Already Configured by FlutterFire:**
- Android OAuth client automatically created
- iOS URL schemes already added to Info.plist

### For Production (Later):
- **Android**: Add SHA-1 fingerprint of release keystore to Firebase Console
- **iOS**: Verify bundle identifier matches in all configurations

## Step 3: Configure Apple Sign-In (For iOS Device Testing)

### ⚠️ **For Simulator Testing:**
Apple Sign-In works in iOS Simulator without additional setup.

### **For Physical Device Testing:**
1. **Apple Developer Account Required**
2. Go to [Apple Developer Portal](https://developer.apple.com/)
3. Navigate to **Certificates, Identifiers & Profiles** → **Identifiers**
4. Create/Configure App ID: `com.tapyble.app`
5. Enable **Sign In with Apple** capability
6. Update provisioning profiles

### **In Firebase Console:**
1. Go to **Authentication** → **Sign-in method** → **Apple**
2. After enabling, optionally add:
   - App ID: `com.tapyble.app`
   - Team ID (from Apple Developer account)

## Step 4: Test the App

**Everything is ready! Just enable authentication and test:**

```bash
# Clean and get dependencies (if needed)
flutter clean
flutter pub get

# Test on iOS Simulator (Apple Sign-In works without Apple Developer account)
flutter run -d ios

# Test on Android Emulator/Device (Google Sign-In works immediately)
flutter run -d android
```

## Current Status: ✅ Ready to Use

**What's Already Configured:**
- ✅ Firebase project: `tapyble-app`
- ✅ Android app: `google-services.json` in place
- ✅ iOS app: `GoogleService-Info.plist` in place
- ✅ Bundle/Package ID: `com.tapyble.app`
- ✅ Firebase options: `firebase_options.dart` generated
- ✅ URL schemes: Added to iOS Info.plist
- ✅ Build configuration: Google Services plugin added

**What You Need to Do:**
1. **Enable Google Sign-In** in Firebase Console (Step 1 above)
2. **Enable Apple Sign-In** in Firebase Console (Step 1 above)
3. **Test the app** - it should work immediately!

## Production Setup (Later)

### Android Release:
1. Generate release keystore
2. Add SHA-1 fingerprint to Firebase project
3. Update `android/app/build.gradle.kts` with signing config

### iOS Release:
1. Configure provisioning profiles
2. Update bundle identifier in Xcode
3. Test on physical device

## Troubleshooting

### Common Issues:

1. **Google Sign-In not working on Android:**
   - Check SHA-1 fingerprint in Firebase Console
   - Ensure `google-services.json` is in correct location
   - Verify package name matches exactly

2. **Apple Sign-In not working on iOS:**
   - Ensure App ID has Sign In with Apple enabled
   - Check URL schemes in Info.plist
   - Verify bundle identifier matches

3. **Firebase not initializing:**
   - Check configuration files are properly added
   - Verify Firebase project settings
   - Check console for initialization errors

### Debug Commands:
```bash
# Check Firebase configuration
flutter run --verbose

# Clear Flutter cache
flutter clean
flutter pub get

# Check iOS configuration
cd ios && pod install && cd ..
```

## Security Notes

1. **Never commit configuration files to public repositories**
2. **Use different Firebase projects for development and production**
3. **Regularly rotate API keys and certificates**
4. **Enable App Check for production apps**

## Support

For issues:
1. Check [Firebase Documentation](https://firebase.google.com/docs)
2. Review [FlutterFire Documentation](https://firebase.flutter.dev/)
 