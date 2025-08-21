return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.telescope then
                return
            end
            
            local icons = require("config.icons")
            local telescope = require("telescope")
            
            telescope.setup({
                defaults = {
                    prompt_prefix = icons.ui.search .. " ",
                    selection_caret = icons.ui.triangle .. " ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            mirror = false,
                            prompt_position = "top",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    file_sorter = require("telescope.sorters").get_fuzzy_file,
                    file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
                    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                    path_display = { "truncate" },
                    winblend = config.ui.winblend,
                    border = {},
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    color_devicons = true,
                    use_less = true,
                    set_env = { ["COLORTERM"] = "truecolor" },
                    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                    mappings = {
                        i = {
                            ["<C-n>"] = require("telescope.actions").move_selection_next,
                            ["<C-p>"] = require("telescope.actions").move_selection_previous,
                            ["<C-c>"] = require("telescope.actions").close,
                            ["<Down>"] = require("telescope.actions").move_selection_next,
                            ["<Up>"] = require("telescope.actions").move_selection_previous,
                            ["<CR>"] = require("telescope.actions").select_default,
                            ["<C-x>"] = require("telescope.actions").select_horizontal,
                            ["<C-v>"] = require("telescope.actions").select_vertical,
                            ["<C-t>"] = require("telescope.actions").select_tab,
                            ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                            ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                            ["<PageUp>"] = require("telescope.actions").results_scrolling_up,
                            ["<PageDown>"] = require("telescope.actions").results_scrolling_down,
                            ["<Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_worse,
                            ["<S-Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_better,
                            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
                            ["<M-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                            ["<C-l>"] = require("telescope.actions").complete_tag,
                            ["<C-_>"] = require("telescope.actions").which_key,
                        },
                        n = {
                            ["<esc>"] = require("telescope.actions").close,
                            ["<CR>"] = require("telescope.actions").select_default,
                            ["<C-x>"] = require("telescope.actions").select_horizontal,
                            ["<C-v>"] = require("telescope.actions").select_vertical,
                            ["<C-t>"] = require("telescope.actions").select_tab,
                            ["<Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_worse,
                            ["<S-Tab>"] = require("telescope.actions").toggle_selection + require("telescope.actions").move_selection_better,
                            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
                            ["<M-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                            ["j"] = require("telescope.actions").move_selection_next,
                            ["k"] = require("telescope.actions").move_selection_previous,
                            ["H"] = require("telescope.actions").move_to_top,
                            ["M"] = require("telescope.actions").move_to_middle,
                            ["L"] = require("telescope.actions").move_to_bottom,
                            ["<Down>"] = require("telescope.actions").move_selection_next,
                            ["<Up>"] = require("telescope.actions").move_selection_previous,
                            ["gg"] = require("telescope.actions").move_to_top,
                            ["G"] = require("telescope.actions").move_to_bottom,
                            ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
                            ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
                            ["<PageUp>"] = require("telescope.actions").results_scrolling_up,
                            ["<PageDown>"] = require("telescope.actions").results_scrolling_down,
                            ["?"] = require("telescope.actions").which_key,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                    live_grep = {
                        additional_args = function(opts)
                            return { "--hidden" }
                        end,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            -- Load extensions
            pcall(telescope.load_extension, "fzf")
        end,
    },
}