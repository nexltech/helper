# Script to run Flutter app on Chrome
Write-Host "Searching for Flutter..." -ForegroundColor Cyan

# Common Flutter installation paths
$flutterPaths = @(
    "$env:LOCALAPPDATA\flutter\bin\flutter.bat",
    "C:\src\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat",
    "$env:USERPROFILE\flutter\bin\flutter.bat",
    "$env:USERPROFILE\AppData\Local\flutter\bin\flutter.bat",
    "$env:ProgramFiles\flutter\bin\flutter.bat"
)

$flutterFound = $false
$flutterPath = $null

foreach ($path in $flutterPaths) {
    if (Test-Path $path) {
        Write-Host "Found Flutter at: $path" -ForegroundColor Green
        $flutterPath = $path
        $flutterFound = $true
        break
    }
}

# Also check if flutter is in PATH
if (-not $flutterFound) {
    try {
        $flutterVersion = flutter --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Flutter found in PATH" -ForegroundColor Green
            $flutterPath = "flutter"
            $flutterFound = $true
        }
    } catch {
        # Flutter not in PATH
    }
}

if (-not $flutterFound) {
    Write-Host "`nERROR: Flutter not found!" -ForegroundColor Red
    Write-Host "`nPlease either:" -ForegroundColor Yellow
    Write-Host "1. Install Flutter from https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Yellow
    Write-Host "2. Add Flutter to your PATH" -ForegroundColor Yellow
    Write-Host "3. Or run from VS Code/Android Studio" -ForegroundColor Yellow
    Write-Host "`nTo run from VS Code:" -ForegroundColor Cyan
    Write-Host "  - Press F5" -ForegroundColor White
    Write-Host "  - Or: Run > Start Debugging" -ForegroundColor White
    Write-Host "  - Select 'Chrome' as device" -ForegroundColor White
    exit 1
}

Write-Host "`nGetting Flutter dependencies..." -ForegroundColor Cyan
& $flutterPath pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "`nChecking for Chrome..." -ForegroundColor Cyan
& $flutterPath devices

Write-Host "`nStarting app on Chrome..." -ForegroundColor Green
Write-Host "This may take a minute on first run..." -ForegroundColor Yellow
& $flutterPath run -d chrome


