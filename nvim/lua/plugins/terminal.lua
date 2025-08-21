return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" } },
        opts = {
            open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = { border = "rounded" },
        },
    },
}

