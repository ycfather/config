-- lua/plugins/format.lua
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            -- 每种文件类型的格式化器列表（按顺序尝试）
            formatters_by_ft = {
                python = { "ruff_format", "black" }, -- 先 ruff format，失败再用 black
                -- 你也可以在这里顺便配置其它语言的 formatter
            },
            -- 保存自动格式化
            format_on_save = function(bufnr)
                -- 仅格式化被 LSP/treesitter 识别的文件
                local ignore = vim.bo[bufnr].filetype == ""
                if ignore then return nil end
                return { timeout_ms = 1500, lsp_fallback = true }
            end,
        },
    },
}
