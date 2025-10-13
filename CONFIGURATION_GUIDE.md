# 📋 Configuration Guide

This guide explains the two-file configuration system used in SensorLab for secure credential management.

## 🔧 Configuration Files Overview

SensorLab uses two separate configuration files for different purposes:

### 1. `android/key.properties` - Android Signing & AdMob App ID

- **Purpose**: Android app signing credentials and AdMob App ID
- **Required for**: Building release APKs
- **Contains**: Keystore info, passwords, AdMob App ID
- **Security**: ❌ Never commit to version control

### 2. `.env` - Environment Variables (Optional)

- **Purpose**: AdMob ad unit IDs and API keys
- **Required for**: Production ads (optional)
- **Contains**: Ad unit IDs, API keys for optional features
- **Security**: ❌ Never commit to version control

## 🚀 Quick Setup

### For Development (Test Ads)

```bash
# Just run the app - uses test ads by default
flutter run
```

### For Production Release

```bash
# 1. Set up Android signing
cp android/key.properties.example android/key.properties
# Edit android/key.properties with your keystore info

# 2. (Optional) Set up production ads
cp .env.example .env
# Edit .env with your AdMob ad unit IDs

# 3. Build release
flutter build apk --release
```

## 📁 File Details

### `android/key.properties`

```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../path/to/your/keystore.jks
ADMOB_APP_ID=ca-app-pub-3940256099942544~3347511713
```

### `.env` (Optional)

```env
# AdMob Ad Units (uses test IDs if not set)
AD_UNIT_INTERSTITIAL_ANDROID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
AD_UNIT_INTERSTITIAL_IOS=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX

# Future API Keys
GOOGLE_MAPS_API_KEY=your_api_key_here
```

## 🛡️ Security Features

### Automatic Fallbacks

- **Missing `.env`**: Uses Google's test ad IDs automatically
- **Missing `key.properties`**: Debug builds work normally
- **Invalid credentials**: Clear error messages guide you to fix

### Version Control Protection

```gitignore
# These files are automatically ignored
android/key.properties
.env
**/*.keystore
**/*.jks
```

## ❓ FAQ

**Q: Do I need both files?**
A: For development, neither is required. For production releases, you need `key.properties`. The `.env` file is optional for custom ad configurations.

**Q: What if I don't set up AdMob?**
A: The app works perfectly with Google's test ads. No revenue, but fully functional for testing and development.

**Q: Can I use different ad networks?**
A: Currently only AdMob is supported, but the modular architecture makes it easy to add other networks.

**Q: Where do I get AdMob credentials?**
A: Create an account at [AdMob Console](https://admob.google.com/), create an app, and get your App ID and ad unit IDs from there.

## 🔍 Troubleshooting

### Build Issues

```bash
# Error: key.properties not found
cp android/key.properties.example android/key.properties
# Edit the file with your actual keystore details

# Error: keystore not found
# Verify the storeFile path in key.properties points to your actual keystore
```

### AdMob Issues

```bash
# No ads showing
# Check if you're using test device or have test ads configured properly

# Invalid AdMob App ID
# Verify ADMOB_APP_ID in android/key.properties matches your AdMob console
```

## 📚 Related Documentation

- **[Android Setup Guide](ANDROID_SETUP.md)** - Detailed Android configuration
- **[Main README](README.md)** - General setup and requirements
- **[Security Guide](https://docs.flutter.dev/deployment/android)** - Flutter security best practices
