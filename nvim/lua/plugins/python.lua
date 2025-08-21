-- lua/plugins/python.lua
return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        cmd = { "VenvSelect", "VenvSelectCached" },
        dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
        opts = {
            -- 会自动查找 .venv、venv、poetry、conda 等环境
            pipenv = { enable = true },
            poetry = { enable = true },
            anaconda_base_path = nil,
            anaconda_envs_path = nil,
        },
        keys = {
            { "<leader>vv", "<cmd>VenvSelect<CR>",        desc = "Venv: select" },
            { "<leader>vV", "<cmd>VenvSelectCached<CR>",  desc = "Venv: select cached" },
        },
    },
}
