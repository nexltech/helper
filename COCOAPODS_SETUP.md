# CocoaPods Setup Guide

## ✅ Current Status

CocoaPods is installed via Homebrew at `/opt/homebrew/bin/pod` (version 1.16.2)

## 🔧 Issue: Flutter Not Finding CocoaPods

Sometimes Flutter can't find CocoaPods because Homebrew's bin directory isn't in the PATH when Flutter runs.

## 🚀 Solutions

### Option 1: Use the Helper Script (Recommended)

Use the provided script that automatically sets up the PATH:

```bash
cd /Users/zahidali/Downloads/helper
./run_ios.sh
```

Or with a specific device:

```bash
./run_ios.sh 85042808-3469-4DE6-B628-C2ADA2832F2C
```

### Option 2: Export PATH Before Running Flutter

Always export the PATH before running Flutter:

```bash
export PATH="/opt/homebrew/bin:$PATH"
cd /Users/zahidali/Downloads/helper
flutter run
```

### Option 3: Add to Your Shell Profile (Permanent Fix)

Add Homebrew to your PATH permanently by adding this line to `~/.zshrc`:

```bash
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then restart your terminal or run `source ~/.zshrc`

## 🔍 Verify CocoaPods Installation

Check if CocoaPods is installed:

```bash
which pod
pod --version
```

Should show:
```
/opt/homebrew/bin/pod
1.16.2
```

## 📦 Reinstall Pods (If Needed)

If you get CocoaPods errors, reinstall the pods:

```bash
cd /Users/zahidali/Downloads/helper/ios
export PATH="/opt/homebrew/bin:$PATH"
pod install
```

## 🐛 Troubleshooting

### Error: "CocoaPods not installed or not in valid state"

1. Verify CocoaPods is installed:
   ```bash
   which pod
   ```

2. If not found, install it:
   ```bash
   brew install cocoapods
   ```

3. Ensure PATH includes Homebrew:
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   ```

4. Reinstall pods:
   ```bash
   cd ios
   pod install
   ```

5. Run Flutter with PATH set:
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   flutter run
   ```

## 📝 Quick Reference

**CocoaPods Location:** `/opt/homebrew/bin/pod`  
**Pods Directory:** `ios/Pods/`  
**Podfile:** `ios/Podfile`  
**Podfile.lock:** `ios/Podfile.lock`
