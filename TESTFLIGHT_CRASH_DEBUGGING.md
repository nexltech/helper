# TestFlight Crash Debugging Guide

## 🔴 Issue: App Crashes on TestFlight Install, No Crashlytics Data

If the app crashes immediately on TestFlight install and nothing appears in Firebase Crashlytics, this indicates the crash is happening **BEFORE** Crashlytics can initialize or send data.

---

## 🎯 Most Likely Causes

### 1. **GoogleService-Info.plist Not in Xcode Project** ⚠️ MOST LIKELY

**Problem:**
- File exists in `ios/Runner/` directory on disk
- But **NOT** added to Xcode project
- App can't find it at runtime → Firebase fails → Crashlytics doesn't work

**Check:**
1. Open `ios/Runner.xcworkspace` in Xcode (NOT `.xcodeproj`)
2. Check if `GoogleService-Info.plist` is visible in Project Navigator
3. If **NOT** visible → It's not in the Xcode project

**Fix:**
1. Right-click on `Runner` folder in Xcode
2. Select **"Add Files to Runner..."**
3. Navigate to `ios/Runner/GoogleService-Info.plist`
4. Make sure **"Copy items if needed"** is **UNCHECKED** (file already exists)
5. Make sure **"Create groups"** is selected
6. Make sure **"Runner"** is checked in "Add to targets"
7. Click **"Add"**
8. Verify it appears in Project Navigator
9. Select the file → Check File Inspector (right sidebar) → **"Target Membership"** → Ensure **"Runner"** is checked

---

### 2. **Pod Install Not Run** ⚠️ CRITICAL

**Problem:**
- Firebase pods not installed
- App crashes because required frameworks missing
- Happens on TestFlight because Codemagic must run `pod install`

**Check in Codemagic:**
- Look at build logs for `pod install` step
- Check if it completed successfully
- Look for errors about missing pods

**Fix:**
- Ensure `pod install` runs in Codemagic (should be in your codemagic.yaml)
- Check that `Podfile.lock` exists in `ios/` directory
- Verify `Pods/` directory contains Firebase frameworks

---

### 3. **Bundle ID Mismatch** ✅ FIXED

**Status:** ✅ Fixed in version 1.0.4+10
- `codemagic.yaml`: `com.Helper`
- `GoogleService-Info.plist`: `com.Helper`
- These now match ✅

---

### 4. **Plugin Registration Crash** ⚠️ POSSIBLE

**Problem:**
- One of the Flutter plugins crashes during registration
- Happens before Flutter starts
- Before Crashlytics can send data

**Check:**
- Look at Codemagic build logs for plugin registration errors
- Check if all dependencies are compatible

**Fix:**
- We've added crash protection in AppDelegate (v1.0.4+10)
- Errors will be logged to console
- Should appear in Crashlytics if Firebase is initialized

---

### 5. **Missing Required Frameworks** ⚠️ POSSIBLE

**Problem:**
- Required iOS frameworks not linked
- App crashes on launch

**Check:**
- Look at Xcode build settings
- Check "Linked Frameworks and Libraries"
- Should include: Foundation, UIKit, etc.

**Fix:**
- Usually handled by Flutter automatically
- If issues persist, may need manual linking

---

## 🔍 How to Debug

### Step 1: Check Codemagic Build Logs

1. Go to Codemagic dashboard
2. Open the failed build
3. Check **"Install CocoaPods dependencies"** step:
   - Did `pod install` complete?
   - Any errors about Firebase pods?
   - Any errors about missing frameworks?

4. Check **"Build IPA"** step:
   - Any compilation errors?
   - Any linking errors?
   - Any plugin registration errors?

### Step 2: Verify GoogleService-Info.plist in Xcode

**CRITICAL:** This is the most likely issue!

1. Open `ios/Runner.xcworkspace` in Xcode
2. Look at Project Navigator (left sidebar)
3. Find `Runner` folder → Look for `GoogleService-Info.plist`
4. If **NOT there** → Follow fix above (Add Files to Runner)

5. If it IS there:
   - Click on it
   - Check File Inspector (right sidebar)
   - **"Target Membership"** section
   - Ensure **"Runner"** is checked ✅

### Step 3: Check TestFlight Crash Reports

1. Go to App Store Connect
2. Your App → TestFlight → Crashes
3. Download crash logs
4. Look for:
   - "GoogleService-Info.plist not found"
   - "Firebase initialization failed"
   - "Missing framework"
   - Plugin registration errors

### Step 4: Verify Firebase Initialization

**In AppDelegate (v1.0.4+10), we added diagnostics:**
- Check if `GoogleService-Info.plist` found
- Check bundle ID match
- Verify Firebase initialized
- Log all errors

**Check these logs:**
- Codemagic build logs (if available)
- Xcode console (if testing locally)
- Device logs (if you can connect device)

---

## ✅ What We've Fixed

### Version 1.0.4+10 Changes:

1. ✅ **Bundle ID fixed** - `com.Helper` matches in all places
2. ✅ **AppDelegate crash protection** - Wrapped plugin registration
3. ✅ **Firebase diagnostics** - Detailed logging for initialization
4. ✅ **Error handling** - Comprehensive try-catch blocks
5. ✅ **Crashlytics logging** - Detailed startup logs

---

## 🚨 Most Critical Action Required

### **VERIFY GOOGLESERVICE-INFO.PLIST IN XCODE PROJECT**

This is the #1 cause of silent crashes with no Crashlytics data:

1. **Open Xcode:** `ios/Runner.xcworkspace`
2. **Check Project Navigator:** Is `GoogleService-Info.plist` visible?
3. **If NOT visible:** Add it following the fix above
4. **If visible:** Verify Target Membership has "Runner" checked
5. **Rebuild:** Build a new version in Codemagic

---

## 📋 Checklist Before Next Build

- [ ] `GoogleService-Info.plist` is in Xcode project (visible in Project Navigator)
- [ ] `GoogleService-Info.plist` has "Runner" checked in Target Membership
- [ ] Bundle ID matches: `com.Helper` everywhere
- [ ] `codemagic.yaml` has `pod install` step
- [ ] Version updated: `1.0.4+10`
- [ ] All changes committed and pushed

---

## 🎯 Next Steps

1. **Verify GoogleService-Info.plist in Xcode** (CRITICAL!)
2. **Build new version** in Codemagic
3. **Install from TestFlight**
4. **Check Firebase Console** in 1-5 minutes
5. **Check App Store Connect** for crash logs

---

**If crashes continue:**
- Check Codemagic build logs for errors
- Check App Store Connect crash reports
- Verify all pods installed correctly
- Check for plugin compatibility issues

