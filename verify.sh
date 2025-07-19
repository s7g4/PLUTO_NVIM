#!/bin/bash

# Verification script for Pluto Language Extension
echo "🔍 Verifying Pluto Language Extension for Zed..."
echo ""

# Check required files
REQUIRED_FILES=(
    "extension.toml"
    "extension.wasm"
    "languages/pluto/config.toml"
    "languages/pluto/queries/highlights.scm"
    "languages/pluto/queries/fold.scm"
    "languages/pluto/queries/injections.scm"
)

ALL_GOOD=true

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
        ALL_GOOD=false
    fi
done

echo ""

# Check WASM file size
if [ -f "extension.wasm" ]; then
    SIZE=$(wc -c < extension.wasm)
    if [ "$SIZE" -gt 1000 ]; then
        echo "✅ extension.wasm has valid size ($SIZE bytes)"
    else
        echo "⚠️  extension.wasm seems too small ($SIZE bytes)"
        ALL_GOOD=false
    fi
fi

# Check if test file exists
if [ -f "test.pluto" ]; then
    echo "✅ test.pluto file available for testing"
else
    echo "⚠️  test.pluto file not found (optional)"
fi

echo ""

if [ "$ALL_GOOD" = true ]; then
    echo "🎉 All checks passed! Extension is ready for installation."
    echo ""
    echo "📋 Next steps:"
    echo "1. Run './install.sh' to install the extension"
    echo "2. Restart Zed editor"
    echo "3. Open test.pluto to verify syntax highlighting"
    echo ""
    echo "🔧 Manual installation:"
    echo "   Copy this entire directory to your Zed extensions folder:"
    echo "   - macOS: ~/Library/Application Support/Zed/extensions/pluto"
    echo "   - Linux: ~/.config/zed/extensions/pluto"
    echo "   - Windows: %APPDATA%/Zed/extensions/pluto"
else
    echo "❌ Some issues found. Please run './build.sh' first."
fi