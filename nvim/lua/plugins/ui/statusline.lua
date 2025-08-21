return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local config = require("config.defaults")
            
            if not config.features.statusline then
                return
            end
            
            local icons = require("config.icons")
            
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = "",
                    component_separators = "",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added .. " ",
                                modified = icons.git.modified .. " ",
                                removed = icons.git.removed .. " ",
                            },
                        },
                    },
                    lualine_c = {
                        {
                            "filename",
                            symbols = {
                                modified = icons.git.modified,
                                readonly = icons.ui.lock,
                                unnamed = "[No Name]",
                                newfile = icons.ui.newfile,
                            },
                        },
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.error .. " ",
                                warn = icons.diagnostics.warn .. " ",
                                info = icons.diagnostics.info .. " ",
                                hint = icons.diagnostics.hint .. " ",
                            },
                        },
                    },
                    lualine_x = {
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = { "nvim-tree", "toggleterm" },
            })
        end,
    },
    
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            local config = require("config.defaults")
            
            if not config.features.bufferline then
                return
            end
            
            local icons = require("config.icons")
            
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    separator_style = "slant",
                    always_show_bufferline = false,
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and icons.diagnostics.error
                            or level:match("warning") and icons.diagnostics.warn
                            or icons.diagnostics.info
                        return " " .. icon .. count
                    end,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true,
                        },
                    },
                },
            })
        end,
    },
}