-- =============================================================
-- 1. BOOTSTRAP LAZY.NVIM
-- This automatically downloads the plugin manager if you don't have it.
-- =============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================
-- 2. PLUGINS
-- =============================================================
require("lazy").setup({
    -- Color scheme / visual theme.
    {
        'tanvirtin/monokai.nvim',
        config = function()
            require('monokai').setup {}
            vim.cmd.colorscheme 'monokai'
        end
    },

    -- Downloads and installs LSP server binaries (e.g. basedpyright, ruff).
    -- Think of it as a package manager specifically for language servers.
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function() require("mason").setup() end
    },

    -- Bridges Mason and Neovim's built-in LSP client.
    -- Auto-configures installed servers so they work out of the box.
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = { "basedpyright", "ruff", "lua_ls" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({})
                    end,
                },
            })
        end
    },

    -- Autocompletion popup menu. LSP provides the data, this plugin renders the UI.
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = { { name = "nvim_lsp" } },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
            })
        end
    },

    -- Syntax highlighting and code structure parsing using a real grammar (not regex).
    -- More accurate and faster than Neovim's legacy syntax highlighting.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = { "python", "lua", "vim", "markdown", "markdown_inline" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Fuzzy finder for files, live grep, buffers, help tags, and more.
    -- Triggered via <leader>f* keymaps defined in section 5.
    {
        'nvim-telescope/telescope.nvim',
        tag = 'v0.1.9',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = {
                        "__pycache__",
                        "node_modules",
                        ".git/",
                        -- Image files
                        "%.png$",
                        "%.jpg$",
                        "%.jpeg$",
                        "%.gif$",
                        "%.webp$",
                        "%.svg$",
                        "%.ico$",
                        "%.bmp$",
                    }
                }
            })
        end
    },

    -- File explorer sidebar. Toggle with <leader>e.
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Displays open buffers as tabs along the top of the screen.
    -- Cycle with <Tab> / <S-Tab>, close with <leader>x.
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup()
        end,
    },

    -- Fixes buffer deletion when used with bufferline.
    -- Neovim's built-in :bd does not play well with bufferline; :Bdelete handles it correctly.
    { "famiu/bufdelete.nvim" },

    -- Shows git diff markers in the sign column (added/changed/deleted lines).
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Renders markdown beautifully in-buffer (headings, tables, code blocks, etc.)
    -- Similar to Obsidian's editing view. Requires treesitter markdown grammars.
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("render-markdown").setup()
        end,
    },
})

-- =============================================================
-- 3. LSP SETTINGS
-- =============================================================

-- BasedPyright settings
vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            typeCheckingMode = "basic",
            analysis = {
                diagnosticMode = "openFilesOnly",
            }
        }
    }
})

-- Ruff settings
vim.lsp.config("ruff", {
    on_attach = function(client)
        -- Let BasedPyright handle hover info, not Ruff
        client.server_capabilities.hoverProvider = false
    end,
})

-- =============================================================
-- 4. BASIC SETTINGS
-- =============================================================

-- Clipboard fix for tmux inside docker containers.
-- OSC 52 is used to shuttle clipboard data through terminal layers.
-- "+y (yank) works reliably across all layers (Mac -> Docker -> Tmux -> Nvim).
-- "+p (paste) does NOT work reliably on macOS through these layers — use Cmd+v instead.
vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
}

vim.cmd("syntax enable")
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation settings: use 4 spaces, consistent across all file types.
-- tabstop:   how wide a Tab character appears visually.
-- shiftwidth: how many spaces >> / << and auto-indent use.
-- expandtab: pressing Tab inserts spaces instead of a tab character.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- =============================================================
-- 5. KEYMAPS
-- =============================================================

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })

-- bufferline
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

-- bufdelete
vim.keymap.set('n', '<leader>x', ':Bdelete<CR>', { desc = 'Close buffer' })

-- =============================================================
-- 6. AUTO-RELOAD
-- Auto-reload files modified externally (e.g. by Claude Code)
-- =============================================================

-- autoread: tells Neovim to silently reload a file when it
-- detects the on-disk version is newer, instead of warning.
-- By itself this does nothing — something must trigger the check.
vim.opt.autoread = true

-- Background timer: runs checktime every second using Neovim's
-- built-in libuv event loop. This works even when Neovim has no
-- focus (e.g. you're in the Claude Code tmux pane), unlike
-- autocommand-based approaches which require cursor activity.
-- vim.schedule_wrap is needed because vim commands can't be
-- called directly from a libuv callback — it queues the call
-- to run safely on Neovim's main thread.
local timer = vim.uv.new_timer()
timer:start(0, 1000, vim.schedule_wrap(function()
    if vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
    end
end))
