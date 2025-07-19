# Pluto Language Support for Zed

A Zed extension that provides syntax highlighting and language support for the Pluto programming language using Tree-sitter.

## Features

- **Syntax Highlighting**: Full syntax highlighting for Pluto language constructs
- **Tree-sitter Integration**: Uses Tree-sitter for accurate parsing and highlighting
- **Language Recognition**: Automatic detection of `.pluto` files
- **Code Folding**: Support for folding comments, expressions, and complex structures
- **Language Injections**: Support for embedded languages (JSON, YAML, SQL, etc.)

## Installation

### Method 1: Local Development Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd zed-pluto
   ```

2. Build the extension:
   ```bash
   cargo build --target wasm32-wasip2 --release
   cp target/wasm32-wasip2/release/zed_pluto.wasm extension.wasm
   ```

3. Install the extension in Zed:
   - Open Zed
   - Go to Extensions (Cmd/Ctrl + Shift + X)
   - Click "Install Dev Extension"
   - Select this directory

### Method 2: Manual Installation

1. Copy the entire extension directory to your Zed extensions folder:
   - **macOS**: `~/Library/Application Support/Zed/extensions/`
   - **Linux**: `~/.config/zed/extensions/`
   - **Windows**: `%APPDATA%\Zed\extensions\`

2. Restart Zed

## Usage

Once installed, the extension will automatically provide syntax highlighting for any file with the `.pluto` extension.

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

# Function calls
process_data (name + " v" + version) result status
```

## Language Features Supported

- **Variables**: Identifier highlighting and assignment operators
- **Data Types**: Strings, numbers, booleans with appropriate highlighting
- **Comments**: Line comments starting with `#`
- **Commands**: Function calls and built-in commands
- **Operators**: Arithmetic, comparison, and logical operators
- **Expressions**: Parenthesized expressions and complex operations
- **Language Injections**: Embedded JSON, YAML, SQL, shell scripts, etc.

## Development

### Building from Source

Requirements:
- Rust toolchain with `wasm32-wasip2` target
- Zed editor

```bash
# Add the WebAssembly target
rustup target add wasm32-wasip2

# Build the extension
cargo build --target wasm32-wasip2 --release

# Copy the built WASM file
cp target/wasm32-wasip2/release/zed_pluto.wasm extension.wasm
```

### Project Structure

```
zed-pluto/
├── extension.toml          # Extension configuration
├── Cargo.toml             # Rust project configuration
├── src/lib.rs             # Extension implementation
├── languages/pluto/       # Language-specific files
│   ├── config.toml        # Language configuration
│   ├── queries/           # Tree-sitter queries
│   │   ├── highlights.scm # Syntax highlighting rules
│   │   ├── fold.scm       # Code folding rules
│   │   └── injections.scm # Language injection rules
│   └── tree-sitter-pluto/ # Tree-sitter grammar
└── test.pluto             # Example Pluto file
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the provided `test.pluto` file
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Troubleshooting

### Extension Not Loading
- Ensure the `extension.wasm` file exists in the root directory
- Check that Zed has been restarted after installation
- Verify the extension appears in Zed's Extensions panel

### Syntax Highlighting Not Working
- Confirm the file has a `.pluto` extension
- Check that the Tree-sitter queries are properly formatted
- Look for errors in Zed's developer console

### Building Issues
- Ensure you have the `wasm32-wasip2` Rust target installed
- Check that all dependencies in `Cargo.toml` are available
- Verify you're using a compatible Rust version