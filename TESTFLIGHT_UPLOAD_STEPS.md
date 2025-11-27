# TestFlight Upload Steps - Using Xcode

## Prerequisites ✅
- iOS app built successfully
- Xcode workspace is now open

## Step-by-Step Instructions

### Step 1: Configure Signing in Xcode

1. **In Xcode, select the Runner project** (left sidebar, blue icon)
2. **Select the "Runner" target** (under TARGETS)
3. **Go to "Signing & Capabilities" tab**
4. **Check "Automatically manage signing"**
5. **Select your Team** from the dropdown (should show your Apple Developer account)
6. **Verify Bundle Identifier** is `com.Helpr`

### Step 2: Select Build Destination

1. **At the top of Xcode**, next to the Run/Stop buttons
2. **Click the device selector** (currently might say "iPhone 17 Pro" or similar)
3. **Select "Any iOS Device (arm64)"** - This is required for archiving
   - Do NOT select a simulator
   - Must be a physical device or "Any iOS Device"

### Step 3: Create Archive

1. **Go to menu: Product → Archive**
   - Or press `Cmd + B` to build, then `Product → Archive`
2. **Wait for the archive to complete** (may take 2-5 minutes)
3. **The Organizer window will open automatically** when archive is ready

### Step 4: Upload to App Store Connect

1. **In the Organizer window**, you'll see your archive listed
2. **Select your archive** (should show app name, version 1.0.3, build 13)
3. **Click "Distribute App"** button (right side)
4. **Select "App Store Connect"** → Click **"Next"**
5. **Select "Upload"** → Click **"Next"**
6. **Review the app information**:
   - Distribution options: Leave defaults
   - App Thinning: "All compatible device variants"
   - Click **"Next"**
7. **Review signing**:
   - Should show "Automatically manage signing"
   - Your team should be selected
   - Click **"Next"**
8. **Review and Upload**:
   - Review the summary
   - Click **"Upload"**
9. **Wait for upload to complete** (may take 10-30 minutes depending on file size)

### Step 5: Verify Upload in App Store Connect

1. **Go to App Store Connect**: https://appstoreconnect.apple.com
2. **Sign in** with your Apple Developer account
3. **Navigate to "My Apps"**
4. **Select your app** (or create it if it doesn't exist with Bundle ID: `com.Helpr`)
5. **Go to "TestFlight" tab**
6. **Wait for processing**:
   - Build will appear in "Processing" state
   - Processing takes 15 minutes to 2 hours
   - You'll receive an email when ready

### Step 6: Configure TestFlight

Once processing is complete:

#### For Internal Testing (Immediate - Up to 100 testers):
1. **Go to TestFlight → Internal Testing**
2. **Click "+" to create a group** (or use default "Internal Testers")
3. **Click "Add Build"** and select your processed build
4. **Add testers**:
   - Click "Add Testers"
   - Enter Apple ID emails of team members
   - They'll receive email invitations
5. **Testers can download immediately** via TestFlight app

#### For External Testing (Requires Beta Review - 24-48 hours):
1. **Go to TestFlight → External Testing**
2. **Create a new group** or use existing
3. **Add your build**
4. **Fill in "What to Test"** information:
   - Describe what testers should focus on
   - Include any known issues
5. **Submit for Beta App Review**
6. **Wait for approval** (usually 24-48 hours)
7. **Once approved**, share the public TestFlight link or invite testers

## Troubleshooting

### "No Accounts" Error
- **Solution**: Go to Xcode → Settings → Accounts
- Add your Apple Developer account
- Select your team in Signing & Capabilities

### "No profiles for 'com.Helpr' were found"
- **Solution**: Enable "Automatically manage signing" in Xcode
- Make sure your Apple Developer account is added
- Xcode will create provisioning profiles automatically

### Archive Button is Grayed Out
- **Solution**: Make sure you selected "Any iOS Device (arm64)" as destination
- Cannot archive for simulator

### Upload Fails
- **Check**: Bundle ID matches App Store Connect app
- **Check**: Version number is incremented (currently 1.0.3+13)
- **Check**: All required app icons are present
- **Check**: Info.plist is correctly configured

### Build Not Appearing in TestFlight
- **Wait**: Processing can take up to 2 hours
- **Check**: Email notifications for processing status
- **Verify**: Bundle ID matches exactly

## Current App Configuration

- **Bundle ID**: `com.Helpr`
- **Version**: `1.0.3` (from pubspec.yaml)
- **Build Number**: `13` (from pubspec.yaml)
- **App Name**: Job
- **Team**: P85MCK558V

## Quick Checklist

- [ ] Xcode workspace is open
- [ ] Signing & Capabilities configured
- [ ] Selected "Any iOS Device (arm64)"
- [ ] Created archive successfully
- [ ] Uploaded to App Store Connect
- [ ] Build processing in TestFlight
- [ ] Added internal testers (optional)
- [ ] Submitted for external testing (optional)

## Next Steps After Upload

1. **Monitor build status** in App Store Connect
2. **Add test information** for external testers
3. **Collect feedback** from testers
4. **Fix issues** and upload new builds as needed
5. **Submit for App Review** when ready for App Store release

---

**Note**: The first upload may take longer. Subsequent uploads are usually faster once the app is set up in App Store Connect.


