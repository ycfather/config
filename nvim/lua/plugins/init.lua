-- Main plugin loader
-- This file imports all plugin modules and returns them as a single spec

local config = require("config.defaults")
local specs = {}

-- Core plugins (always loaded)
vim.list_extend(specs, {
    -- Essential dependencies
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    
    -- Which-key for keymap help
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cond = function()
            return config.features.which_key
        end,
        config = function()
            local wk = require("which-key")
            
            wk.setup({
                preset = "modern",
                delay = function(ctx)
                    return ctx.plugin and 0 or 200
                end,
                filter = function(mapping)
                    return true
                end,
                spec = {},
                notify = true,
                triggers = {
                    { "<auto>", mode = "nxso" },
                },
                disable = {
                    ft = { "TelescopePrompt" },
                    bt = {},
                },
            })

            -- Register key groups
            wk.add({
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git/Go" },
                { "<leader>l", group = "LSP" },
                { "<leader>d", group = "Debug" },
                { "<leader>t", group = "Test" },
                { "<leader>u", group = "UI" },
                { "<leader>w", group = "Workspace" },
                { "<leader>c", group = "Code/Crates" },
                { "<leader>r", group = "Run/Rust" },
                { "<leader>p", group = "Python" },
                { "<leader>v", group = "Venv" },
            })
        end,
    },
})

-- Feature-based plugin loading
if config.features.completion or config.features.treesitter then
    vim.list_extend(specs, { { import = "plugins.editor" } })
end

-- Development tools
if config.features.telescope or config.features.file_explorer or config.features.terminal or config.features.git_integration then
    vim.list_extend(specs, { { import = "plugins.tools" } })
end

-- UI plugins
vim.list_extend(specs, { { import = "plugins.ui" } })

-- LSP and language support
vim.list_extend(specs, { { import = "plugins.lsp" } })

-- Additional development tools
if config.features.debugging then
    vim.list_extend(specs, { { import = "plugins.tools.debugging" } })
end

if config.features.testing then
    vim.list_extend(specs, { { import = "plugins.tools.testing" } })
end

-- Linting (always include if any language has linters)
local has_linting = false
for _, lang_config in pairs(config.languages) do
    if lang_config.enabled and lang_config.linters then
        has_linting = true
        break
    end
end

if has_linting then
    vim.list_extend(specs, { { import = "plugins.tools.linting" } })
end

return specs