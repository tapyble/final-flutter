# 🔐 SHA-1 Fingerprint Setup for Google Sign-In

## **Problem**
Google Sign-In requires SHA-1 fingerprints to be added to Firebase project settings for Android apps.

---

## **Method 1: Using Android Studio (Recommended)**

### **Step 1: Open Project in Android Studio**
1. Open **Android Studio**
2. Open your project: `/Users/anan/Documents/myprojects/tapyble/tapyble`
3. Wait for Gradle sync to complete

### **Step 2: Generate SHA-1 Fingerprint**
1. In Android Studio, click **Gradle** tab (right side)
2. Navigate to: `tapyble` > `android` > `app` > `Tasks` > `android`
3. **Double-click** on `signingReport`
4. Check the **Run** tab at the bottom

### **Step 3: Copy SHA-1 Values**
You'll see output like:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX...
SHA1: A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0
SHA-256: ...
```

**Copy the SHA1 value** (the long string with colons)

---

## **Method 2: Using Terminal (if Java is installed)**

### **Install Java First:**
```bash
# Install Java using Homebrew
brew install openjdk@11
# Add to PATH
echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### **Generate SHA-1:**
```bash
# Debug keystore
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android

# Release keystore (if you have one)
keytool -list -v -keystore ~/path/to/your/release.keystore
```

---

## **Method 3: Using Flutter Command**

```bash
flutter build apk --debug
# Look for SHA-1 fingerprint information in the build output
```

---

## **Step 4: Add SHA-1 to Firebase Console**

### **4.1 Go to Firebase Console**
1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Select project: **tapyble-app**
3. Click **Project Settings** (gear icon)

### **4.2 Add SHA-1 Fingerprint**
1. Scroll to **Your apps** section
2. Find your **Android app** (`com.tapyble.tapyble`)
3. Click **Add fingerprint**
4. **Paste your SHA-1** fingerprint
5. Click **Save**

### **4.3 Download New google-services.json**
1. After adding SHA-1, click **Download google-services.json**
2. Replace the file in: `android/app/google-services.json`

---

## **Step 5: Update Firebase Configuration**

### **5.1 Regenerate Firebase Options**
```bash
flutterfire configure --project=tapyble-app --platforms=android,ios
```

### **5.2 Clean and Rebuild**
```bash
flutter clean
flutter pub get
flutter run
```

---

## **Step 6: Test Google Sign-In**

1. **Run the app** on Android device/emulator
2. **Click Google Sign-In** button
3. Should now work without crashes!

---

## **Common SHA-1 Fingerprints to Add**

Add **both** fingerprints to Firebase:

### **Debug Fingerprint (for development)**
- Used when running `flutter run` or `flutter build apk --debug`
- Default location: `~/.android/debug.keystore`

### **Release Fingerprint (for production)**
- Used when building release APK/AAB
- Your custom keystore or Google Play Console signing key

---

## **Troubleshooting**

### **Issue 1: "Java Runtime not found"**
- **Solution**: Install Java using Android Studio or Homebrew
- **Alternative**: Use Android Studio's Gradle panel

### **Issue 2: "debug.keystore not found"**
- **Solution**: Run `flutter run` once to generate debug keystore
- **Location**: `~/.android/debug.keystore`

### **Issue 3: Still getting authorization errors**
- **Solution**: Make sure SHA-1 is added to correct Firebase project
- **Verify**: Bundle ID matches in Firebase Console

---

## **Quick Checklist**
- [ ] SHA-1 fingerprint generated
- [ ] SHA-1 added to Firebase Console
- [ ] google-services.json updated and replaced  
- [ ] Firebase configuration regenerated
- [ ] App cleaned and rebuilt
- [ ] Google Sign-In tested on Android device

---

**Next**: After adding SHA-1 fingerprint, Google Sign-In should work perfectly on Android! 🎉 