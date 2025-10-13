# 🔐 AdMob Security Configuration Guide

This guide explains how to securely manage AdMob App IDs and Ad Unit IDs for open source projects.

## ⚠️ Security Warning

**NEVER** commit your actual production AdMob IDs to version control in an open source project. This can lead to:

- Unauthorized use of your AdMob account
- Potential revenue loss
- Account suspension
- Security vulnerabilities

## 🔧 Current Security Implementation

### Android Configuration

The Android app uses a secure configuration system:

1. **Primary**: Reads from `android/key.properties` (not committed to VCS)
2. **Fallback**: Uses environment variable `ADMOB_APP_ID`
3. **Default**: Falls back to Google's test AdMob App ID for development

```kotlin
manifestPlaceholders["ADMOB_APP_ID"] = keystoreProperties.getProperty("ADMOB_APP_ID")
    ?: System.getenv("ADMOB_APP_ID")
    ?: "ca-app-pub-3940256099942544~3347511713" // Google's test ID
```

### iOS Configuration

Currently uses hardcoded test ID in `Info.plist`. **This should be updated for production.**

## 🛡️ Secure Setup Instructions

### Step 1: Android Setup

1. Copy the example file:

```bash
cp android/key.properties.example android/key.properties
```

2. Edit `android/key.properties` with your actual AdMob App ID:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../release-key.jks
ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
```

### Step 2: iOS Setup

1. Copy the example configuration:

```bash
cp ios/Runner/Config.xcconfig.example ios/Runner/Config.xcconfig
```

2. Edit `ios/Runner/Config.xcconfig`:

```
ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
```

3. Update `Info.plist` to use the configuration variable:

```xml
<key>GADApplicationIdentifier</key>
<string>$(ADMOB_APP_ID)</string>
```

### Step 3: Environment Variables (Alternative)

You can also use environment variables:

```bash
# For development
export ADMOB_APP_ID=ca-app-pub-3940256099942544~3347511713

# For production
export ADMOB_APP_ID=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
```

## 🎯 Ad Unit IDs Security

Ad Unit IDs should also be kept secure. Use the `.env` file approach:

1. Copy the example:

```bash
cp .env.example .env
```

2. Add your actual Ad Unit IDs:

```env
AD_UNIT_INTERSTITIAL_ANDROID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
AD_UNIT_INTERSTITIAL_IOS=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

## 📋 .gitignore Verification

Ensure these files are in your `.gitignore`:

```gitignore
# AdMob Security
android/key.properties
ios/Runner/Config.xcconfig
.env

# Keystores
*.jks
*.keystore
release-key.*
```

## 🚨 What NOT to Commit

❌ **NEVER commit these files:**

- `android/key.properties` (contains signing keys and AdMob App ID)
- `ios/Runner/Config.xcconfig` (contains AdMob App ID)
- `.env` (contains Ad Unit IDs)
- Any keystore files (`.jks`, `.keystore`)

✅ **Safe to commit:**

- `android/key.properties.example`
- `ios/Runner/Config.xcconfig.example`
- `.env.example`

## 🛠️ For Contributors/Developers

If you're using this project as a template:

1. **For Development**: The app will work with test ads by default
2. **For Production**: Follow the setup instructions above
3. **Never**: Share your actual AdMob IDs in issues, PRs, or documentation

## 🔍 Security Checklist

Before pushing to a public repository:

- [ ] Verify `android/key.properties` is not committed
- [ ] Check that `Info.plist` doesn't contain your actual AdMob App ID
- [ ] Ensure `.env` file is not committed
- [ ] Confirm all keystore files are excluded
- [ ] Test that the app builds with test IDs

## 📚 Additional Resources

- [AdMob Security Best Practices](https://developers.google.com/admob/android/privacy/play-data-disclosure)
- [Flutter Security Guidelines](https://docs.flutter.dev/deployment/security)
- [Git Security](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure)
