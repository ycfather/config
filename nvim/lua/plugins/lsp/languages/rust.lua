local utils = require("utils")
local config = require("config.defaults")

-- Check if Rust is enabled
if not config.languages.rust or not config.languages.rust.enabled then
    return {}
end

-- Rust-analyzer is handled by rustaceanvim, so we don't setup it manually

return {
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        dependencies = { "williamboman/mason.nvim" },
        init = function()
            local lsp_utils = require("utils.lsp")
            local dap_utils = require("utils.dap")
            
            vim.g.rustaceanvim = {
                server = {
                    on_attach = lsp_utils.on_attach,
                    capabilities = lsp_utils.get_capabilities(),
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            check = { command = "clippy" },
                            inlayHints = {
                                lifetimeElisionHints = { enable = true, useParameterNames = true },
                                bindingModeHints = { enable = true },
                                closureReturnTypeHints = { enable = "always" },
                                expressionAdjustmentHints = { enable = "always" },
                                reborrowHints = { enable = "always" },
                                parameterHints = { enable = true },
                                typeHints = { enable = true },
                            },
                        },
                    },
                },
                dap = { 
                    adapter = dap_utils.get_codelldb_adapter() 
                },
                tools = { 
                    float_win_config = { border = "rounded" } 
                },
            }
        end,
        config = function()
            -- Ensure rust-analyzer is installed via Mason
            local ok, mason_registry = pcall(require, "mason-registry")
            if ok then
                local rust_analyzer = mason_registry.get_package("rust-analyzer")
                if not rust_analyzer:is_installed() then
                    rust_analyzer:install()
                end
            end
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufReadPost Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local crates = require("crates")
            crates.setup({})

            -- Integration with nvim-cmp
            if utils.has_plugin("nvim-cmp") then
                local cmp = require("cmp")
                cmp.setup.filetype("toml", {
                    sources = cmp.config.sources(
                        { { name = "crates" } },
                        { { name = "path" }, { name = "buffer" } }
                    ),
                })
            end
            
            -- Setup Rust/Crates keymaps for TOML files
            local augroup = utils.create_augroup("RustCratesKeymaps")
            vim.api.nvim_create_autocmd("FileType", {
                group = augroup,
                pattern = "toml",
                callback = function(args)
                    local map = require("utils.keymap")
                    local keybindings = require("config.keybindings")
                    if keybindings.languages.rust then
                        map.create_buf_mappings(args.buf, keybindings.languages.rust)
                    end
                end,
                desc = "Setup Rust crate keymaps",
            })
        end,
    },
}