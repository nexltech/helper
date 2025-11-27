# App Icon File Locations

## ✅ IMPORTANT: You Don't Need to Manually Place Icons!

The `flutter_launcher_icons` package will **automatically generate and place** all icons in the correct locations when you run:

```bash
flutter pub run flutter_launcher_icons
```

You only need to:
1. Place your `icon.png` (1024x1024) in `assets/icon/icon.png`
2. Run the command above
3. Done! All icons will be generated and placed automatically.

---

## 📱 iOS Icon Locations

After running `flutter_launcher_icons`, icons will be placed here:

**Main Location:**
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
```

**Files that will be created/updated:**
- `Icon-App-1024x1024@1x.png` (1024x1024) - **App Store icon (required)**
- `Icon-App-180x180@3x.png` (180x180) - iPhone 60pt @3x
- `Icon-App-120x120@2x.png` (120x120) - iPhone 60pt @2x
- `Icon-App-167x167@2x.png` (167x167) - iPad Pro 83.5pt @2x
- `Icon-App-152x152@2x.png` (152x152) - iPad 76pt @2x
- `Icon-App-120x120@2x.png` (120x120) - iPad 76pt @2x
- `Icon-App-87x87@3x.png` (87x87) - iPad 29pt @3x
- `Icon-App-80x80@2x.png` (80x80) - iPad 40pt @2x
- `Icon-App-76x76@1x.png` (76x76) - iPad 76pt @1x
- `Icon-App-60x60@3x.png` (60x60) - iPhone 60pt @3x
- `Icon-App-60x60@2x.png` (60x60) - iPhone 60pt @2x
- `Icon-App-58x58@2x.png` (58x58) - iPad 29pt @2x
- `Icon-App-40x40@3x.png` (40x40) - iPhone 40pt @3x
- `Icon-App-40x40@2x.png` (40x40) - iPad 40pt @2x
- `Icon-App-40x40@1x.png` (40x40) - iPad 40pt @1x
- `Icon-App-29x29@3x.png` (29x29) - iPhone 29pt @3x
- `Icon-App-29x29@2x.png` (29x29) - iPad 29pt @2x
- `Icon-App-29x29@1x.png` (29x29) - iPad 29pt @1x
- `Icon-App-20x20@3x.png` (20x20) - iPhone 20pt @3x
- `Icon-App-20x20@2x.png` (20x20) - iPhone 20pt @2x
- `Icon-App-20x20@2x.png` (20x20) - iPad 20pt @2x
- `Icon-App-20x20@1x.png` (20x20) - iPad 20pt @1x

**Total:** ~20+ icon files (all auto-generated)

---

## 🤖 Android Icon Locations

After running `flutter_launcher_icons`, icons will be placed here:

**Main Locations:**
```
android/app/src/main/res/
```

**Folders and files that will be created/updated:**

1. **mipmap-mdpi/**
   - `ic_launcher.png` (48x48 dp = 48x48 pixels)

2. **mipmap-hdpi/**
   - `ic_launcher.png` (48x48 dp = 72x72 pixels)

3. **mipmap-xhdpi/**
   - `ic_launcher.png` (48x48 dp = 96x96 pixels)

4. **mipmap-xxhdpi/**
   - `ic_launcher.png` (48x48 dp = 144x144 pixels)

5. **mipmap-xxxhdpi/**
   - `ic_launcher.png` (48x48 dp = 192x192 pixels)

**Total:** 5 icon files (all auto-generated)

---

## 🎯 What You Actually Need to Do

### Step 1: Place Your Source Icon
**Location:** `assets/icon/icon.png`
- Size: 1024x1024 pixels
- Format: PNG
- This is the ONLY file you need to create/place manually

### Step 2: Run the Command
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Step 3: Verify (Optional)
After running, you can check:
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/` - should have all new icons
- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png` - should be updated

---

## 📋 Quick Reference

| Platform | Location | Files | Auto-Generated? |
|----------|----------|-------|----------------|
| **Source** | `assets/icon/icon.png` | 1 file | ❌ You create this |
| **iOS** | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | ~20 files | ✅ Yes |
| **Android** | `android/app/src/main/res/mipmap-*/` | 5 files | ✅ Yes |

---

## 🔍 How to Verify Icons Were Generated

### Check iOS:
```bash
# Windows PowerShell
Get-ChildItem ios\Runner\Assets.xcassets\AppIcon.appiconset\*.png | Select-Object Name
```

### Check Android:
```bash
# Windows PowerShell
Get-ChildItem android\app\src\main\res\mipmap-*\ic_launcher.png
```

---

## ⚠️ Important Notes

1. **Don't manually copy icons** - The package does this automatically
2. **Only create `assets/icon/icon.png`** - That's your source file
3. **Run the command** - `flutter pub run flutter_launcher_icons`
4. **Icons are auto-placed** - No manual file copying needed

---

## 🚀 Complete Workflow

```bash
# 1. Make sure your icon.png is in assets/icon/
# 2. Install dependencies
flutter pub get

# 3. Generate all icons (this places them automatically)
flutter pub run flutter_launcher_icons

# 4. Build and test
flutter run
```

---

**Summary:** You only need to place ONE file (`assets/icon/icon.png`), then run the command. All other icons will be automatically generated and placed in the correct locations! 🎉



