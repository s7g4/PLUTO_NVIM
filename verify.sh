#!/bin/bash

# Verification script for Zed Pluto Extension
set -e

echo "🔍 Verifying Zed Pluto Extension..."

# Check essential files exist
echo "📁 Checking essential files..."
files=(
    "extension.toml"
    "extension.wasm"
    "languages/pluto/config.toml"
    "languages/pluto/queries/highlights.scm"
    "languages/pluto/tree-sitter-pluto/grammar.js"
    "test.pluto"
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
        exit 1
    fi
done

# Check WASM file size (should be reasonable)
wasm_size=$(stat -c%s "extension.wasm" 2>/dev/null || stat -f%z "extension.wasm" 2>/dev/null || echo "0")
if [[ $wasm_size -gt 100000 ]]; then
    echo "  ✅ extension.wasm ($wasm_size bytes)"
else
    echo "  ❌ extension.wasm too small ($wasm_size bytes)"
    exit 1
fi

# Test Tree-sitter parser
echo "🌳 Testing Tree-sitter parser..."
cd languages/pluto/tree-sitter-pluto
if tree-sitter parse ../../../test.pluto >/dev/null 2>&1; then
    echo "  ✅ Parser works correctly"
else
    echo "  ❌ Parser failed"
    exit 1
fi

# Test syntax highlighting queries
echo "🎨 Testing syntax highlighting..."
if tree-sitter query queries/highlights.scm test.pluto >/dev/null 2>&1; then
    echo "  ✅ Highlighting queries work"
else
    echo "  ❌ Highlighting queries failed"
    exit 1
fi

cd ../../..

# Check extension configuration
echo "⚙️  Checking extension configuration..."
if grep -q '\[languages\.pluto\]' extension.toml; then
    echo "  ✅ Language configuration present"
else
    echo "  ❌ Language configuration missing"
    exit 1
fi

if grep -q '\[grammars\.pluto\]' extension.toml; then
    echo "  ✅ Grammar configuration present"
else
    echo "  ❌ Grammar configuration missing"
    exit 1
fi

echo ""
echo "🎉 All checks passed! Extension is ready for Zed."
echo ""
echo "📋 Installation Instructions:"
echo "  1. Open Zed"
echo "  2. Press Cmd/Ctrl + Shift + X"
echo "  3. Click 'Install Dev Extension'"
echo "  4. Select this directory: $(pwd)"
echo "  5. Open a .pluto file to test highlighting"
echo ""
echo "🧪 Test file: test.pluto"
echo "📚 Documentation: README.md"