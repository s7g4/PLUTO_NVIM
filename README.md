# Pluto Language Support for Zed

A Zed extension that provides syntax highlighting and language support for the Pluto programming language using Tree-sitter.

## Features

- **Syntax Highlighting**: Full syntax highlighting for Pluto language constructs
- **Tree-sitter Integration**: Uses Tree-sitter for accurate parsing and highlighting
- **Language Recognition**: Automatic detection of `.pluto` and `.pl` files
- **Code Folding**: Support for folding comments, expressions, and complex structures
- **Language Injections**: Support for embedded languages (JSON, YAML, SQL, etc.)

## Installation

### Development Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/s7g4/zed-pluto.git
   cd zed-pluto
   ```

2. Build the extension:
   ```bash
   cargo build --release --target wasm32-wasi
   ```

3. Install in Zed:
   - Open Zed
   - Go to Extensions (Cmd/Ctrl + Shift + X)
   - Click "Install Dev Extension"
   - Select this directory

## Usage

Once installed, the extension will automatically provide syntax highlighting for files with `.pluto` or `.pl` extensions.

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

/* Block comments
   are also supported */
```

## Language Features Supported

- **Variables**: Identifier highlighting and assignment operators
- **Data Types**: Strings, numbers, booleans with appropriate highlighting
- **Comments**: Line comments (`#`) and block comments (`/* */`)
- **Commands**: Function calls and built-in commands
- **Operators**: Arithmetic, comparison, and logical operators
- **Expressions**: Parenthesized expressions and complex operations
- **Language Injections**: Embedded JSON, YAML, SQL, shell scripts, etc.

## Development

### Requirements

- Rust toolchain with `wasm32-wasi` target
- Tree-sitter CLI (optional, for grammar development)
- Zed editor


### Project Structure

```
zed-pluto/
├── extension.toml              # Extension configuration
├── Cargo.toml                 # Rust project configuration
├── src/lib.rs                 # Extension implementation
├── languages/pluto/           # Language-specific files
│   ├── config.toml            # Language configuration
│   ├── queries/               # Tree-sitter queries
│   │   ├── highlights.scm     # Syntax highlighting rules
│   │   ├── fold.scm           # Code folding rules
│   │   └── injections.scm     # Language injection rules
│   └── tree-sitter-pluto/     # Tree-sitter grammar
└── test.pluto                 # Example Pluto file
```

## Notes

- Pluto language support currently does **not** include a language server.
- Syntax highlighting and language features are provided solely through Tree-sitter grammar integration.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with the provided example files
5. Submit a pull request

## License

MIT License

## Troubleshooting

### Extension Not Loading
- Ensure the build completed successfully
- Check that Zed has been restarted after installation
- Verify the extension appears in Zed's Extensions panel

### Syntax Highlighting Not Working
- Confirm the file has a `.pluto` or `.pl` extension
- Check Zed's developer console for errors
- Try reinstalling the extension

### Build Issues
- Ensure you have the `wasm32-wasi` Rust target installed
- Check that Tree-sitter CLI is installed if modifying grammar
- Verify you're using a compatible Rust version

For more help, please open an issue on GitHub.
