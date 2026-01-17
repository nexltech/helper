# Quick Run Guide

## 🚀 Running the App

### Option 1: Use the Helper Script (Easiest)
```bash
cd /Users/zahidali/Downloads/helper
./run_ios.sh
```

Or with a specific device:
```bash
./run_ios.sh 85042808-3469-4DE6-B628-C2ADA2832F2C
```

### Option 2: Export PATH Before Running
```bash
export PATH="/opt/homebrew/bin:$PATH"
cd /Users/zahidali/Downloads/helper
flutter run
```

### Option 3: After Restarting Terminal (Permanent Fix)
I've added Homebrew to your `~/.zshrc` file, so after restarting your terminal, you can simply run:
```bash
cd /Users/zahidali/Downloads/helper
flutter run
```

## 📱 Available Devices

To see available devices:
```bash
flutter devices
```

## 🔧 Troubleshooting

### If CocoaPods Error Appears:
1. Make sure PATH includes Homebrew:
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   ```

2. Verify CocoaPods is installed:
   ```bash
   which pod
   pod --version
   ```

3. Reinstall pods if needed:
   ```bash
   cd ios
   pod install
   cd ..
   ```

## 📝 Notes

- The helper script (`run_ios.sh`) automatically sets up the PATH
- After restarting terminal, the PATH will be set automatically
- CocoaPods is installed at `/opt/homebrew/bin/pod`
