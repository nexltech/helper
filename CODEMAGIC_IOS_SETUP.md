# Codemagic iOS Build Setup Guide

This guide will help you set up iOS builds on Codemagic without needing a Mac or Apple device.

## Prerequisites

You have been provided with:
- **Key ID**: `B38QR4VAKC`
- **Issuer**: `55c4b380-75fe-460c-b538-e9297d246bce`
- **.p8 file**: (API Key file from Apple Developer)
- Access to Apple Developer account / App Store Connect

## Step 1: Create App Store Connect API Key

If you haven't already:

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** → **Keys** tab
3. Click the **+** button to create a new key
4. Select **App Manager** or **Admin** access
5. Download the `.p8` file (you can only download it once!)
6. Note the **Key ID** and **Issuer ID** (you have these already)

## Step 2: Update Bundle Identifier

**IMPORTANT**: Your current bundle identifier is `com.example.job`. This is a placeholder and won't work for App Store submission.

You need to:
1. Get the actual bundle identifier from your client (it should be something like `com.yourcompany.job`)
2. Update it in the Xcode project or we can help you update it

Current location: `ios/Runner.xcodeproj/project.pbxproj` (line 371, 550, 572)

## Step 3: Configure Codemagic

### 3.1 Add App Store Connect API Credentials

1. Go to [Codemagic](https://codemagic.io/)
2. Open your project
3. Go to **Settings** → **Encrypted environment variables**
4. Click **Add variable** and add these variables:

   ```
   APP_STORE_CONNECT_ISSUER_ID=55c4b380-75fe-460c-b538-e9297d246bce
   APP_STORE_CONNECT_KEY_IDENTIFIER=B38QR4VAKC
   ```

5. Go to **Settings** → **Code signing identities**
6. Click **Add signing identity**
7. Upload your `.p8` file (the API key file from Apple)
8. Name it something like "App Store Connect API Key"

### 3.2 Create Code Signing Group

1. In Codemagic, go to **Settings** → **Code signing identities**
2. Create a new group or use existing group named: `app_store_credentials`
3. Add your App Store Connect API credentials to this group:
   - Add the issuer ID variable: `APP_STORE_CONNECT_ISSUER_ID`
   - Add the key ID variable: `APP_STORE_CONNECT_KEY_IDENTIFIER`
   - Add the `.p8` file as a certificate
4. The group name should match what's in `codemagic.yaml`: `app_store_credentials`

### 3.3 Configure Provisioning Profiles (Automatic)

Codemagic can automatically manage provisioning profiles if you:
1. Make sure the bundle identifier matches what's registered in Apple Developer
2. Use the App Store Connect API key (which you're doing)
3. Codemagic will automatically create/download the provisioning profile

**Note**: If you have existing provisioning profiles:
1. Go to Apple Developer Portal
2. Download your distribution provisioning profile (`.mobileprovision` file)
3. Upload it to Codemagic under **Code signing identities**

## Step 4: Create Export Options Plist

Codemagic needs an export options plist file. We'll create it automatically, but here's what it should contain:

Create a file at the root called `export_options.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

## Step 5: Update codemagic.yaml

Before running the build, update these values in `codemagic.yaml`:

1. **Bundle Identifier**: Change `com.example.job` to your actual bundle ID
2. **Email**: Update the email in the publishing section to receive build notifications

## Step 6: Connect Your Repository

1. Connect your Git repository to Codemagic
2. Select the `codemagic.yaml` file as the configuration
3. Codemagic will detect the workflow automatically

## Step 7: Run Your First Build

1. Click **Start new build**
2. Select the `ios-workflow` from the workflow dropdown
3. Select your branch
4. Click **Start new build**

## Step 8: Download and Install the IPA

After the build completes:

1. **Download the IPA**: The build artifacts will include an `.ipa` file
2. **Install on Device**: 
   - For TestFlight: Upload to App Store Connect, then use TestFlight app
   - For Direct Install: Use tools like:
     - [Apple Configurator 2](https://apps.apple.com/us/app/apple-configurator-2/id1037126344) (requires Mac)
     - [3uTools](https://www.3u.com/) (Windows)
     - [AltStore](https://altstore.io/) (requires signing)
     - [TestFlight](https://developer.apple.com/testflight/) (recommended for testing)

## Troubleshooting

### Error: "No matching provisioning profile found"

**Solution**: 
- Make sure your bundle identifier is correctly registered in Apple Developer
- Check that the bundle ID in `codemagic.yaml` matches your App Store Connect app

### Error: "Invalid API Key"

**Solution**:
- Verify the Key ID and Issuer ID are correct
- Make sure the `.p8` file is uploaded correctly
- Check that the API key has the correct permissions in App Store Connect

### Error: "Code signing failed"

**Solution**:
- Ensure the code signing group name matches `app_store_credentials` in the YAML
- Check that all required certificates are uploaded
- Verify the bundle identifier matches across all locations

### Build fails with "Pod install error"

**Solution**:
- Check the CocoaPods version in the script
- Ensure all Flutter dependencies are compatible with iOS

## Important Notes

1. **Bundle Identifier**: You MUST update `com.example.job` to your actual bundle identifier before building
2. **TestFlight**: To distribute via TestFlight, uncomment the `submit_to_testflight: true` line in the YAML
3. **First Build**: The first build may take longer as Codemagic sets up certificates and profiles
4. **Free Tier**: Codemagic free tier has build time limits - consider upgrading for production use

## Next Steps

1. ✅ Get your actual bundle identifier from the client
2. ✅ Update bundle identifier in the project
3. ✅ Upload `.p8` file to Codemagic
4. ✅ Configure code signing group
5. ✅ Run first build
6. ✅ Install on device via TestFlight or direct install

## Useful Links

- [Codemagic iOS Setup Docs](https://docs.codemagic.io/getting-started/building-for-ios/)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [TestFlight](https://developer.apple.com/testflight/)

---

**Need Help?** If you encounter any issues, check the Codemagic build logs and error messages for specific guidance.

