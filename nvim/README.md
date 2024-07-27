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