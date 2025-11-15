# Git Commands to Create Branch and Push

Since Git might not be in your PATH, here are the commands to run manually:

## Option 1: Run the PowerShell Script

1. Open PowerShell
2. Navigate to your project:
   ```powershell
   cd "C:\Users\Dell\OneDrive\Documents\nexltech\helper"
   ```
3. Run the script:
   ```powershell
   .\create_branch_and_push.ps1
   ```

## Option 2: Run Commands Manually

Open PowerShell or Git Bash and run these commands:

```bash
# Navigate to project directory
cd "C:\Users\Dell\OneDrive\Documents\nexltech\helper"

# Check current status
git status

# Create and switch to new branch
git checkout -b firstbranch

# Add all changes
git add .

# Commit changes
git commit -m "Fix iOS crash issues: main() async initialization, font paths, ATS configuration, Podfile creation, Codemagic build improvements"

# Push to new branch (replace 'origin' with your remote name if different)
git push -u origin firstbranch
```

## Option 3: Using Git GUI

If you have GitHub Desktop or another Git GUI:

1. Open your Git GUI application
2. Create a new branch called "firstbranch"
3. Stage all changes
4. Commit with message: "Fix iOS crash issues: main() async initialization, font paths, ATS configuration, Podfile creation, Codemagic build improvements"
5. Push the branch to remote

## Files Changed (Should be committed):

- ✅ `lib/main.dart` - Fixed async initialization
- ✅ `pubspec.yaml` - Fixed font paths
- ✅ `ios/Runner/Info.plist` - Added ATS and permissions
- ✅ `ios/Podfile` - New file created
- ✅ `codemagic.yaml` - Improved build scripts
- ✅ `IOS_CRASH_ISSUES.md` - Documentation
- ✅ `ADDITIONAL_IOS_CRASH_ISSUES.md` - Documentation
- ✅ `FIXES_APPLIED.md` - Documentation

## Verify After Pushing:

1. Go to your GitHub repository
2. Check that branch "firstbranch" exists
3. Verify all files are committed
4. In Codemagic, you can now select "firstbranch" for builds

---

**Note:** If Git is not installed, download from: https://git-scm.com/download/win

