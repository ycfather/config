return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { 
            { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
            { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.terminal then
                return
            end
            
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                direction = "float",
                float_opts = { 
                    border = config.ui.border,
                    winblend = config.ui.winblend,
                },
                shell = vim.o.shell,
                auto_scroll = true,
                close_on_exit = true,
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = true,
                persist_mode = true,
            })
            
            -- Setup Rust cargo terminal commands if available
            local ok, Terminal = pcall(function() 
                return require("toggleterm.terminal").Terminal 
            end)
            if ok and config.languages.rust and config.languages.rust.enabled then
                local function term_cmd(cmd)
                    return function()
                        Terminal:new({ 
                            cmd = cmd, 
                            direction = "float", 
                            close_on_exit = false 
                        }):toggle()
                    end
                end
                
                local map = require("utils.keymap")
                local mappings = {
                    n = {
                        ["<leader>rb"] = { 
                            rhs = term_cmd("cargo build"), 
                            desc = "Cargo Build" 
                        },
                        ["<leader>rr"] = { 
                            rhs = term_cmd("cargo run"), 
                            desc = "Cargo Run" 
                        },
                        ["<leader>rt"] = { 
                            rhs = term_cmd("cargo test"), 
                            desc = "Cargo Test" 
                        },
                    }
                }
                map.map_group(mappings)
            end
        end,
    },
}