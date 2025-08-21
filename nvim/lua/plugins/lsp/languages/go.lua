local utils = require("utils")
local config = require("config.defaults")

-- Check if Go is enabled
if not config.languages.go or not config.languages.go.enabled then
    return {}
end

-- Setup Go LSP
local lsp_utils = require("utils.lsp")
lsp_utils.setup_server("gopls", {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

return {
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod", "gowork", "gotmpl" },
        dependencies = { "ray-x/guihua.lua" },
        build = ':lua require("go.install").update_all()',
        config = function()
            require("go").setup({
                lsp_cfg = false, -- Don't override LSP config
                lsp_keymaps = false,
                gofmt = "gofumpt",
                goimports = "goimports",
                tag_options = "json=omitempty",
                trouble = false,
                lsp_inlay_hints = {
                    enable = true,
                    only_current_line = false,
                },
                dap_debug = false, -- Use nvim-dap-go instead
            })
            
            -- Setup autocommand for formatting
            local augroup = utils.create_augroup("GoFormatting")
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                pattern = "*.go",
                callback = function()
                    require("go.format").goimport()
                end,
                desc = "Format Go files on save",
            })
            
            -- Setup Go-specific keymaps
            local map = require("utils.keymap")
            local keybindings = require("config.keybindings")
            if keybindings.languages.go then
                map.map_group(keybindings.languages.go)
            end
        end,
    },
    {
        "leoluz/nvim-dap-go",
        ft = { "go" },
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-go").setup()
            
            -- Additional Go DAP keymaps
            local map = require("utils.keymap")
            local mappings = {
                n = {
                    ["<leader>dt"] = {
                        rhs = function() require("dap-go").debug_test() end,
                        desc = "Debug Go Test"
                    },
                    ["<leader>dT"] = {
                        rhs = function() require("dap-go").debug_test({ breakpoints = true }) end,
                        desc = "Debug Go Test (with breakpoints)"
                    },
                }
            }
            map.map_group(mappings)
        end,
    },
}