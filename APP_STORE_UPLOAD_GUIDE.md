# App Store Upload Guide

## Current Version
- **Version**: 1.0.4
- **Build Number**: 17

## Prerequisites
1. ✅ Apple Developer Account (active subscription)
2. ✅ App Store Connect access
3. ✅ Valid provisioning profiles and certificates
4. ✅ Xcode installed and updated

## Step-by-Step Upload Process

### Step 1: Clean and Prepare
```bash
cd /Users/zahidali/Downloads/helper
flutter clean
flutter pub get
```

### Step 2: Build iOS Release
```bash
flutter build ios --release
```

### Step 3: Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### Step 4: In Xcode - Configure Signing
1. Select **Runner** project in the navigator
2. Select **Runner** target
3. Go to **Signing & Capabilities** tab
4. Ensure:
   - ✅ **Automatically manage signing** is checked (or manually select your team)
   - ✅ **Bundle Identifier** is correct
   - ✅ **Provisioning Profile** is valid
   - ✅ **Signing Certificate** is valid

### Step 5: Set Build Configuration
1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme**
2. Select **Run** → **Build Configuration** → **Release**
3. Select **Archive** → **Build Configuration** → **Release**

### Step 6: Create Archive
1. In Xcode, select **Product** → **Archive**
2. Wait for the build to complete
3. The **Organizer** window will open automatically

### Step 7: Validate Archive
1. In the **Organizer** window, select your archive
2. Click **Validate App**
3. Follow the validation wizard:
   - Select your team
   - Select distribution method: **App Store Connect**
   - Wait for validation to complete
   - Fix any issues if they appear

### Step 8: Distribute to App Store
1. In the **Organizer** window, select your archive
2. Click **Distribute App**
3. Select **App Store Connect**
4. Click **Next**
5. Select **Upload**
6. Click **Next**
7. Select your distribution options:
   - ✅ Include bitcode (if required)
   - ✅ Upload symbols (for crash reporting)
8. Click **Next**
9. Review and click **Upload**
10. Wait for upload to complete

### Step 9: Submit for Review in App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps** → Select your app
3. Go to the **App Store** tab
4. Click **+ Version or Platform** (if creating new version)
5. Enter version number: **1.0.4**
6. Fill in:
   - **What's New in This Version** (release notes)
   - Screenshots (if needed)
   - Description updates (if needed)
7. Scroll down and click **Submit for Review**
8. Answer any export compliance questions
9. Click **Submit**

## Alternative: Using Command Line (Fastlane)

If you have Fastlane configured:
```bash
cd ios
fastlane beta  # For TestFlight
# or
fastlane release  # For App Store
```

## Alternative: Using Flutter Build and Xcode

### Quick Build Command
```bash
flutter build ipa --release
```

This creates an `.ipa` file that can be uploaded via:
- **Transporter** app (macOS)
- **Xcode Organizer**
- **App Store Connect** web interface

### Upload via Transporter
1. Open **Transporter** app (from Mac App Store)
2. Drag and drop the `.ipa` file
3. Click **Deliver**
4. Sign in with your Apple ID
5. Wait for upload to complete

## Troubleshooting

### Common Issues:

1. **Code Signing Errors**
   - Check provisioning profiles in Xcode
   - Ensure certificates are valid
   - Verify Bundle ID matches App Store Connect

2. **Archive Validation Fails**
   - Check for missing icons
   - Verify Info.plist is correct
   - Check for deprecated APIs

3. **Upload Fails**
   - Check internet connection
   - Verify Apple Developer account status
   - Check App Store Connect service status

4. **Version Already Exists**
   - Increment build number in `pubspec.yaml`
   - Rebuild and re-archive

## Version History
- **1.0.4+17** - Current (UI improvements, placeholder updates, apply modal theme)
- **1.0.3+16** - Previous

## Notes
- Always test on a physical device before submitting
- Ensure all required app icons are present
- Check that all permissions are properly configured
- Review App Store guidelines before submission
