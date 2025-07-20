#!/bin/bash

# Build script for Zed Pluto Extension
set -e

echo "🚀 Building Zed Pluto Extension..."

# Check if Rust is installed
if ! command -v cargo &> /dev/null; then
    echo "❌ Error: Rust/Cargo not found. Please install Rust first."
    echo "Visit: https://rustup.rs/"
    exit 1
fi

# Check if wasm32-wasip2 target is installed
if ! rustup target list --installed | grep -q "wasm32-wasip2"; then
    echo "📦 Installing wasm32-wasip2 target..."
    rustup target add wasm32-wasip2
fi

# Build the Tree-sitter grammar
echo "🌳 Building Tree-sitter grammar..."
cd languages/pluto/tree-sitter-pluto

if command -v tree-sitter &> /dev/null; then
    # Clean up any existing WASM files that might cause issues
    rm -f *.wasm
    tree-sitter generate
    tree-sitter build
else
    echo "⚠️  Warning: tree-sitter CLI not found. Skipping grammar build."
    echo "Install with: npm install -g tree-sitter-cli"
fi

cd ../../..

# Build the Rust extension
echo "🦀 Building Rust extension..."
cargo build --target wasm32-wasip2 --release

# Copy the WASM file to the correct location
echo "📋 Copying WASM file..."
cp target/wasm32-wasip2/release/zed_pluto.wasm extension.wasm

echo "✅ Build complete!"
echo ""
echo "📁 Extension files:"
echo "   - extension.wasm (main extension)"
echo "   - extension.toml (configuration)"
echo "   - languages/pluto/ (language support)"
echo ""
echo "🎯 To install in Zed:"
echo "   1. Open Zed"
echo "   2. Go to Extensions (Cmd/Ctrl + Shift + X)"
echo "   3. Click 'Install Dev Extension'"
echo "   4. Select this directory"
echo ""
echo "🧪 Test with: test.pluto"