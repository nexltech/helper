# PowerShell script to create branch and push changes
# Run this script in PowerShell from the project root directory

Write-Host "Creating new branch 'firstbranch'..." -ForegroundColor Green

# Navigate to project directory
cd "C:\Users\Dell\OneDrive\Documents\nexltech\helper"

# Check if git is available
try {
    $gitVersion = git --version
    Write-Host "Git found: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "Or add Git to your system PATH" -ForegroundColor Yellow
    exit 1
}

# Check current status
Write-Host "`nChecking git status..." -ForegroundColor Cyan
git status

# Create and switch to new branch
Write-Host "`nCreating and switching to branch 'firstbranch'..." -ForegroundColor Green
git checkout -b firstbranch

# Add all changes
Write-Host "`nAdding all changes..." -ForegroundColor Green
git add .

# Show what will be committed
Write-Host "`nFiles to be committed:" -ForegroundColor Cyan
git status

# Commit changes
Write-Host "`nCommitting changes..." -ForegroundColor Green
git commit -m "Fix iOS crash issues: main() async initialization, font paths, ATS configuration, Podfile creation, Codemagic build improvements"

# Check if remote exists
Write-Host "`nChecking for remote repository..." -ForegroundColor Cyan
$remoteExists = git remote -v
if ($remoteExists) {
    Write-Host "Remote found:" -ForegroundColor Green
    git remote -v
    
    # Push to new branch
    Write-Host "`nPushing to 'firstbranch' branch..." -ForegroundColor Green
    git push -u origin firstbranch
    
    Write-Host "`n✅ Successfully pushed to 'firstbranch' branch!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  No remote repository found." -ForegroundColor Yellow
    Write-Host "To add a remote, run:" -ForegroundColor Yellow
    Write-Host "  git remote add origin <your-repo-url>" -ForegroundColor Yellow
    Write-Host "Then push with:" -ForegroundColor Yellow
    Write-Host "  git push -u origin firstbranch" -ForegroundColor Yellow
}

Write-Host "`nDone!" -ForegroundColor Green

