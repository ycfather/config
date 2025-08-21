local utils = require("utils")
local config = require("config.defaults")

-- Check if Python is enabled
if not config.languages.python or not config.languages.python.enabled then
    return {}
end

-- Setup Python LSP
local lsp_utils = require("utils.lsp")
lsp_utils.setup_server("pyright", {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticMode = "workspace",
            },
        },
    },
})

return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        cmd = { "VenvSelect", "VenvSelectCached" },
        dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
        opts = {
            pipenv = { enable = true },
            poetry = { enable = true },
            anaconda_base_path = nil,
            anaconda_envs_path = nil,
        },
        keys = {
            { "<leader>vv", "<cmd>VenvSelect<CR>", desc = "Select Python Venv" },
            { "<leader>vV", "<cmd>VenvSelectCached<CR>", desc = "Select Cached Venv" },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap_utils = require("utils.dap")
            local python_path = dap_utils.python_config()
            require("dap-python").setup(python_path)
            
            -- Setup Python-specific DAP keymaps
            local map = require("utils.keymap")
            local keybindings = require("config.keybindings")
            if keybindings.languages.python then
                map.map_group(keybindings.languages.python)
            end
        end,
    },
}