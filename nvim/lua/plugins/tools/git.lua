return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.git_integration then
                return
            end
            
            local icons = require("config.icons")
            
            require("gitsigns").setup({
                signs = {
                    add = { text = icons.git.added },
                    change = { text = icons.git.modified },
                    delete = { text = icons.git.removed },
                    topdelete = { text = icons.git.removed },
                    changedelete = { text = icons.git.modified },
                    untracked = { text = icons.git.untracked },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = config.ui.border,
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
            })
        end,
    },
}