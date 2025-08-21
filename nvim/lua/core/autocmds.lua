-- Global autocommands
local utils = require("utils")

-- Highlight on yank
local highlight_group = utils.create_augroup("YankHighlight")
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_group,
    callback = function()
        vim.highlight.on_yank()
    end,
    desc = "Highlight yanked text",
})

-- Resize splits if window got resized
local resize_group = utils.create_augroup("ResizeSplits")
vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = resize_group,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits when window is resized",
})

-- Close some filetypes with <q>
local close_with_q_group = utils.create_augroup("CloseWithQ")
vim.api.nvim_create_autocmd("FileType", {
    group = close_with_q_group,
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close certain filetypes with q",
})

-- Wrap and check for spell in text filetypes
local wrap_spell_group = utils.create_augroup("WrapSpell")
vim.api.nvim_create_autocmd("FileType", {
    group = wrap_spell_group,
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    desc = "Enable wrap and spell for text files",
})

-- Fix conceallevel for json files
local json_conceal_group = utils.create_augroup("JsonConceal")
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = json_conceal_group,
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
    desc = "Fix conceallevel for json files",
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
local auto_create_dir_group = utils.create_augroup("AutoCreateDir")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = auto_create_dir_group,
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
    desc = "Auto create directory when saving file",
})

-- Check if we need to reload the file when it changed
local checktime_group = utils.create_augroup("Checktime")
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = checktime_group,
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
    desc = "Check for file changes when gaining focus",
})

-- Go to last location when opening a buffer
local last_location_group = utils.create_augroup("LastLocation")
vim.api.nvim_create_autocmd("BufReadPost", {
    group = last_location_group,
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Go to last location when opening a buffer",
})

