#!/bin/bash

# Build script for Pluto Language Extension
set -e

echo "🔨 Building Pluto Language Extension for Zed..."

# Check if wasm32-wasip2 target is installed
if ! rustup target list --installed | grep -q "wasm32-wasip2"; then
    echo "📦 Installing wasm32-wasip2 target..."
    rustup target add wasm32-wasip2
fi

# Build the extension
echo "🏗️  Building Rust extension..."
cargo build --target wasm32-wasip2 --release

# Copy the built WASM file
echo "📋 Copying WASM file..."
cp target/wasm32-wasip2/release/zed_pluto.wasm extension.wasm

# Verify the file exists and has content
if [ -f "extension.wasm" ] && [ -s "extension.wasm" ]; then
    SIZE=$(wc -c < extension.wasm)
    echo "✅ Extension built successfully! (Size: $SIZE bytes)"
else
    echo "❌ Build failed - extension.wasm not found or empty"
    exit 1
fi

echo ""
echo "🎯 Build complete! You can now:"
echo "1. Run './install.sh' to install the extension"
echo "2. Or manually copy the extension directory to Zed's extensions folder"
echo ""
echo "📁 Required files:"
echo "   ✓ extension.toml"
echo "   ✓ extension.wasm"
echo "   ✓ languages/pluto/queries/*.scm"