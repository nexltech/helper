# How to Run the Flutter App

## 🚀 Quick Start

### Option 1: Using Flutter Command (If Flutter is in PATH)

```bash
# 1. Get dependencies
flutter pub get

# 2. Check connected devices
flutter devices

# 3. Run the app
flutter run
```

### Option 2: Using Full Flutter Path

If Flutter is not in your PATH, find where it's installed and use the full path:

```bash
# Example (adjust path to your Flutter installation):
C:\flutter\bin\flutter.bat pub get
C:\flutter\bin\flutter.bat devices
C:\flutter\bin\flutter.bat run
```

### Option 3: Using VS Code / Android Studio

1. **VS Code:**
   - Open the project folder
   - Press `F5` or click "Run" → "Start Debugging"
   - Select your device/emulator

2. **Android Studio:**
   - Open the project
   - Click the green "Run" button
   - Select your device/emulator

---

## 📱 Running on Different Platforms

### Android (Emulator or Device)

```bash
# List available devices
flutter devices

# Run on Android
flutter run

# Or specify device
flutter run -d <device-id>
```

**Prerequisites:**
- Android Studio installed
- Android emulator running OR physical device connected via USB with USB debugging enabled

### iOS (Simulator or Device)

```bash
# List available devices
flutter devices

# Run on iOS
flutter run

# Or specify device
flutter run -d <device-id>
```

**Prerequisites:**
- Xcode installed (Mac only)
- iOS Simulator running OR physical device connected

### Web

```bash
# Run on web browser
flutter run -d chrome

# Or
flutter run -d edge
```

---

## 🔧 Before Running

### 1. Install Dependencies

```bash
flutter pub get
```

This installs all packages including the new `flutter_launcher_icons` package.

### 2. Generate Icons (Optional - if you've added icon.png)

```bash
flutter pub run flutter_launcher_icons
```

### 3. Check for Devices

```bash
flutter devices
```

You should see something like:
```
2 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64  • Android 13 (API 33)
Chrome (web)                • chrome        • web-javascript • Google Chrome
```

---

## 🐛 Troubleshooting

### Flutter Not Found

**Solution:** Add Flutter to your PATH or use full path.

1. Find Flutter installation:
   - Usually in: `C:\flutter\` or `%LOCALAPPDATA%\flutter\`

2. Add to PATH:
   - Windows: System Properties → Environment Variables → Add Flutter\bin to PATH
   - Or use full path: `C:\flutter\bin\flutter.bat`

### No Devices Found

**For Android:**
- Start Android Studio
- Open AVD Manager
- Start an emulator
- Or connect physical device with USB debugging enabled

**For iOS (Mac only):**
- Open Xcode
- Start iOS Simulator
- Or connect physical device

### Build Errors

```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Try running again
flutter run
```

---

## 📋 Step-by-Step: First Time Setup

1. **Install Flutter** (if not installed):
   - Download from: https://flutter.dev/docs/get-started/install/windows
   - Extract and add to PATH

2. **Install Android Studio** (for Android):
   - Download from: https://developer.android.com/studio
   - Install Android SDK and create an emulator

3. **Open Project:**
   ```bash
   cd "C:\Users\Dell\OneDrive\Documents\nexltech\helper"
   ```

4. **Get Dependencies:**
   ```bash
   flutter pub get
   ```

5. **Check Devices:**
   ```bash
   flutter devices
   ```

6. **Run App:**
   ```bash
   flutter run
   ```

---

## 🎯 Quick Commands Reference

```bash
# Get dependencies
flutter pub get

# Check devices
flutter devices

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Build APK (Android)
flutter build apk

# Build IPA (iOS - Mac only)
flutter build ipa

# Clean build
flutter clean
```

---

## 💡 Tips

- **First run is slower** - Flutter needs to compile everything
- **Hot reload** - Press `r` in terminal to hot reload, `R` for hot restart
- **Stop app** - Press `q` in terminal
- **Check logs** - Errors will show in terminal

---

**Need Help?** Check Flutter documentation: https://flutter.dev/docs

