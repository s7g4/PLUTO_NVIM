# Pluto Language Support for Neovim - Complete Setup Guide

This guide will walk you through setting up Pluto language support in Neovim from scratch.

## Prerequisites

- Neovim 0.8+ (recommended: 0.9+)
- C compiler (gcc, clang, or MSVC)
- Git
- Node.js (optional, for tree-sitter CLI)

## Step 1: Install Tree-sitter CLI

```bash
npm install -g tree-sitter-cli
tree-sitter --version
```

## Step 2: Clone and Build the Grammar

```bash
git clone https://github.com/s7g4/pluto-neovim.git
cd pluto-neovim/languages/pluto/tree-sitter-pluto
tree-sitter generate
make
tree-sitter test
```

## Step 3: Set Up Neovim Configuration

### Using Lazy.nvim (Recommended)

Add to your ~/.config/nvim/init.lua:

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      
      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "pluto" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        fold = { enable = true },
      })
      
      -- Pluto parser configuration
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.pluto = {
        install_info = {
          url = vim.fn.expand("~/pluto-neovim/languages/pluto/tree-sitter-pluto"),
          files = {"src/parser.c"},
          branch = "main",
          generate_requires_npm = false,
        },
        filetype = "pluto",
      }
    end,
  },
})

-- File type detection
vim.filetype.add({
  extension = {
    pluto = "pluto",
  },
})

-- Basic editor settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
```

## Step 4: Install the Parser

```bash
# Method 1: Using Neovim command
nvim --headless -c "TSInstall pluto" -c "qa!"

# Method 2: Manual installation
cd ~/pluto-neovim/languages/pluto/tree-sitter-pluto
make
mkdir -p ~/.local/share/nvim/lazy/nvim-treesitter/parser/
cp libtree-sitter-pluto.so ~/.local/share/nvim/lazy/nvim-treesitter/parser/pluto.so
mkdir -p ~/.local/share/nvim/lazy/nvim-treesitter/queries/pluto/
cp queries/*.scm ~/.local/share/nvim/lazy/nvim-treesitter/queries/pluto/
```

## Step 5: Test the Installation

Create a test file and open it in Neovim to verify syntax highlighting works.

## Verification

In Neovim, verify:

1. `:set filetype?` should return `filetype=pluto`
2. `:TSInstall pluto` should show it's installed
3. The code should be colorized appropriately
4. `:TSBufEnable highlight` should work

## Troubleshooting

### Parser Not Found

```bash
# Check parser location
ls ~/.local/share/nvim/lazy/nvim-treesitter/parser/pluto.so

# If missing, rebuild and copy
cd ~/pluto-neovim/languages/pluto/tree-sitter-pluto
make
cp libtree-sitter-pluto.so ~/.local/share/nvim/lazy/nvim-treesitter/parser/pluto.so
```

### No Syntax Highlighting

```lua
-- Check in Neovim
:TSBufEnable highlight
:set filetype=pluto
```

---

**Congratulations! You now have full Pluto language support in Neovim!**

Your Pluto files should now have:
- ✅ Syntax highlighting
- ✅ Code folding
- ✅ Smart indentation
- ✅ Tree-sitter integration

Happy coding with Pluto in Neovim! 🚀
