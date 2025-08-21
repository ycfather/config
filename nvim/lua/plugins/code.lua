return {
    {
        "augmentcode/augment.vim",
        -- lazy = false,
    },
    -- nvim-cmp 补全
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind.nvim",
            { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "path" },
                    { name = "buffer" },
                }),
                formatting = {
                    format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, ellipsis_char = "…" }),
                },
            })

            -- Cmdline 补全
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            })

            -- 与 autopairs 联动
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- 自动括号
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- 注释
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {},
    },
    -- TODO 标注高亮
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function() require("mason").setup() end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        opts = {
            ensure_installed = {
                "lua_ls", "pyright", "ts_ls", "gopls", "rust_analyzer", "yamlls", "jsonls", -- 按需添加：clangd, bashls...
            },
            automatic_installation = true,
        },
    },
    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lsp = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end
                map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
                map("n", "gr", vim.lsp.buf.references, "References")
                map("n", "K",  vim.lsp.buf.hover, "Hover")
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
                map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
                map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
            end

            -- lua
            lsp.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                    },
                },
            })

            -- ts/js
            lsp.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })

            -- python
            lsp.pyright.setup({ 
                capabilities = capabilities, 
                on_attach = on_attach,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic", -- or "strict"
                            autoImportCompletions = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })
        end,
    },
}
