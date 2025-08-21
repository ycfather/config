return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.treesitter then
                return
            end
            
            local ensure_installed = {
                "lua", "vim", "vimdoc",
                "bash", "python", "javascript", "typescript",
                "json", "yaml", "toml",
                "markdown", "markdown_inline",
            }
            
            -- Add languages based on config
            for language, lang_config in pairs(config.languages) do
                if lang_config.enabled then
                    if language == "go" then
                        vim.list_extend(ensure_installed, {
                            "go", "gomod", "gowork", "gosum", "gotmpl"
                        })
                    elseif language == "rust" then
                        table.insert(ensure_installed, "rust")
                    elseif language == "typescript" then
                        table.insert(ensure_installed, "tsx")
                    end
                end
            end

            require("nvim-treesitter.configs").setup({
                ensure_installed = ensure_installed,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = "<C-s>",
                        node_decremental = "<M-space>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },
    
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Configuration handled automatically by treesitter
        end,
    },
}