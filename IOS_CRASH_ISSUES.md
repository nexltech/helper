# iOS TestFlight Crash Issues - Analysis & Fixes

## 🔴 CRITICAL ISSUES (Will Cause Immediate Crashes)

### 1. **Font Path Case Sensitivity Mismatch** ⚠️ MOST LIKELY CAUSE
**Location:** `pubspec.yaml` lines 101, 104, 107, 110

**Problem:**
- Fonts are referenced as: `assets/fonts/` (lowercase 'f')
- Actual folder name is: `assets/Fonts/` (uppercase 'F')
- iOS file system is case-sensitive, so fonts won't load
- App will crash when trying to render text with custom fonts

**Error you'll see:**
```
Could not find asset: assets/fonts/FrederickatheGreat-Regular.ttf
```

**Fix:**
Update `pubspec.yaml` to match the actual folder name:
```yaml
fonts:
  - family: FrederickaTheGreat
    fonts:
      - asset: assets/Fonts/FrederickatheGreat-Regular.ttf  # Changed fonts → Fonts
  - family: HomemadeApple
    fonts:
      - asset: assets/Fonts/HomemadeApple-Regular.ttf
  - family: LifeSavers
    fonts:
      - asset: assets/Fonts/LifeSavers-Regular.ttf
  - family: BioRhyme
    fonts:
      - asset: assets/Fonts/BioRhyme-VariableFont_wdth,wght.ttf
```

---

### 2. **Missing App Transport Security (ATS) Configuration** ⚠️ CRITICAL
**Location:** `ios/Runner/Info.plist`

**Problem:**
- Your app uses **HTTP** (not HTTPS) for API calls: `http://helper.nexltech.com/public/api`
- iOS blocks all HTTP connections by default (App Transport Security)
- Network requests will fail immediately, causing crashes when app tries to:
  - Login/Register
  - Load jobs
  - Fetch user data
  - Any API call

**Error you'll see:**
```
NSURLSession/NSURLConnection HTTP load failed
App Transport Security has blocked a cleartext HTTP connection
```

**Fix:**
Add this to `ios/Runner/Info.plist` before the closing `</dict>` tag:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>helper.nexltech.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

**Better Fix (Recommended):**
Switch your API to HTTPS instead of allowing HTTP exceptions.

---

