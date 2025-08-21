local utils = require("utils")

return {
    -- Mason: Package manager for LSP servers, DAP adapters, linters, and formatters
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = {
                    border = require("config.defaults").ui.border,
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },

    -- Mason-LSPconfig: Bridge between mason and lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            local config = require("config.defaults")
            
            require("mason-lspconfig").setup({
                ensure_installed = config.lsp.servers,
                automatic_installation = config.lsp.auto_install,
            })
        end,
    },

    -- LSPConfig: Configurations for built-in LSP client
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local config = require("config.defaults")
            local icons = require("config.icons")
            
            -- Configure diagnostics with modern API
            local signs = {
                [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
                [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
                [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
                [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
            }
            
            vim.diagnostic.config({
                signs = config.lsp.diagnostics.signs and {
                    text = signs,
                } or false,
                underline = config.lsp.diagnostics.underline,
                update_in_insert = config.lsp.diagnostics.update_in_insert,
                severity_sort = config.lsp.diagnostics.severity_sort,
                virtual_text = config.lsp.virtual_text and {
                    spacing = 4,
                    prefix = "●",
                } or false,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = config.ui.border,
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
            
            -- Configure hover and signature help borders
            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                    border = config.ui.border,
                }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = config.ui.border,
                }),
            }
            
            -- Apply handlers to all servers
            for _, server in ipairs(config.lsp.servers) do
                require("lspconfig")[server].setup({
                    handlers = handlers,
                })
            end
        end,
    },

    -- Language-specific configurations
    { import = "plugins.lsp.languages.lua" },
    { import = "plugins.lsp.languages.python" },
    { import = "plugins.lsp.languages.go" },
    { import = "plugins.lsp.languages.rust" },
}