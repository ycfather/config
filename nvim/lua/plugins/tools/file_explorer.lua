return {
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            local config = require("config.defaults")
            
            if not config.features.file_explorer then
                return
            end
            
            local icons = require("config.icons")
            
            require("nvim-tree").setup({
                auto_reload_on_write = true,
                disable_netrw = true,
                hijack_netrw = true,
                hijack_cursor = false,
                hijack_unnamed_buffer_when_opening = false,
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                },
                view = {
                    width = 32,
                    side = "left",
                    preserve_window_proportions = false,
                    number = false,
                    relativenumber = false,
                    signcolumn = "yes",
                },
                renderer = {
                    add_trailing = false,
                    group_empty = true,
                    highlight_git = true,
                    full_name = false,
                    highlight_opened_files = "none",
                    root_folder_label = ":~:s?$?/..?",
                    indent_width = 2,
                    indent_markers = {
                        enable = false,
                        inline_arrows = true,
                        icons = {
                            corner = "└",
                            edge = "│",
                            item = "│",
                            bottom = "─",
                            none = " ",
                        },
                    },
                    icons = {
                        webdev_colors = true,
                        git_placement = "before",
                        padding = " ",
                        symlink_arrow = " ➛ ",
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                        glyphs = {
                            default = icons.files.default,
                            symlink = icons.files.symlink,
                            bookmark = "",
                            modified = "●",
                            folder = icons.files.folder,
                        },
                    },
                },
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
                update_cwd = false,
                diagnostics = {
                    enable = false,
                },
                filters = {
                    dotfiles = false,
                    git_clean = false,
                    no_buffer = false,
                    custom = {},
                    exclude = {},
                },
                filesystem_watchers = {
                    enable = true,
                    debounce_delay = 50,
                    ignore_dirs = {},
                },
                git = {
                    enable = true,
                    ignore = true,
                    show_on_dirs = true,
                    show_on_open_dirs = true,
                    timeout = 400,
                },
                actions = {
                    use_system_clipboard = true,
                    change_dir = {
                        enable = true,
                        global = false,
                        restrict_above_cwd = false,
                    },
                    expand_all = {
                        max_folder_discovery = 300,
                        exclude = {},
                    },
                    file_popup = {
                        open_win_config = {
                            col = 1,
                            row = 1,
                            relative = "cursor",
                            border = config.ui.border,
                            style = "minimal",
                        },
                    },
                    open_file = {
                        quit_on_open = false,
                        resize_window = true,
                        window_picker = {
                            enable = true,
                            picker = "default",
                            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                            exclude = {
                                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                                buftype = { "nofile", "terminal", "help" },
                            },
                        },
                    },
                    remove_file = {
                        close_window = true,
                    },
                },
                trash = {
                    cmd = "gio trash",
                    require_confirm = true,
                },
                live_filter = {
                    prefix = "[FILTER]: ",
                    always_show_folders = true,
                },
                tab = {
                    sync = {
                        open = false,
                        close = false,
                        ignore = {},
                    },
                },
                notify = {
                    threshold = vim.log.levels.INFO,
                },
                log = {
                    enable = false,
                    truncate = false,
                    types = {
                        all = false,
                        config = false,
                        copy_paste = false,
                        dev = false,
                        diagnostics = false,
                        git = false,
                        profile = false,
                        watcher = false,
                    },
                },
                system_open = {
                    cmd = "",
                    args = {},
                },
            })
            
        end,
    },
}