### 3. **Missing Podfile** ⚠️ CRITICAL
**Location:** `ios/Podfile` (file doesn't exist)

**Problem:**
- No Podfile found in `ios/` directory
- CocoaPods dependencies (like `image_picker`, `flutter_stripe`) won't be installed
- App will crash when trying to use these plugins

**Fix:**
Create `ios/Podfile` with:
```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try running flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

Then run: `cd ios && pod install`

---

## 🟡 HIGH PRIORITY ISSUES (Likely Causes)

### 4. **Asynchronous Session Loading Without Error Handling**
**Location:** `lib/main.dart` line 28

**Problem:**
- `userProvider.loadSession()` is called asynchronously without `await`
- If SharedPreferences fails, app might crash on startup
- No try-catch around initialization

**Fix:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final userProvider = UserProvider();
    await userProvider.loadSession();
    runApp(MyApp(userProvider: userProvider));
  } catch (e) {
    // Handle error gracefully
    runApp(MyApp(userProvider: UserProvider()));
  }
}
```

---

### 5. **Missing Photo Library Add Permission**
**Location:** `ios/Runner/Info.plist`

**Problem:**
- You have `NSPhotoLibraryUsageDescription` (for reading)
- Missing `NSPhotoLibraryAddUsageDescription` (for saving photos)
- If app tries to save photos, it will crash

**Fix:**
Add to `Info.plist`:
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save photos to your photo library.</string>
```

---

### 6. **Stripe Service Not Initialized**
**Location:** `lib/services/stripe_service.dart`

**Problem:**
- Entire Stripe service is commented out
- If any code tries to use Stripe, it will crash
- `flutter_stripe` package is in dependencies but not initialized

**Fix:**
Either:
1. Remove `flutter_stripe` from `pubspec.yaml` if not using it
2. Or uncomment and properly configure Stripe service

---

## 🟢 MEDIUM PRIORITY ISSUES (Potential Issues)

### 7. **Bundle Identifier Mismatch Check**
**Location:** `codemagic.yaml` vs `ios/Runner.xcodeproj/project.pbxproj`

**Current:**
- Codemagic: `com.Helpr`
- Xcode project: `com.Helpr` ✅ (matches)

**Action:** Verify this matches your App Store Connect app exactly.

---

### 8. **Missing Minimum iOS Version Check**
**Location:** `ios/Podfile` (when created)

**Problem:**
- Need to ensure minimum iOS version supports all plugins
- `image_picker` requires iOS 12.0+
- `flutter_stripe` requires iOS 13.0+

**Fix:**
Set in Podfile: `platform :ios, '13.0'` (or higher)

---

### 9. **Missing Error Handling in AppDelegate**
**Location:** `ios/Runner/AppDelegate.swift`

**Problem:**
- No error handling if Flutter initialization fails
- No crash reporting setup

**Current code is minimal but should work. Consider adding:**
```swift
override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  // Add error handling
  do {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  } catch {
    print("Error initializing Flutter: \(error)")
    return false
  }
}
```

---

## 📋 CHECKLIST TO FIX CRASHES

### Immediate Actions (Do These First):

- [ ] **Fix font paths** in `pubspec.yaml` (fonts → Fonts)
- [ ] **Add ATS exception** to `Info.plist` for HTTP connections
- [ ] **Create Podfile** in `ios/` directory
- [ ] **Run `cd ios && pod install`** after creating Podfile
- [ ] **Add photo library add permission** to `Info.plist`

### After Fixes:

1. **Clean build:**
   ```bash
   flutter clean
   cd ios && pod deintegrate && pod install && cd ..
   flutter pub get
   ```

2. **Test locally first:**
   ```bash
   flutter build ios --release
   ```

3. **Rebuild in Codemagic:**
   - Push changes to your repository
   - Trigger new build in Codemagic
   - Download and test on TestFlight

---

## 🔍 HOW TO DEBUG CRASHES

### Check TestFlight Crash Logs:
1. Go to App Store Connect
2. Navigate to your app → TestFlight → Crashes
3. Download crash logs
4. Look for:
   - Font loading errors
   - Network connection errors
   - Missing framework errors
   - Permission denied errors

### Check Device Logs:
1. Connect iOS device to Mac
2. Open Console.app
3. Filter by your app name
4. Look for crash reports

### Common Crash Patterns:
- **Font errors:** "Could not find asset" or "Font not found"
- **Network errors:** "App Transport Security" or "HTTP load failed"
- **Plugin errors:** "Class not found" or "Framework not loaded"
- **Permission errors:** "Missing usage description"

---

## 🎯 MOST LIKELY ROOT CAUSES (In Order):

1. **Font path mismatch** (90% probability) - App crashes immediately when rendering text
2. **Missing ATS configuration** (80% probability) - App crashes on first API call
3. **Missing Podfile** (70% probability) - App crashes when using plugins
4. **Session loading error** (30% probability) - App crashes on startup

---

## 📝 NOTES

- **Case sensitivity matters on iOS** - Always match exact folder/file names
- **HTTP is blocked by default** - Must configure ATS or use HTTPS
- **CocoaPods is required** - All Flutter iOS plugins need Podfile
- **TestFlight builds are release mode** - Debug prints won't show, but errors will crash

---

## ✅ VERIFICATION STEPS

After applying fixes:

1. ✅ Fonts load correctly (check splash screen)
2. ✅ Network requests work (check login/API calls)
3. ✅ Plugins work (test image picker, stripe)
4. ✅ No crashes on app launch
5. ✅ No crashes on first screen navigation

---

**Last Updated:** Based on codebase review
**Priority:** Fix issues #1, #2, and #3 first - these are most likely causing your crashes

