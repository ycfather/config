-- Editor options configuration
local config = require("config.defaults")
local opt = vim.opt

-- Leader keys
vim.g.mapleader = config.leader
vim.g.maplocalleader = config.localleader

-- Line numbers and cursor
opt.number = config.editor.number
opt.relativenumber = config.editor.relativenumber
opt.cursorline = config.editor.cursorline
opt.signcolumn = config.editor.signcolumn

-- Colors and rendering
opt.termguicolors = true
opt.scrolloff = config.editor.scrolloff
opt.sidescrolloff = config.editor.sidescrolloff

-- Window/split behavior
opt.splitright = true
opt.splitbelow = true

-- Performance
opt.updatetime = config.editor.updatetime

-- Tab and indentation settings
opt.tabstop = config.editor.tabstop
opt.shiftwidth = config.editor.shiftwidth
opt.softtabstop = config.editor.softtabstop
opt.expandtab = config.editor.expandtab
opt.smartindent = config.editor.smartindent

-- Search behavior
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Backup and undo
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.swapfile = false

-- Completion behavior
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Mouse and clipboard
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

-- Better display
opt.cmdheight = 1
opt.showmode = false
opt.pumheight = 10
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.wrap = false