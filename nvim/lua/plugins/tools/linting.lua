local utils = require("utils")

return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local config = require("config.defaults")
            local lint = require("lint")

            -- Build linters_by_ft from language config
            local linters_by_ft = {}
            for language, lang_config in pairs(config.languages) do
                if lang_config.enabled and lang_config.linters then
                    linters_by_ft[language] = lang_config.linters
                end
            end
            
            lint.linters_by_ft = linters_by_ft

            -- Conditional linter setup with project detection
            local function has_file_upwards(startpath, names)
                local found = vim.fs.find(
                    names,
                    { upward = true, path = startpath, stop = vim.loop.os_homedir() }
                )
                return #found > 0
            end

            -- Go: golangci-lint with project detection
            if lint.linters.golangcilint then
                lint.linters.golangcilint.condition = function(ctx)
                    if not utils.executable("golangci-lint") then 
                        return false 
                    end
                    return has_file_upwards(ctx.filename, {
                        ".golangci.yaml", ".golangci.yml", ".golangci.toml", ".golangci.json",
                    })
                end
            end

            -- Python: ruff
            if lint.linters.ruff then
                lint.linters.ruff.condition = function(_)
                    return utils.executable("ruff")
                end
            end

            -- Debounced linting
            local debounce_ms = 150
            local timer = vim.uv.new_timer()

            local function try_lint_debounced(bufnr)
                if timer then timer:stop() end
                timer:start(debounce_ms, 0, function()
                    vim.schedule(function()
                        lint.try_lint(nil, { ignore_errors = true })
                    end)
                end)
            end

            -- Auto-trigger linting
            local augroup = utils.create_augroup("NvimLintAuto")
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
                group = augroup,
                pattern = { "*.go", "*.py", "*.rs", "*.lua" },
                callback = function(args) 
                    try_lint_debounced(args.buf) 
                end,
            })

            -- Setup lint keymaps
            local map = require("utils.keymap")
            local keybindings = require("config.keybindings")
            if keybindings.lint then
                map.map_group(keybindings.lint)
            end
        end,
    },
}