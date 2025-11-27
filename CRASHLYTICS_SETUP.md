# Firebase Crashlytics Setup Guide

This guide will help you integrate Firebase Crashlytics to get detailed crash reports from your TestFlight builds.

## Benefits of Crashlytics

✅ **Real-time crash reports** - See crashes as they happen  
✅ **Detailed stack traces** - Know exactly where and why crashes occur  
✅ **User context** - See which devices, OS versions, and app versions are affected  
✅ **Non-fatal errors** - Track errors that don't crash the app  
✅ **Better debugging** - Get crash logs even from release builds  

## Prerequisites

1. Firebase project created at https://console.firebase.google.com
2. iOS app added to Firebase project
3. GoogleService-Info.plist downloaded from Firebase

## Step 1: Add Dependencies

Update `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_crashlytics: ^4.0.0
  # ... your existing dependencies
```

Then run:
```bash
flutter pub get
```

## Step 2: Configure iOS

### 2.1 Add GoogleService-Info.plist

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/` directory
3. Make sure it's added to Xcode project (right-click Runner folder → Add Files to "Runner")

### 2.2 Update Podfile

The Podfile should already have `platform :ios, '13.0'` which is required.

### 2.3 Update AppDelegate.swift

The AppDelegate.swift has been updated with Crashlytics initialization. Uncomment the Crashlytics code when ready.

### 2.4 Run Pod Install

```bash
cd ios
pod install
cd ..
```

## Step 3: Update main.dart

Uncomment the Firebase Crashlytics imports and initialization in `lib/main.dart`:

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase
    await Firebase.initializeApp();
    
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    // Pass all uncaught "fatal" errors from the platform to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    
    // ... rest of your code
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}
```

## Step 4: Update AppDelegate.swift

Uncomment the Crashlytics code in `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import FirebaseCore
import FirebaseCrashlytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    
    // Configure Crashlytics
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Step 5: Build and Test

1. **Build for release:**
   ```bash
   flutter build ios --release
   ```

2. **Upload to TestFlight** via Codemagic or manually

3. **Test crash reporting:**
   - Install app from TestFlight
   - Trigger a crash (optional - for testing)
   - Check Firebase Console → Crashlytics after a few minutes

## Step 6: Verify Setup

### Test Non-Fatal Error

Add this temporarily to test Crashlytics:

```dart
FirebaseCrashlytics.instance.log('Testing Crashlytics setup');
FirebaseCrashlytics.instance.recordError(
  Exception('Test error'),
  StackTrace.current,
  fatal: false,
);
```

### Test Fatal Crash

```dart
FirebaseCrashlytics.instance.crash();
```

**Note:** Remove test code after verifying Crashlytics works!

## Viewing Crash Reports

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Crashlytics** in the left menu
4. View crash reports with:
   - Stack traces
   - Device information
   - OS version
   - App version
   - Timestamp
   - User impact (number of affected users)

## Troubleshooting

### Crashlytics not showing crashes?

1. **Check GoogleService-Info.plist** - Make sure it's in `ios/Runner/` and added to Xcode
2. **Verify Firebase initialization** - Check logs for Firebase initialization errors
3. **Check build type** - Crashlytics only works in release builds (TestFlight uses release)
4. **Wait a few minutes** - Reports can take 1-5 minutes to appear in Firebase Console
5. **Check Firebase project** - Ensure iOS app is properly configured in Firebase Console

### Build errors?

1. **Run pod install** after adding dependencies:
   ```bash
   cd ios && pod install && cd ..
   ```

2. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..
   ```

3. **Check iOS deployment target** - Should be iOS 13.0+ (already set in Podfile)

## Current Status

✅ Error handlers set up in `main.dart`  
✅ Stripe initialization added (prevents crashes)  
✅ Global error handling configured  
⏳ Firebase Crashlytics ready to uncomment when Firebase project is set up  

## Next Steps

1. Create Firebase project (if not done)
2. Add iOS app to Firebase project
3. Download `GoogleService-Info.plist`
4. Uncomment Crashlytics code in `main.dart` and `AppDelegate.swift`
5. Run `flutter pub get` and `pod install`
6. Build and test!

## Need Help?

- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)
- [FlutterFire Setup Guide](https://firebase.flutter.dev/)
- Check `ADDITIONAL_IOS_CRASH_ISSUES.md` for other crash-related fixes

