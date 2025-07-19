# Pluto Language Extension for Zed - Installation Guide

## Quick Start

1. **Build the extension** (if not already built):
   ```bash
   ./build.sh
   ```

2. **Install the extension**:
   ```bash
   ./install.sh
   ```

3. **Restart Zed** and open a `.pluto` file to test syntax highlighting.

## What's Included

✅ **Complete Zed Extension** with:
- Tree-sitter grammar for Pluto language parsing
- Syntax highlighting with comprehensive rules
- Code folding support
- Language injections for embedded content
- Proper file association for `.pluto` files
- Line comment support (`#`)

✅ **Development Tools**:
- `build.sh` - Build the extension from source
- `install.sh` - Install extension to Zed
- `verify.sh` - Verify all files are present
- `test.pluto` - Example file for testing

## Extension Structure

```
zed-pluto/
├── extension.toml              # Extension metadata
├── extension.wasm              # Compiled extension
├── languages/pluto/
│   ├── config.toml            # Language configuration
│   └── queries/               # Tree-sitter queries
│       ├── highlights.scm     # Syntax highlighting
│       ├── fold.scm          # Code folding
│       └── injections.scm    # Language injections
├── test.pluto                 # Test file
└── README.md                  # Documentation
```

## Supported Features

### Syntax Highlighting
- **Keywords and operators**: `=`, arithmetic operators
- **Data types**: strings, numbers, booleans
- **Comments**: Line comments with `#`
- **Variables**: Identifier highlighting
- **Functions**: Command calls and built-in functions
- **Expressions**: Parenthesized expressions, binary operations

### Language Features
- **File association**: Automatic detection of `.pluto` files
- **Comment toggling**: Ctrl+/ for line comments
- **Code folding**: Collapsible code blocks
- **Language injections**: Embedded JSON, YAML, SQL, shell scripts

### Example Pluto Code
```pluto
# Variable assignments
name = "Pluto"
version = 1.0
is_active = true

# Commands with arguments
print "Hello, World!"
echo name version

# Arithmetic operations
result = 10 + 20 * 3
power = 2 ** 8

# Conditional expressions
status = is_active ? "running" : "stopped"
```

## Troubleshooting

### Extension not loading
- Ensure `extension.wasm` exists and is not empty
- Check that Zed has been restarted after installation
- Verify the extension appears in Zed's Extensions panel

### "no such grammar pluto" Error
This error occurs because the Pluto tree-sitter grammar repository is not publicly available. The current workaround uses the JavaScript grammar as a fallback. To fix this properly:

1. **Temporary Solution**: The extension currently uses JavaScript grammar for basic functionality
2. **Proper Solution**: Publish the tree-sitter-pluto grammar to a public repository
3. **Alternative**: Use a local grammar setup (advanced users)

### No syntax highlighting
- Confirm the file has a `.pluto` extension
- Check Zed's language selector (bottom right of editor)
- Look for errors in Zed's developer console
- Note: Syntax highlighting may be limited due to grammar fallback

### Build issues
- Ensure Rust toolchain is installed with `wasm32-wasip2` target
- Run `rustup target add wasm32-wasip2` if needed
- Check that all dependencies are available

## Manual Installation

If the install script doesn't work, manually copy the extension:

1. **Find your Zed extensions directory**:
   - **macOS**: `~/Library/Application Support/Zed/extensions/`
   - **Linux**: `~/.config/zed/extensions/`
   - **Windows**: `%APPDATA%\Zed\extensions\`

2. **Copy the extension**:
   ```bash
   cp -r /path/to/zed-pluto ~/.config/zed/extensions/pluto
   ```

3. **Restart Zed**

## Development

To modify the extension:

1. Edit the Tree-sitter queries in `languages/pluto/queries/`
2. Modify the Rust extension code in `src/lib.rs`
3. Update language configuration in `languages/pluto/config.toml`
4. Rebuild with `./build.sh`
5. Reinstall with `./install.sh`

The extension is now ready for use in Zed! 🎉