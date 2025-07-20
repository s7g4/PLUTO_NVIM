# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 1. **Syntax Highlighting Not Working**

**Symptoms**: `.pluto` files open but have no syntax highlighting

**Solutions**:
- ✅ Ensure the file has `.pluto` or `.pl` extension
- ✅ Check that the extension is properly installed in Zed
- ✅ Restart Zed after installing the extension
- ✅ Verify `extension.wasm` exists and is ~228KB in size
- ✅ Run `./verify.sh` to check all components

### 2. **Extension Not Loading**

**Symptoms**: Extension doesn't appear in Zed's Extensions panel

**Solutions**:
- ✅ Make sure you selected the correct directory (`/home/shaurya/Desktop/zed-pluto`)
- ✅ Check that `extension.toml` exists in the root directory
- ✅ Verify the extension ID is unique (not conflicting with other extensions)
- ✅ Rebuild the extension: `./build.sh`

### 3. **File Type Not Recognized**

**Symptoms**: Zed doesn't recognize `.pluto` files as Pluto language

**Solutions**:
- ✅ Check `extension.toml` has the `[languages.pluto]` section
- ✅ Verify `path_suffixes = ["pluto", "pl"]` is present
- ✅ Restart Zed after making changes
- ✅ Try opening a file with explicit `.pluto` extension

### 4. **Build Errors**

**Symptoms**: `./build.sh` fails with errors

**Solutions**:
- ✅ Install Rust: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- ✅ Add WASM target: `rustup target add wasm32-wasip2`
- ✅ Install tree-sitter CLI: `npm install -g tree-sitter-cli`
- ✅ Check that all dependencies are available

### 5. **Tree-sitter Warnings**

**Symptoms**: Warnings about `tree-sitter.json` when running commands

**Solutions**:
- ✅ These warnings are harmless and don't affect functionality
- ✅ The extension will work correctly in Zed despite these warnings
- ✅ Focus on whether the actual parsing and highlighting work

## 🧪 Testing Steps

1. **Verify Extension Structure**:
   ```bash
   ./verify.sh
   ```

2. **Test Parser Manually**:
   ```bash
   cd languages/pluto/tree-sitter-pluto
   tree-sitter parse ../../../test.pluto
   ```

3. **Test Highlighting Queries**:
   ```bash
   cd languages/pluto/tree-sitter-pluto
   tree-sitter query queries/highlights.scm test.pluto
   ```

4. **Rebuild Everything**:
   ```bash
   ./build.sh
   ```

## 📋 Checklist for Working Extension

- [ ] `extension.toml` exists with `[languages.pluto]` and `[grammars.pluto]` sections
- [ ] `extension.wasm` exists and is ~228KB
- [ ] `languages/pluto/config.toml` exists
- [ ] `languages/pluto/queries/highlights.scm` exists and is valid
- [ ] Tree-sitter parser builds without errors
- [ ] Highlighting queries compile successfully
- [ ] Test file `test.pluto` parses correctly

## 🆘 Getting Help

If you're still having issues:

1. **Check Zed's Developer Console** for error messages
2. **Run `./verify.sh`** to identify specific problems
3. **Compare with working extensions** in Zed's extension directory
4. **Check Zed's documentation** at https://zed.dev/docs/extensions

## 📝 Logs and Debugging

- **Zed Logs**: Check Zed's developer console for extension loading errors
- **Tree-sitter Logs**: Run tree-sitter commands manually to see detailed errors
- **Build Logs**: Check output of `./build.sh` for compilation issues

Remember: The extension has been verified to work correctly. Most issues are related to installation or file paths rather than the extension code itself.