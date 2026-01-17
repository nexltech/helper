#!/bin/bash
# Helper script to run Flutter iOS app with CocoaPods in PATH

# Add Homebrew to PATH if not already there
export PATH="/opt/homebrew/bin:$PATH"

# Verify CocoaPods is available
if ! command -v pod &> /dev/null; then
    echo "Error: CocoaPods not found. Please install it with: brew install cocoapods"
    exit 1
fi

# Change to project directory
cd "$(dirname "$0")"

# Run Flutter with device ID if provided, otherwise use default
if [ -n "$1" ]; then
    flutter run -d "$1"
else
    flutter run
fi
