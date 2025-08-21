return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local icons = require("config.icons")
            
            -- Custom header
            dashboard.section.header.val = {
                "                                                     ",
                "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                "                                                     ",
            }
            
            -- Custom buttons
            dashboard.section.buttons.val = {
                dashboard.button("e", icons.ui.newfile .. "  New file", ":ene <BAR> startinsert<CR>"),
                dashboard.button("f", icons.ui.search .. "  Find file", ":Telescope find_files<CR>"),
                dashboard.button("r", icons.ui.history .. "  Recent files", ":Telescope oldfiles<CR>"),
                dashboard.button("p", icons.ui.project .. "  Find project", ":Telescope projects<CR>"),
                dashboard.button("c", icons.ui.gear .. "  Configuration", ":e $MYVIMRC<CR>"),
                dashboard.button("q", icons.ui.signout .. "  Quit", ":qa<CR>"),
            }
            
            -- Footer
            local function footer()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
            end
            
            dashboard.section.footer.val = footer()
            
            -- Layout
            dashboard.config.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            }
            
            alpha.setup(dashboard.config)
            
            -- Disable folding on alpha buffer
            vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
        end,
    },
}