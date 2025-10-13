# 🍎 iOS Setup Guide for SensorLab

## 📋 Prerequisites

- **macOS** required for iOS development
- **Xcode** 14.0 or later
- **iOS Device/Simulator** iOS 12.0+
- **Apple Developer Account** (for device testing)

## 🔧 Initial Setup

### Step 1: Install Xcode & Tools

```bash
# Install Xcode from App Store
# Install Xcode command line tools
sudo xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept
```

### Step 2: Configure Flutter for iOS

```bash
# Install iOS deployment tools
flutter precache --ios

# Check iOS setup
flutter doctor

# Fix any iOS issues reported by flutter doctor
```

## 📱 Device Configuration

### For Physical Device Testing

1. **Enable Developer Mode**:

   - Settings → Privacy & Security → Developer Mode → Enable

2. **Trust Computer**:

   - Connect device to Mac
   - Trust the computer when prompted

3. **Add Apple ID to Xcode**:
   - Xcode → Preferences → Accounts → Add Apple ID

### Bundle Identifier Setup

Your app uses: `com.darahat.sensorlab`

**For App Store Release**:

- Register this Bundle ID in Apple Developer Console
- Configure App ID with required capabilities

## 🔐 Permissions & Capabilities

### Required iOS Permissions

Your app requests these permissions (already configured):

```xml
NSCameraUsageDescription - Camera access for flashlight and heart rate
NSMicrophoneUsageDescription - Microphone access for noise measurement
NSLocationWhenInUseUsageDescription - Location access for GPS features
NSMotionUsageDescription - Motion sensors for accelerometer/gyroscope
NSBluetoothAlwaysUsageDescription - Bluetooth for external sensors
```

### App Capabilities (if needed for App Store)

In Xcode project:

- ✅ Camera Access
- ✅ Location Services
- ✅ Motion & Fitness
- ✅ Bluetooth (optional)

## 🏗️ Building & Running

### Development Build

```bash
# Run on iOS Simulator
flutter run -d ios

# Run on connected iOS device
flutter devices
flutter run -d [device-id]
```

### Release Build

```bash
# Build iOS app
flutter build ios --release

# Open in Xcode for signing & distribution
open ios/Runner.xcworkspace
```

## 🐛 Common iOS Issues & Solutions

### 1. Code Signing Issues

```bash
# Error: No signing certificate found
# Solution: Add Apple ID to Xcode Accounts
# Or use automatic signing in Xcode
```

### 2. Permission Denied

```bash
# Error: Camera/Location permission denied
# Solution: Check Info.plist has usage descriptions
# Restart app after permission grant
```

### 3. Simulator Issues

```bash
# Error: No iOS simulators available
flutter emulators --launch apple_ios_simulator

# Error: Simulator won't start
# Reset simulator: Device → Erase All Content and Settings
```

### 4. Flutter iOS Build Issues

```bash
# Clean build cache
flutter clean
cd ios && rm -rf Pods Podfile.lock
cd .. && flutter pub get
cd ios && pod install

# Rebuild
flutter build ios
```

## 📊 Sensor Limitations on iOS

| Sensor        | iOS Support | Notes                           |
| ------------- | ----------- | ------------------------------- |
| Accelerometer | ✅ Full     | Native Core Motion              |
| Gyroscope     | ✅ Full     | Native Core Motion              |
| Magnetometer  | ✅ Full     | Compass functionality           |
| GPS           | ✅ Full     | Requires location permission    |
| Camera        | ✅ Full     | Flashlight & heart rate         |
| Microphone    | ✅ Full     | Noise level measurement         |
| Light         | ⚠️ Limited  | iOS doesn't expose light sensor |
| Proximity     | ✅ Full     | Native proximity sensor         |

## 🚀 App Store Preparation

### 1. Update Version Numbers

```yaml
# In pubspec.yaml
version: 1.0.0+1
```

### 2. App Store Requirements

- ✅ Privacy Policy (if collecting data)
- ✅ App Description & Screenshots
- ✅ Required permissions justified
- ✅ No use of private APIs

### 3. TestFlight Distribution

```bash
# Archive in Xcode
Product → Archive

# Upload to App Store Connect
Window → Organizer → Distribute App
```

## 📱 Testing Checklist

Before release, test these features on physical iOS device:

- [ ] All sensor readings work correctly
- [ ] Permissions requested properly
- [ ] App doesn't crash on sensor access
- [ ] Flashlight works (requires physical device)
- [ ] Heart rate detection works
- [ ] Location services function properly
- [ ] App respects iOS privacy guidelines

## 🆘 Support Resources

- **Flutter iOS Docs**: [flutter.dev/docs/deployment/ios](https://flutter.dev/docs/deployment/ios)
- **Apple Developer**: [developer.apple.com](https://developer.apple.com)
- **Xcode Documentation**: Built into Xcode Help menu
