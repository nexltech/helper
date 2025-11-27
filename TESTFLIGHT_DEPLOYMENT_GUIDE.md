# TestFlight Deployment Guide

## Prerequisites
1. **Apple Developer Account** - You need an active Apple Developer Program membership ($99/year)
2. **App Store Connect Access** - Your Apple ID must have access to App Store Connect
3. **Xcode** - Latest version installed and configured

## Current App Configuration
- **Bundle ID**: `com.Helpr`
- **Development Team**: `P85MCK558V`
- **Version**: `1.0.3+13`
- **App Name**: Job

## Step-by-Step Deployment Process

### Step 1: Configure Xcode Signing

1. **Open Xcode** (already opened for you)
   - File: `ios/Runner.xcworkspace`

2. **Add Your Apple Developer Account**
   - Go to **Xcode > Settings > Accounts** (or **Preferences > Accounts**)
   - Click the **+** button
   - Select **Apple ID**
   - Sign in with your Apple Developer account

3. **Configure Signing & Capabilities**
   - In Xcode, select the **Runner** project in the left sidebar
   - Select the **Runner** target
   - Go to **Signing & Capabilities** tab
   - Check **"Automatically manage signing"**
   - Select your **Team** from the dropdown (should show your team name)
   - Xcode will automatically create provisioning profiles

### Step 2: Create App in App Store Connect

1. **Go to App Store Connect**
   - Visit: https://appstoreconnect.apple.com
   - Sign in with your Apple Developer account

2. **Create New App**
   - Click **"My Apps"**
   - Click the **+** button
   - Select **"New App"**
   - Fill in:
     - **Platform**: iOS
     - **Name**: Job (or your preferred name)
     - **Primary Language**: English
     - **Bundle ID**: `com.Helpr` (must match exactly)
     - **SKU**: Can be any unique identifier (e.g., `job-app-001`)
     - **User Access**: Full Access (or Limited Access for team members)

3. **Save** the app

### Step 3: Build and Archive

**Option A: Using Xcode (Recommended for first time)**

1. In Xcode, select **Product > Destination > Any iOS Device (arm64)**
2. Go to **Product > Archive**
3. Wait for the archive to complete
4. The **Organizer** window will open automatically

**Option B: Using Flutter Command Line**

```bash
export PATH="$PATH:/Applications/flutter/bin"
export LANG=en_US.UTF-8
cd /Users/alizafar/Downloads/helper
flutter build ipa --release
```

The IPA file will be created at: `build/ios/ipa/job.ipa`

### Step 4: Upload to App Store Connect

**Option A: Using Xcode Organizer**

1. In the **Organizer** window (after archiving)
2. Select your archive
3. Click **"Distribute App"**
4. Select **"App Store Connect"**
5. Click **"Next"**
6. Select **"Upload"**
7. Click **"Next"**
8. Review the app information
9. Click **"Upload"**
10. Wait for the upload to complete (may take 10-30 minutes)

**Option B: Using Command Line (xcrun altool or Transporter)**

```bash
# Using xcrun altool (requires Xcode 13 or earlier)
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/job.ipa \
  --username YOUR_APPLE_ID \
  --password YOUR_APP_SPECIFIC_PASSWORD

# OR using Transporter app (Xcode 14+)
# Open Transporter app and drag the IPA file
```

**Option C: Using Flutter (if configured)**

```bash
flutter build ipa --release
# Then use Xcode Organizer or Transporter to upload
```

### Step 5: Configure TestFlight

1. **Go to App Store Connect**
   - Navigate to your app
   - Click on **"TestFlight"** tab

2. **Wait for Processing**
   - After upload, Apple processes the build (15 minutes to 2 hours)
   - You'll receive an email when processing is complete

3. **Add Internal Testers (Immediate)**
   - Go to **TestFlight > Internal Testing**
   - Click **"+"** to add internal testers
   - Add team members by their Apple ID email
   - Internal testers can test immediately (up to 100 testers)

4. **Add External Testers (Requires Beta Review)**
   - Go to **TestFlight > External Testing**
   - Create a new group or use default
   - Add the build
   - Fill in **"What to Test"** information
   - Submit for Beta App Review (takes 24-48 hours)
   - Once approved, external testers can download

### Step 6: Invite Testers

1. **Internal Testers**
   - They'll receive an email invitation
   - Or they can download **TestFlight app** from App Store
   - Sign in with their Apple ID
   - The app will appear automatically

2. **External Testers**
   - After Beta Review approval
   - Share the public TestFlight link
   - Or invite via email

## Troubleshooting

### Signing Issues
- **Error**: "No profiles for 'com.Helpr' were found"
  - **Solution**: Make sure you've added your Apple Developer account in Xcode
  - Enable "Automatically manage signing" in Xcode
  - Ensure Bundle ID matches in Xcode and App Store Connect

### Upload Issues
- **Error**: "Invalid Bundle"
  - **Solution**: Check that version number is incremented
  - Ensure all required app icons are present
  - Verify Info.plist is correctly configured

### TestFlight Issues
- **Build not appearing**: Wait for processing (can take up to 2 hours)
- **Can't add testers**: Ensure they have valid Apple IDs
- **Testers can't install**: Check that their device UDID is registered (for external testing)

## Quick Commands Reference

```bash
# Set environment
export PATH="$PATH:/Applications/flutter/bin"
export LANG=en_US.UTF-8

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build for release
flutter build ipa --release

# Check devices
flutter devices

# Open Xcode
open ios/Runner.xcworkspace
```

## Next Steps After Upload

1. **Monitor Build Status** in App Store Connect
2. **Add Test Information** for external testers
3. **Collect Feedback** from testers
4. **Fix Issues** and upload new builds as needed
5. **Submit for App Review** when ready for App Store release

## Important Notes

- Each build must have a unique build number (currently: 13)
- Version number format: `1.0.3` (from pubspec.yaml)
- Build number increments automatically with each upload
- TestFlight builds expire after 90 days
- You can have multiple builds in TestFlight simultaneously


