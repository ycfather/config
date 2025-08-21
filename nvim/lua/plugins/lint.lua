-- lua/plugins/lint.lua
return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local lint = require("lint")

        --------------------------------------------------------------------------
        -- 1) 绑定文件类型 → Linter
        --------------------------------------------------------------------------
        lint.linters_by_ft = {
            go     = { "golangcilint" },
            python = { "ruff" },
        }

        --------------------------------------------------------------------------
        -- 2) 条件运行：仅在工具存在 / 项目配置存在时才跑
        --------------------------------------------------------------------------
        local function has_file_upwards(startpath, names)
            -- 从文件路径向上查找任一配置文件
            local found = vim.fs.find(
                names,
                { upward = true, path = startpath, stop = vim.loop.os_homedir() }
            )
            return #found > 0
        end

        -- Go: golangci-lint 仅在安装且项目根有配置文件时启用
        if lint.linters.golangcilint then
            lint.linters.golangcilint.condition = function(ctx)
                if vim.fn.executable("golangci-lint") ~= 1 then return false end
                return has_file_upwards(ctx.filename, {
                    ".golangci.yaml", ".golangci.yml", ".golangci.toml", ".golangci.json",
                })
            end
            -- 你也可以在这里自定义 args，例如：
            -- lint.linters.golangcilint.args = { "run", "--out-format", "json" }
        end

        -- Python: ruff 仅在安装时启用
        if lint.linters.ruff then
            lint.linters.ruff.condition = function(_)
                return vim.fn.executable("ruff") == 1
            end
            -- 如需传参：
            -- lint.linters.ruff.args = { "check", "--quiet", "--stdin-filename", "$FILENAME", "-" }
        end

        --------------------------------------------------------------------------
        -- 3) 自动触发 + 简单防抖
        --------------------------------------------------------------------------
        local debounce_ms = 150
        local timer = vim.uv.new_timer()

        local function try_lint_debounced(bufnr)
            if timer then timer:stop() end
            timer:start(debounce_ms, 0, function()
                -- 在主线程调用
                vim.schedule(function()
                    -- 仅 lint 当前 buffer 的对应 filetype
                    lint.try_lint(nil, { ignore_errors = true })
                end)
            end)
        end

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("NvimLintAuto", { clear = true }),
            pattern = { "*.go", "*.py" },
            callback = function(args) try_lint_debounced(args.buf) end,
        })

        --------------------------------------------------------------------------
        -- 4) 快捷键
        --------------------------------------------------------------------------
        local map = vim.keymap.set
        map("n", "<leader>ll", function()
            lint.try_lint(nil, { ignore_errors = true })
        end, { desc = "Lint: run for current buffer" })

        map("n", "<leader>lq", function()
            vim.diagnostic.reset(nil, 0)  -- 清空当前 buffer 的诊断
        end, { desc = "Lint: clear diagnostics (buffer)" })
    end,
}
