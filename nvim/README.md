# Prerequisites

- A nerd font

# Setup

# Directory Structure

I adapted the directory structure from this blog post: https://m4xshen.dev/posts/build-your-modern-neovim-config-in-lua

```md
~/.config/nvim
├── init.lua ------------- config file read by neovim 
├── lua ------------------ to prevent overcrowding init.lua use modules
|   ├── config
|   |   ├── options.lua -- customize behaviour of nvim
|   |   ├── mappings.lua - custom keybinds
|   |   ├── autocmds.lua - auto-commands
|   |   ├── lazy.lua ----- nvim plugin manager
|   ├── plugins ---------- all plugin configs go here
|   |   ├── theme.lua
|   |   ├── ...
```

# Plugins

- File explorer: https://github.com/stevearc/oil.nvim
- File icons: https://github.com/echasnovski/mini.nvim
- Fuzzy finder: https://github.com/nvim-telescope/telescope.nvim
- Theme: https://github.com/catppuccin/nvim
- Autocomplete: coc.nvim??
- LSP: mason.vim??
- Git: ??

# External dependencies

- ripgrep: https://github.com/BurntSushi/ripgrep
- fd: https://github.com/sharkdp/fd
- treesitter-cli: npm install -g tree-sitter-cli 

# TODO

[ ] - 
