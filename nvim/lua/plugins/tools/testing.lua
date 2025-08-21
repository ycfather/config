local utils = require("utils")

return {
    {
        "nvim-neotest/neotest",
        ft = { "rust", "go", "python" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
            "nvim-neotest/neotest-python",
        },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.testing then
                return
            end
            
            local icons = require("config.icons")
            local neotest = require("neotest")

            neotest.setup({
                icons = icons.test,
                quickfix = {
                    enabled = false,
                },
                output = { open_on_run = false },
                summary = { follow = true, mappings = { attach = "a" } },
                discovery = {
                    enabled = true,
                },

                adapters = {
                    -- Go
                    require("neotest-go")({
                        experimental = { test_table = true },
                        args = { "-count=1", "-race" },
                    }),
                    -- Rust
                    require("neotest-rust")({
                        args = { "--nocapture" },
                        dap_adapter = "codelldb",
                    }),
                    -- Python
                    require("neotest-python")({
                        runner = "pytest",
                        args = { "-q" },
                        python = function()
                            return vim.g.python3_host_prog or "python3"
                        end,
                    }),
                },
            })

            -- Setup test keymaps
            local map = require("utils.keymap")
            local keybindings = require("config.keybindings")
            if keybindings.test then
                map.map_group(keybindings.test)
            end
        end,
    },
}