# Neovim Config

A minimal Neovim setup oriented around Python development, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Plugins

| Plugin | Purpose |
|--------|---------|
| [monokai.nvim](https://github.com/tanvirtin/monokai.nvim) | Color scheme |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Installs and manages LSP server binaries |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Bridges Mason and Neovim's built-in LSP client |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion popup menu |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting via real language grammars |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, grep, buffers, and more |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | File explorer sidebar |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Displays open buffers as tabs |
| [bufdelete.nvim](https://github.com/famiu/bufdelete.nvim) | Fixes buffer deletion behaviour with bufferline |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git diff markers in the sign column |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-buffer markdown rendering (headings, tables, code blocks, etc.) |

## LSP Servers

Installed automatically via Mason:

| Server | Purpose |
|--------|---------|
| [basedpyright](https://github.com/DetachHead/basedpyright) | Python type checking and static analysis |
| [ruff](https://github.com/astral-sh/ruff) | Python linting and formatting |
| [lua_ls](https://github.com/LuaLS/lua-language-server) | Lua language support (for editing this config) |

## Keymaps

### Telescope
| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Browse open buffers |
| `<leader>fh` | Search help tags |

### File Tree
| Keymap | Action |
|--------|--------|
| `<leader>e` | Toggle file explorer |

### Buffers
| Keymap | Action |
|--------|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>x` | Close buffer |

### Autocompletion
| Keymap | Action |
|--------|--------|
| `<CR>` | Confirm suggestion |
| `<C-Space>` | Trigger completion menu |

## Claude Code Integration

The auto-reload feature (section 6) was added specifically for use with
[Claude Code CLI](https://github.com/anthropics/claude-code). When Claude Code
edits a file in a separate tmux pane, Neovim automatically reloads it every
second without requiring any manual action or cursor movement.

The OSC 52 clipboard setup (section 4) was also motivated by this workflow —
copying Claude Code output reliably across Mac → Docker → Tmux → Nvim layers.

## Notes

- **Clipboard:** `"+y` works reliably for copying across Mac → Docker → Tmux → Nvim layers via OSC 52. `"+p` does not work reliably for pasting on macOS — use `Cmd+v` instead.
- **Auto-reload:** Files modified externally are automatically reloaded every second, so edits made outside Neovim (e.g. by Claude Code) are picked up without any manual action.
