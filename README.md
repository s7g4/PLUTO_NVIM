# Pluto Language Support for Neovim 🚀

> A lightweight, expressive syntax for scripting with full syntax highlighting and parsing support in [Neovim](https://neovim.io) using Tree-sitter.

## ✨ Key Features

- 🌈 **Syntax Highlighting** - Rich, contextual coloring for Pluto scripts
- 🧠 **Tree-sitter Integration** - Fast, accurate parsing and syntax analysis
- 📐 **Smart Operator Handling** - Proper precedence and grouping support 
- 🧪 **Comprehensive Testing** - Extensive test coverage for reliability
- ✂️ **Code Organization** - Intelligent code folding via fold.scm
- 🎨 **Clean Styling** - Distinct visual treatment for code elements
- 🔧 **Neovim Integration** - Native tree-sitter support with nvim-treesitter

## 📊 Feature Support

| Feature | Status | Description |
|---------|--------|-------------|
| Assignments | ✅ | Variable and value assignment |
| Commands | ✅ | Shell commands with arguments |
| Expressions | ✅ | Mathematical and logical expressions |
| Operators | ✅ | Binary and unary operations |
| Grouping | ✅ | Parenthetical expression grouping |
| Folding | ✅ | Code section folding support |
| Language Injection | ✅ | JSON/Bash support in strings |
| Control Flow | ✅ | If statements, loops, functions |
| Type Annotations | ✅ | Optional type hints |
| Arrays & Objects | ✅ | Complex data structures |

## 🗂 Project Structure

```
pluto-neovim/
├── README.md                    # This documentation
├── extension.toml               # Extension configuration (legacy)
├── languages/
│   └── pluto/
│       ├── config.toml          # Language definition
│       └── tree-sitter-pluto/   # Tree-sitter grammar
│           ├── grammar.js       # Core grammar rules
│           ├── tree-sitter.json # Grammar metadata
│           ├── queries/         # Tree-sitter queries
│           │   ├── highlights.scm # Syntax highlighting
│           │   ├── injections.scm # Language injections
│           │   └── fold.scm     # Code folding
│           ├── src/            # Generated parser code
│           └── test/           # Test files
│               └── corpus/
│                   └── test.pluto
```

## 🚀 Quick Start

### Prerequisites
- Neovim 0.8+ with Tree-sitter support
- nvim-treesitter plugin
- C compiler for building the parser

### Installation

1. **Clone the Repository**
```bash
git clone https://github.com/s7g4/pluto-neovim.git
cd pluto-neovim
```

2. **Build the Tree-sitter Parser**
```bash
cd languages/pluto/tree-sitter-pluto
tree-sitter generate
make
```

3. **Install in Neovim**
Add to your Neovim configuration:

```lua
-- ~/.config/nvim/init.lua or ~/.config/nvim/lua/config.lua

-- Set up lazy.nvim if not already configured
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- Pluto language configuration
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.pluto = {
  install_info = {
    url = "/path/to/your/pluto-neovim/languages/pluto/tree-sitter-pluto",
    files = {"src/parser.c"},
    branch = "main",
    generate_requires_npm = false,
  },
  filetype = "pluto",
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "pluto" },
  highlight = { enable = true },
  indent = { enable = true },
  fold = { enable = true },
}

-- Set filetype for .pluto files
vim.filetype.add({
  extension = {
    pluto = "pluto"
  }
})
```

4. **Install the Parser**
```bash
nvim --headless -c "TSInstall pluto" -c "qa!"
```

### Verification

Create a test file `test.pluto`:
```pluto
# Variables and assignments
x = 42
name = "Pluto"
active = true

# Commands
print "Hello, Pluto!"
run x name active

# Expressions
result = (x + 10) * 2
condition = x > 30 and active

# Function definition
function greet(name: string) -> string {
    return "Hello, " ++ name
}
```

Open in Neovim:
```bash
nvim test.pluto
```

## 🔧 Development Guide

### Grammar Development

The core grammar is defined in `grammar.js`. Here's the structure:

#### Helper Functions

```javascript
// Separator function for newline-separated statements
function sepByNewline($, rule) {
  return seq(
    rule, 
    repeat(seq($._statement_separator, rule)), 
    optional($._statement_separator)
  );
}

// Operator precedence levels
const PRECEDENCE = {
  command: 1,        // Lowest precedence
  argument: 2,
  expression: 3,
  assignment: 5,
  conditional: 7,
  logical_or: 8,
  logical_and: 9,
  equality: 10,
  comparison: 11,
  bitwise_or: 12,
  bitwise_xor: 13,
  bitwise_and: 14,
  shift: 15,
  add: 16,
  mult: 17,
  power: 18,
  unary: 19,
  postfix: 20,
  primary: 21,       // Highest precedence
};

// Binary operation creator
function createBinaryOp($, operators, precedence) {
  return operators.map(operator =>
    prec.left(PRECEDENCE[precedence], seq(
      field('left', $._expression),
      field('operator', alias(token(operator), $.operator)),
      field('right', $._expression)
    ))
  );
}
```

### Language Features

#### 1. Assignments
```pluto
# Single assignment
x = 42

# Multiple assignment
x y = "hello"

# Type annotations
name: string = "Pluto"
```

#### 2. Commands
```pluto
# Simple command
print "hello"

# Command with arguments
run x y z

# Command with expressions
exec (x + 1) "file.txt" true
```

#### 3. Expressions
```pluto
# Arithmetic
result = (x + y) * 2

# Logical
condition = x > 10 and y < 5

# Comparison
equal = name == "Pluto"

# Bitwise
bits = x & 0xFF
```

#### 4. Data Types
```pluto
# Numbers
integer = 42
float = 3.14
scientific = 1.5e10
hex = 0xFF
binary = 0b1010

# Strings
single = 'hello'
double = "world"

# Booleans
flag = true
disabled = false

# Arrays
numbers = [1, 2, 3]
mixed = [42, "hello", true]

# Objects
person = {
  name: "Alice",
  age: 30,
  active: true
}
```

#### 5. Control Flow
```pluto
# If statements
if x > 10 {
    print "big number"
} else {
    print "small number"
}

# While loops
while x < 100 {
    x = x + 1
}

# For loops
for item in items {
    print item
}

# Functions
function add(a: number, b: number) -> number {
    return a + b
}
```

### Testing the Grammar

```bash
cd languages/pluto/tree-sitter-pluto

# Run all tests
tree-sitter test

# Parse a specific file
tree-sitter parse test1.pluto

# Generate and test
tree-sitter generate
tree-sitter test
```

## 🤝 Contributing

We welcome contributions to improve the Pluto language support!

### Areas for Contribution

1. **Grammar Improvements**
   - Add new language features
   - Fix parsing edge cases
   - Improve error recovery

2. **Syntax Highlighting**
   - Add more semantic highlighting
   - Improve color schemes
   - Add theme-specific adjustments

3. **Testing**
   - Add more test cases
   - Improve test coverage
   - Add performance benchmarks

4. **Documentation**
   - Add examples
   - Improve API documentation
   - Add tutorials

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `tree-sitter test`
5. Submit a pull request

## ⚠️ Troubleshooting

### Parser Installation Issues

**Problem**: `TSInstall pluto` fails
**Solution**: 
```bash
# Manual installation
cd ~/.local/share/nvim/lazy/nvim-treesitter/parser/
cp /path/to/pluto-neovim/languages/pluto/tree-sitter-pluto/pluto.so .

# Copy queries
mkdir -p ~/.local/share/nvim/lazy/nvim-treesitter/queries/pluto/
cp /path/to/pluto-neovim/languages/pluto/tree-sitter-pluto/queries/*.scm ~/.local/share/nvim/lazy/nvim-treesitter/queries/pluto/
```

### No Syntax Highlighting

**Problem**: `.pluto` files don't highlight
**Solution**:
1. Check filetype: `:set filetype?`
2. Should return `filetype=pluto`
3. If not, add to your config:
```lua
vim.filetype.add({
  extension = { pluto = "pluto" }
})
```

### Parser Errors

**Problem**: Parsing fails on valid syntax
**Solution**:
1. Check the parse tree: `:TSPlayground`
2. Report issues with minimal examples
3. Run tree-sitter test to verify

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Tree-sitter](https://tree-sitter.github.io) for the parsing framework
- [Neovim](https://neovim.io) for the excellent editor
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for the integration
- The LibreCube community for inspiration

---

**Happy coding with Pluto! 🚀**
