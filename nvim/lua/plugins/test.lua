-- lua/plugins/neotest.lua
return {
    {
        "nvim-neotest/neotest",
        ft = { "rust", "go", "python" }, -- 三种语言触发时再加载
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
            "nvim-neotest/neotest-python",
        },
        config = function()
            local neotest = require("neotest")

            neotest.setup({
                -- 通用 UI / 交互配置
                icons = {
                    running_animated = { "⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏" },
                    passed   = "",
                    failed   = "",
                    skipped  = "",
                    running  = "",
                    unknown  = "",
                },
                quickfix = {
                    enabled = false, -- 习惯用 neotest 的 summary/output
                },
                output = { open_on_run = false },   -- 不自动弹窗，按键手动打开
                summary = { follow = true, mappings = { attach = "a" } },

                -- 统一根目录规则（可按你项目风格再加）
                discovery = {
                    enabled = true,
                },

                -- 语言适配器
                adapters = {
                    -- Go
                    require("neotest-go")({
                        experimental = { test_table = true },
                        args = { "-count=1", "-race" }, -- 常用编译/运行参数
                    }),
                    -- Rust
                    require("neotest-rust")({
                        args = { "--nocapture" },       -- 打印 println!
                        dap_adapter = "codelldb",       -- 若你用的是 codelldb
                    }),
                    -- Python
                    require("neotest-python")({
                        runner = "pytest",              -- 默认 pytest；unittest 也能跑
                        args = { "-q" },                -- 安静输出
                        -- 自动选择解释器（优先 venv-selector/全局设置）
                        python = function()
                            return vim.g.python3_host_prog or "python3"
                        end,
                    }),
                },
            })

            -- =========================
            -- 统一快捷键（Normal 模式）
            -- =========================
            local map = vim.keymap.set
            local nt  = require("neotest")

            map("n", "<leader>tn", function() nt.run.run() end,                    { desc = "Test: Nearest" })
            map("n", "<leader>tf", function() nt.run.run(vim.fn.expand("%")) end,  { desc = "Test: Current File" })
            map("n", "<leader>tp", function() nt.run.run(vim.uv.cwd()) end,        { desc = "Test: Project (cwd)" })
            map("n", "<leader>tN", function() nt.run.run_last() end,               { desc = "Test: Run Last" })
            map("n", "<leader>tS", function() nt.run.stop() end,                   { desc = "Test: Stop" })

            map("n", "<leader>ts", nt.summary.toggle,                              { desc = "Test: Summary" })
            map("n", "<leader>to", function() nt.output.open({ enter = true }) end,{ desc = "Test: Output (float)" })
            map("n", "<leader>tO", function() nt.output_panel.toggle() end,        { desc = "Test: Output Panel" })

            map("n", "]t", function() nt.jump.next({ status = "failed" }) end,     { desc = "Test: Next Failed" })
            map("n", "[t", function() nt.jump.prev({ status = "failed" }) end,     { desc = "Test: Prev Failed" })
        end,
    },
}
