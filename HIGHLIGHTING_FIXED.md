# ✅ Syntax Highlighting Fixed!

## 🔧 Issues Found and Resolved

### 1. **Missing Language Configuration in extension.toml**
**Problem**: The `extension.toml` was missing the `[languages.pluto]` section that tells Zed how to handle `.pluto` files.

**Solution**: Added the language configuration:
```toml
[languages.pluto]
name = "Pluto"
grammar = "pluto"
path_suffixes = ["pluto", "pl"]
line_comments = ["# "]
block_comment = ["/*", "*/"]
```

### 2. **Invalid Tree-sitter Query Nodes**
**Problem**: The `highlights.scm` file referenced node types that don't exist in our grammar:
- `return` keyword (not in our grammar)
- `"true"`, `"false"` as separate tokens (they're part of `boolean` token)
- `";"` semicolon (not defined in our grammar)
- Field references that don't exist

**Solution**: Rewrote `highlights.scm` to only use valid node types from our grammar:
- Used `(boolean) @constant.builtin` instead of separate `"true"` and `"false"`
- Removed semicolon from punctuation list
- Simplified field references
- Removed non-existent keywords

### 3. **Grammar Path Configuration**
**Problem**: The grammar path needed to be properly specified for Zed to find the Tree-sitter parser.

**Solution**: Added `path = "languages/pluto/tree-sitter-pluto"` to the grammar configuration.

## 🎯 Current Working Highlights

The extension now properly highlights:

✅ **Comments**: `# This is a comment`
✅ **Keywords**: `if`, `else`, `while`, `for`, `function`, `in`
✅ **Operators**: `=`, `+`, `-`, `*`, `/`, `==`, `!=`, `&&`, `||`, etc.
✅ **Literals**: 
  - Strings: `"Hello World"`
  - Numbers: `123`, `1.5`, `0xFF`
  - Booleans: `true`, `false`
✅ **Variables**: `name`, `version`, `is_active`
✅ **Function Calls**: `print`, `echo`, `run`
✅ **Punctuation**: `()`, `[]`, `{}`, `,`, `:`, `?`

## 🧪 Test Results

Running `tree-sitter query` on the test file now shows proper highlighting:
- Comments are highlighted as `@comment`
- Variables are highlighted as `@variable`
- Operators are highlighted as `@operator`
- Strings are highlighted as `@string`
- Numbers are highlighted as `@number`
- Function calls are highlighted as `@function.call`

## 🚀 Ready for Zed!

The extension is now ready to be installed in Zed with working syntax highlighting:

1. **Open Zed**
2. **Press `Cmd/Ctrl + Shift + X`** to open Extensions
3. **Click "Install Dev Extension"**
4. **Select `/home/shaurya/Desktop/zed-pluto`**
5. **Open any `.pluto` file** and enjoy syntax highlighting!

## 📁 Files Updated

- `extension.toml` - Added language configuration
- `languages/pluto/queries/highlights.scm` - Fixed invalid node references
- `languages/pluto/tree-sitter-pluto/queries/highlights.scm` - Updated with working queries
- `languages/pluto/queries/fold.scm` - Simplified folding rules
- `extension.wasm` - Rebuilt with latest changes

The syntax highlighting should now work perfectly in Zed! 🎉