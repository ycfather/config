local utils = require("utils")

return {
    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.indent_guides then
                return
            end
            
            local ibl = require("ibl")
            local hooks = require("ibl.hooks")

            -- Define colors for indent levels
            local colors = { "#E06C75", "#E5C07B", "#98C379", "#61AFEF", "#C678DD", "#56B6C2" }
            
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                for i, c in ipairs(colors) do
                    vim.api.nvim_set_hl(0, "IndentLevel" .. i, { fg = c, nocombine = true })
                end
                vim.api.nvim_set_hl(0, "IndentScope", { fg = "#7f8490", nocombine = true })
            end)

            ibl.setup({
                indent = {
                    char = "┆",
                    highlight = {
                        "IndentLevel1", "IndentLevel2", "IndentLevel3",
                        "IndentLevel4", "IndentLevel5", "IndentLevel6",
                    },
                },
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                    highlight = "IndentScope",
                },
                whitespace = { remove_blankline_trail = true },
                exclude = {
                    filetypes = {
                        "help", "alpha", "dashboard", "neo-tree", "NvimTree",
                        "Trouble", "lazy", "mason", "notify", "toggleterm",
                    },
                    buftypes = { "terminal", "nofile", "quickfix", "prompt" },
                },
            })
        end,
    },

    -- Scrollbar
    {
        "petertriho/nvim-scrollbar",
        event = "VeryLazy",
        config = function()
            local icons = require("config.icons")
            
            require("scrollbar").setup({
                show = true,
                show_in_active_only = false,
                set_highlights = true,
                folds = 1000,
                max_lines = false,
                hide_if_all_visible = false,
                throttle_ms = 100,
                handle = {
                    text = " ",
                    color = nil,
                    cterm = nil,
                    highlight = "CursorColumn",
                    hide_if_all_visible = true,
                },
                marks = {
                    Search = {
                        text = { "-", "=" },
                        priority = 0,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "Search",
                    },
                    Error = {
                        text = { "-", "=" },
                        priority = 1,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "DiagnosticVirtualTextError",
                    },
                    Warn = {
                        text = { "-", "=" },
                        priority = 2,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "DiagnosticVirtualTextWarn",
                    },
                    Info = {
                        text = { "-", "=" },
                        priority = 3,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "DiagnosticVirtualTextInfo",
                    },
                    Hint = {
                        text = { "-", "=" },
                        priority = 4,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "DiagnosticVirtualTextHint",
                    },
                    Misc = {
                        text = { "-", "=" },
                        priority = 5,
                        gui = nil,
                        color = nil,
                        cterm = nil,
                        color_nr = nil,
                        highlight = "Normal",
                    },
                },
                excluded_buftypes = {
                    "terminal",
                },
                excluded_filetypes = {
                    "prompt",
                    "TelescopePrompt",
                    "noice",
                },
                autocmd = {
                    render = {
                        "BufWinEnter",
                        "TabEnter",
                        "TermEnter",
                        "WinEnter",
                        "CmdwinLeave",
                        "TextChanged",
                        "VimResized",
                        "WinScrolled",
                    },
                    clear = {
                        "BufWinLeave",
                        "TabLeave",
                        "TermLeave",
                        "WinLeave",
                    },
                },
                handlers = {
                    diagnostic = true,
                    search = false,
                },
            })
        end,
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            local config = require("config.defaults")
            
            if not config.features.colorizer then
                return
            end
            
            require("colorizer").setup({
                user_default_options = {
                    names = false,
                    RGB = true,
                    RRGGBB = true,
                    RRGGBBAA = true,
                    rgb_fn = true,
                    hsl_fn = true,
                    css = true,
                    css_fn = true,
                    mode = "background",
                    tailwind = false,
                    sass = { enable = false },
                    virtualtext = "■",
                },
                buftypes = {},
                filetypes = {
                    "*",
                    "!lazy",
                },
            })
        end,
    },

    -- Notifications
    {
        "rcarriga/nvim-notify",
        config = function()
            local config = require("config.defaults")
            
            if not config.features.notify then
                return
            end
            
            local icons = require("config.icons")
            
            require("notify").setup({
                stages = "fade",
                timeout = 3000,
                background_colour = "#000000",
                icons = {
                    ERROR = icons.diagnostics.error,
                    WARN = icons.diagnostics.warn,
                    INFO = icons.diagnostics.info,
                    DEBUG = icons.ui.bug,
                    TRACE = icons.ui.pencil,
                },
            })
            
            vim.notify = require("notify")
        end,
    },

    -- Better command line and messages
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        config = function()
            require("noice").setup({
                lsp = {
                    progress = { enabled = true },
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = false,
                },
            })
        end,
    },

    -- Better UI for vim.ui
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            local config = require("config.defaults")
            
            require("dressing").setup({
                input = {
                    enabled = true,
                    default_prompt = "Input:",
                    prompt_align = "left",
                    insert_only = true,
                    start_in_insert = true,
                    border = config.ui.border,
                    relative = "cursor",
                    prefer_width = 40,
                    width = nil,
                    max_width = { 140, 0.9 },
                    min_width = { 20, 0.2 },
                    winblend = config.ui.winblend,
                },
                select = {
                    enabled = true,
                    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                    trim_prompt = true,
                    telescope = nil,
                    fzf = {
                        window = {
                            width = 0.5,
                            height = 0.4,
                        },
                    },
                    fzf_lua = {},
                    nui = {
                        position = "50%",
                        size = nil,
                        relative = "editor",
                        border = {
                            style = config.ui.border,
                        },
                        buf_options = {
                            swapfile = false,
                            filetype = "DressingSelect",
                        },
                        win_options = {
                            winblend = config.ui.winblend,
                        },
                        max_width = 80,
                        max_height = 40,
                        min_width = 40,
                        min_height = 10,
                    },
                    builtin = {
                        show_numbers = true,
                        border = config.ui.border,
                        relative = "editor",
                        buf_options = {},
                        win_options = {
                            winblend = config.ui.winblend,
                            cursorline = true,
                            cursorlineopt = "both",
                        },
                        width = nil,
                        max_width = { 140, 0.8 },
                        min_width = { 40, 0.2 },
                        height = nil,
                        max_height = 0.9,
                        min_height = { 10, 0.2 },
                    },
                },
            })
        end,
    },
}