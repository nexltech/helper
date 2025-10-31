# Codemagic iOS Setup - Step by Step

## Information I Need From You:
1. **Bundle Identifier**: What is the actual bundle ID? (Currently: `com.example.job`)
2. **Your Email**: For build notifications
3. **Confirm**: Do you have the `.p8` file ready?

---

## What I Can Do (Already Done):
✅ Created `codemagic.yaml` workflow file
✅ Created `ios/export_options.plist` for IPA export
✅ Set up build scripts and configuration
✅ Created documentation

---

## What You Need to Do in Codemagic UI:

### Step 1: Create Codemagic Account (if not done)
1. Go to [codemagic.io](https://codemagic.io)
2. Sign up/Login with GitHub/GitLab/Bitbucket

### Step 2: Connect Your Repository
1. Click **"Add application"**
2. Select your Git provider (GitHub/GitLab/Bitbucket)
3. Find and connect your `helper` repository
4. Select **"Build using configuration file"** → Choose `codemagic.yaml`

### Step 3: Add App Store Connect API Credentials
1. Go to **Settings** (gear icon) → **Encrypted environment variables**
2. Click **"Add variable"** and add these:

   **Variable 1:**
   - Name: `APP_STORE_CONNECT_ISSUER_ID`
   - Value: `55c4b380-75fe-460c-b538-e9297d246bce`
   - Click **"Add"**

   **Variable 2:**
   - Name: `APP_STORE_CONNECT_KEY_IDENTIFIER`
   - Value: `B38QR4VAKC`
   - Click **"Add"**

### Step 4: Upload .p8 Certificate File
1. Go to **Settings** → **Code signing identities**
2. Click **"Add certificate"**
3. Select **"App Store Connect API key"** type
4. Upload your `.p8` file
5. Name it: `App Store Connect API Key`
6. Click **"Save"**

### Step 5: Create Code Signing Group
1. Still in **Code signing identities**
2. Click **"Add group"** or find existing group
3. Group name: `app_store_credentials` (must match exactly!)
4. Add to this group:
   - The `.p8` certificate you just uploaded
   - Environment variables: `APP_STORE_CONNECT_ISSUER_ID` and `APP_STORE_CONNECT_KEY_IDENTIFIER`
5. Click **"Save"**

### Step 6: Update Bundle Identifier (If Needed)
Once you provide the actual bundle ID, I'll update:
- `codemagic.yaml`
- iOS Xcode project files

### Step 7: Run Your First Build
1. Go to your app in Codemagic
2. Click **"Start new build"**
3. Select your branch (usually `main` or `master`)
4. Workflow should auto-select: `ios-workflow`
5. Click **"Start new build"**

### Step 8: Download IPA
After build completes:
1. Go to **Build logs** → **Artifacts** tab
2. Download the `.ipa` file
3. Install via TestFlight or upload to App Store Connect

---

## Quick Checklist:
- [ ] Codemagic account created
- [ ] Repository connected
- [ ] Environment variables added (Issuer ID + Key ID)
- [ ] `.p8` file uploaded
- [ ] Code signing group `app_store_credentials` created
- [ ] Bundle identifier provided (so I can update files)
- [ ] First build triggered
- [ ] IPA downloaded

---

## Troubleshooting:

**"No matching provisioning profile"**
→ Bundle identifier mismatch. Provide correct bundle ID.

**"Invalid API Key"**
→ Double-check Issuer ID and Key ID are correct.

**"Code signing failed"**
→ Ensure code signing group name is exactly `app_store_credentials`.

**Build timeout**
→ Free tier has limits. Consider upgrading for production.

---

**Once you provide the bundle identifier and email, I'll update all configuration files automatically!**

