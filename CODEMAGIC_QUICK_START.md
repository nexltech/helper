# Codemagic iOS Build - Quick Start Checklist

## ✅ What You Have
- Key ID: `B38QR4VAKC`
- Issuer: `55c4b380-75fe-460c-b538-e9297d246bce`
- `.p8` file from Apple Developer
- Access to App Store Connect

## 📋 Action Items

### 1. Get Bundle Identifier from Client ⚠️ CRITICAL
- Current: `com.example.job` (won't work!)
- Required: Actual bundle ID (e.g., `com.companyname.appname`)
- Update in: `ios/Runner.xcodeproj/project.pbxproj` and `codemagic.yaml`

### 2. Setup in Codemagic UI

#### A. Add Encrypted Variables
Go to: **Settings** → **Encrypted environment variables**

Add:
```
APP_STORE_CONNECT_ISSUER_ID = 55c4b380-75fe-460c-b538-e9297d246bce
APP_STORE_CONNECT_KEY_IDENTIFIER = B38QR4VAKC
```

#### B. Upload .p8 Certificate File
Go to: **Settings** → **Code signing identities**

1. Click **Add certificate**
2. Upload your `.p8` file
3. Name it: "App Store Connect API Key"

#### C. Create Code Signing Group
1. Go to **Code signing identities**
2. Create group: `app_store_credentials`
3. Add to this group:
   - The `.p8` certificate you uploaded
   - Variables: `APP_STORE_CONNECT_ISSUER_ID` and `APP_STORE_CONNECT_KEY_IDENTIFIER`

### 3. Update Configuration Files

#### Update `codemagic.yaml`:
```yaml
# Change these lines:
APP_ID: com.example.job  # → Your actual bundle ID
BUNDLE_ID: "com.example.job"  # → Your actual bundle ID

# Update email:
recipients:
  - your-email@example.com  # → Your actual email
```

### 4. Connect Repository
1. In Codemagic, click **Add application**
2. Connect your Git repository
3. Select **Use configuration file** → Choose `codemagic.yaml`

### 5. Run First Build
1. Click **Start new build**
2. Select branch (usually `main` or `master`)
3. Select workflow: `ios-workflow`
4. Click **Start new build**

### 6. After Build Success
1. Download the `.ipa` file from build artifacts
2. Upload to App Store Connect (if not auto-uploaded)
3. Add to TestFlight for testing
4. Install on device via TestFlight app

## 🚨 Common Issues

| Issue | Solution |
|-------|----------|
| "No matching provisioning profile" | Update bundle identifier |
| "Invalid API Key" | Check Key ID and Issuer ID are correct |
| "Code signing failed" | Verify code signing group name matches `app_store_credentials` |
| Build timeout | Upgrade Codemagic plan or optimize build scripts |

## 📞 Need Help?

1. Check build logs in Codemagic
2. Review `CODEMAGIC_IOS_SETUP.md` for detailed instructions
3. Codemagic documentation: https://docs.codemagic.io/getting-started/building-for-ios/

---

**Estimated Setup Time**: 15-30 minutes  
**First Build Time**: 10-20 minutes

