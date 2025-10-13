# 🔐 Android Signing Setup Guide

This guide explains how to set up Android app signing for building release versions of SensorLab.

## 📋 Prerequisites

- Android Studio installed
- Flutter SDK configured
- Java Development Kit (JDK) installed

## 🔑 Generate Signing Key

### Step 1: Create a Keystore

```bash
# Navigate to android directory
cd android

# Generate a new keystore (replace values with your own)
keytool -genkey -v -keystore release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# You will be prompted for:
# - Keystore password (remember this!)
# - Key password (can be same as keystore password)
# - Your name and organization details
```

### Step 2: Create key.properties File

```bash
# Copy the example file
cp key.properties.example key.properties

# Edit key.properties with your actual values
```

Update `android/key.properties` with your information:

```properties
storePassword=YOUR_ACTUAL_STORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
keyAlias=upload
storeFile=../release-key.jks
ADMOB_APP_ID=ca-app-pub-3940256099942544~3347511713
```

### Step 3: Secure Your Keystore

```bash
# Move keystore to a secure location (recommended)
mv release-key.jks ~/.android/release-key.jks

# Update storeFile path in key.properties
# storeFile=/Users/yourusername/.android/release-key.jks
```

## 📱 AdMob Setup (Optional)

If you want to use AdMob ads:

1. Create an AdMob account at https://admob.google.com/
2. Create a new app in AdMob console
3. Get your App ID from AdMob console
4. Update `ADMOB_APP_ID` in `key.properties`

For development/testing, you can use Google's test App ID:

```
ADMOB_APP_ID=ca-app-pub-3940256099942544~3347511713
```

## 🏗️ Building Release APK

Once configured, you can build a release APK:

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Or build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

## ⚠️ Security Notes

- **NEVER** commit your `key.properties` file to version control
- **NEVER** share your keystore file publicly
- Keep backups of your keystore in a secure location
- If you lose your keystore, you cannot update your app on Play Store
- Use the same keystore for all versions of your app

## 🆘 Troubleshooting

### Build Fails with Signing Error

- Verify `key.properties` file exists and has correct values
- Check that keystore file path is correct
- Ensure passwords match your keystore

### AdMob Errors

- Verify AdMob App ID is correct
- For testing, use Google's test App ID
- Check that AdMob dependency is properly added

### Keystore Issues

- Ensure keystore was generated correctly
- Verify file permissions allow reading
- Check that alias name matches

## 📚 Additional Resources

- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [AdMob Integration](https://developers.google.com/admob/flutter/quick-start)
