-- =============================================================================
-- Neovim for Nurses (N4N) - Main Configuration File
-- =============================================================================

-- Import utility modules
local utils = require('config.utils')
local clinical = require('config.clinical')
local plugins = require('config.plugins')

-- Basic Neovim settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"

-- Color scheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-moon")

-- Clinical-specific settings
clinical.setup()

-- Initialize plugins
plugins.setup()

-- Global key bindings
utils.setup_keybindings()

-- Status line
vim.opt.laststatus = 3
vim.opt.statusline = "%f %m %r %h %w %=%l,%c %p%% %L lines"

-- Auto commands
vim.cmd([[
  augroup ClinicalAutocmds
    autocmd!
    " Auto-load clinical templates
    autocmd BufNewFile *.txt :lua require('config.templates').load_template()
    " Patient note formatting
    autocmd BufWritePre *.txt :lua require('config.format').format_clinical_note()
  augroup END
]]) print("🩺 Neovim for Nurses (N4N) loaded successfully!")