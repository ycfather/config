local utils = require("utils")

return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            local config = require("config.defaults")
            
            require("tokyonight").setup({
                style = config.ui.background == "light" and "day" or "night",
                transparent = config.ui.transparency,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "dark",
                },
                sidebars = { "qf", "help" },
                day_brightness = 0.3,
                hide_inactive_statusline = false,
                dim_inactive = false,
                lualine_bold = false,
            })
            
            -- Only set colorscheme if it matches config
            if config.ui.colorscheme == "tokyonight" then
                vim.cmd.colorscheme("tokyonight")
            end
        end,
    },
    
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 900,
        lazy = true,
        config = function()
            local config = require("config.defaults")
            
            require("catppuccin").setup({
                flavour = config.ui.background == "light" and "latte" or "mocha",
                transparent_background = config.ui.transparency,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    notify = false,
                    mini = false,
                },
            })
            
            -- Only set colorscheme if it matches config
            if config.ui.colorscheme == "catppuccin" then
                vim.cmd.colorscheme("catppuccin")
            end
        end,
    },
}