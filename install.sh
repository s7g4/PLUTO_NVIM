#!/bin/bash

# Pluto Language Extension Installer for Zed
set -e

echo "🚀 Installing Pluto Language Extension for Zed..."

# Detect OS and set extension directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    EXTENSIONS_DIR="$HOME/Library/Application Support/Zed/extensions"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    EXTENSIONS_DIR="$HOME/.config/zed/extensions"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    EXTENSIONS_DIR="$APPDATA/Zed/extensions"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    exit 1
fi

# Create extensions directory if it doesn't exist
mkdir -p "$EXTENSIONS_DIR"

# Extension directory name
EXTENSION_NAME="pluto"
TARGET_DIR="$EXTENSIONS_DIR/$EXTENSION_NAME"

echo "📁 Extension directory: $TARGET_DIR"

# Remove existing installation if it exists
if [ -d "$TARGET_DIR" ]; then
    echo "🗑️  Removing existing installation..."
    rm -rf "$TARGET_DIR"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy extension files
echo "📋 Copying extension files..."
cp extension.toml "$TARGET_DIR/"
cp extension.wasm "$TARGET_DIR/"
cp -r languages "$TARGET_DIR/"

# Copy additional files
if [ -f "README.md" ]; then
    cp README.md "$TARGET_DIR/"
fi

echo "✅ Pluto Language Extension installed successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Restart Zed editor"
echo "2. Open a .pluto file to test syntax highlighting"
echo "3. Check Extensions panel (Cmd/Ctrl + Shift + X) to verify installation"
echo ""
echo "🧪 Test with the provided test.pluto file:"
echo "   zed test.pluto"
echo ""
echo "🎉 Happy coding with Pluto!"