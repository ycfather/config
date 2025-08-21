local utils = require("utils")

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        config = function()
            local config = require("config.defaults")
            local formatters_by_ft = {}
            
            -- Build formatters based on language config
            for language, lang_config in pairs(config.languages) do
                if lang_config.enabled and lang_config.formatters then
                    formatters_by_ft[language] = lang_config.formatters
                end
            end
            
            require("conform").setup({
                formatters_by_ft = formatters_by_ft,
                
                format_on_save = function(bufnr)
                    if not config.lsp.format_on_save then
                        return nil
                    end
                    
                    -- Skip formatting for empty filetypes
                    local ignore = vim.bo[bufnr].filetype == ""
                    if ignore then 
                        return nil 
                    end
                    
                    return { 
                        timeout_ms = 1500, 
                        lsp_fallback = true 
                    }
                end,
                
                formatters = {
                    -- Custom formatter configurations can go here
                },
            })
        end,
    },
    
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
    },
    
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local icons = require("config.icons")
            
            require("todo-comments").setup({
                signs = true,
                sign_priority = 8,
                keywords = {
                    FIX = {
                        icon = icons.ui.bug,
                        color = "error",
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                    },
                    TODO = { icon = icons.ui.check, color = "info" },
                    HACK = { icon = icons.ui.fire, color = "warning" },
                    WARN = { icon = icons.diagnostics.warn, color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = icons.ui.target, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = icons.ui.note, color = "hint", alt = { "INFO" } },
                    TEST = { icon = icons.ui.gear, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
            })
        end,
    },
}