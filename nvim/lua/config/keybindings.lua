return {
    -- Global keymaps
    global = {
        n = {
            -- Basic operations
            ["<leader>w"] = { rhs = "<cmd>w<cr>", desc = "Save File" },
            ["<leader>q"] = { rhs = "<cmd>q<cr>", desc = "Quit" },
            ["<leader>h"] = { rhs = "<cmd>nohlsearch<cr>", desc = "Clear Highlights" },
            
            -- File explorer
            ["<leader>e"] = { rhs = "<cmd>NvimTreeToggle<cr>", desc = "File Explorer" },
            
            -- Telescope
            ["<leader>ff"] = { rhs = "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            ["<leader>fg"] = { rhs = "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
            ["<leader>fb"] = { rhs = "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            ["<leader>fh"] = { rhs = "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
            ["<leader>fr"] = { rhs = "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
            
            -- UI toggles
            ["<leader>ut"] = { 
                rhs = function()
                    local current = vim.o.background
                    vim.o.background = (current == "dark") and "light" or "dark"
                    vim.notify("Background -> " .. vim.o.background)
                end, 
                desc = "Toggle Theme Light/Dark" 
            },
            ["<leader>ui"] = { rhs = "<cmd>IBLToggle<cr>", desc = "Toggle Indent Guides" },
            ["<leader>us"] = { rhs = "<cmd>IBLToggleScope<cr>", desc = "Toggle Indent Scope" },
            
            -- Terminal
            ["<leader>tt"] = { rhs = "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
        }
    },
    
    -- LSP keymaps (applied per buffer)
    lsp = {
        n = {
            ["gd"] = { rhs = vim.lsp.buf.definition, desc = "Go to Definition" },
            ["gD"] = { rhs = vim.lsp.buf.declaration, desc = "Go to Declaration" },
            ["gr"] = { rhs = vim.lsp.buf.references, desc = "References" },
            ["gi"] = { rhs = vim.lsp.buf.implementation, desc = "Go to Implementation" },
            ["K"] = { rhs = vim.lsp.buf.hover, desc = "Hover Documentation" },
            ["<C-k>"] = { rhs = vim.lsp.buf.signature_help, desc = "Signature Help" },
            ["<leader>wa"] = { rhs = vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
            ["<leader>wr"] = { rhs = vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
            ["<leader>wl"] = { 
                rhs = function() 
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders())) 
                end, 
                desc = "List Workspace Folders" 
            },
            ["<leader>D"] = { rhs = vim.lsp.buf.type_definition, desc = "Type Definition" },
            ["<leader>rn"] = { rhs = vim.lsp.buf.rename, desc = "Rename Symbol" },
            ["<leader>ca"] = { rhs = vim.lsp.buf.code_action, desc = "Code Action" },
            ["[d"] = { rhs = vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
            ["]d"] = { rhs = vim.diagnostic.goto_next, desc = "Next Diagnostic" },
            ["<leader>dl"] = { rhs = vim.diagnostic.setloclist, desc = "Diagnostic List" },
            ["<leader>f"] = { 
                rhs = function() 
                    vim.lsp.buf.format({ async = true }) 
                end, 
                desc = "Format Document" 
            },
        },
        v = {
            ["<leader>ca"] = { rhs = vim.lsp.buf.code_action, desc = "Code Action" },
            ["<leader>f"] = { 
                rhs = function() 
                    vim.lsp.buf.format({ async = true }) 
                end, 
                desc = "Format Selection" 
            },
        }
    },
    
    -- DAP (Debug Adapter Protocol) keymaps
    dap = {
        n = {
            ["<F5>"] = { rhs = function() require("dap").continue() end, desc = "Continue" },
            ["<F10>"] = { rhs = function() require("dap").step_over() end, desc = "Step Over" },
            ["<F11>"] = { rhs = function() require("dap").step_into() end, desc = "Step Into" },
            ["<F12>"] = { rhs = function() require("dap").step_out() end, desc = "Step Out" },
            ["<leader>db"] = { rhs = function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            ["<leader>dB"] = { 
                rhs = function() 
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) 
                end, 
                desc = "Conditional Breakpoint" 
            },
            ["<leader>dr"] = { rhs = function() require("dap").repl.open() end, desc = "Open REPL" },
            ["<leader>du"] = { rhs = function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
            ["<leader>dl"] = { rhs = function() require("dap").run_last() end, desc = "Run Last" },
        }
    },
    
    -- Testing keymaps
    test = {
        n = {
            ["<leader>tn"] = { rhs = function() require("neotest").run.run() end, desc = "Run Nearest Test" },
            ["<leader>tf"] = { 
                rhs = function() 
                    require("neotest").run.run(vim.fn.expand("%")) 
                end, 
                desc = "Run File Tests" 
            },
            ["<leader>tp"] = { 
                rhs = function() 
                    require("neotest").run.run(vim.uv.cwd()) 
                end, 
                desc = "Run Project Tests" 
            },
            ["<leader>tN"] = { rhs = function() require("neotest").run.run_last() end, desc = "Run Last Test" },
            ["<leader>tS"] = { rhs = function() require("neotest").run.stop() end, desc = "Stop Test" },
            ["<leader>ts"] = { rhs = function() require("neotest").summary.toggle() end, desc = "Test Summary" },
            ["<leader>to"] = { 
                rhs = function() 
                    require("neotest").output.open({ enter = true }) 
                end, 
                desc = "Test Output" 
            },
            ["<leader>tO"] = { 
                rhs = function() 
                    require("neotest").output_panel.toggle() 
                end, 
                desc = "Test Output Panel" 
            },
            ["]t"] = { 
                rhs = function() 
                    require("neotest").jump.next({ status = "failed" }) 
                end, 
                desc = "Next Failed Test" 
            },
            ["[t"] = { 
                rhs = function() 
                    require("neotest").jump.prev({ status = "failed" }) 
                end, 
                desc = "Previous Failed Test" 
            },
        }
    },
    
    -- Linting keymaps
    lint = {
        n = {
            ["<leader>ll"] = { 
                rhs = function() 
                    require("lint").try_lint(nil, { ignore_errors = true }) 
                end, 
                desc = "Run Linter" 
            },
            ["<leader>lq"] = { 
                rhs = function() 
                    vim.diagnostic.reset(nil, 0) 
                end, 
                desc = "Clear Diagnostics" 
            },
        }
    },
    
    -- Language-specific keymaps
    languages = {
        -- Go keymaps
        go = {
            n = {
                ["<leader>gr"] = { rhs = "<cmd>GoRun<cr>", desc = "Go Run" },
                ["<leader>gb"] = { rhs = "<cmd>GoBuild<cr>", desc = "Go Build" },
                ["<leader>gt"] = { rhs = "<cmd>GoTest<cr>", desc = "Go Test Package" },
                ["<leader>gT"] = { rhs = "<cmd>GoTestFunc<cr>", desc = "Go Test Function" },
                ["<leader>gc"] = { rhs = "<cmd>GoCoverage<cr>", desc = "Go Coverage" },
                ["<leader>gi"] = { rhs = "<cmd>GoImpl<cr>", desc = "Go Implement Interface" },
                ["<leader>ga"] = { rhs = "<cmd>GoTagAdd<cr>", desc = "Go Add Struct Tag" },
                ["<leader>gA"] = { rhs = "<cmd>GoTagRm<cr>", desc = "Go Remove Struct Tag" },
                ["<leader>ge"] = { rhs = "<cmd>GoIfErr<cr>", desc = "Go Add If Err" },
            }
        },
        
        -- Rust keymaps
        rust = {
            n = {
                ["<leader>rb"] = { rhs = function() 
                    require("toggleterm.terminal").Terminal:new({ 
                        cmd = "cargo build", 
                        direction = "float", 
                        close_on_exit = false 
                    }):toggle() 
                end, desc = "Cargo Build" },
                ["<leader>rr"] = { rhs = function() 
                    require("toggleterm.terminal").Terminal:new({ 
                        cmd = "cargo run", 
                        direction = "float", 
                        close_on_exit = false 
                    }):toggle() 
                end, desc = "Cargo Run" },
                ["<leader>rt"] = { rhs = function() 
                    require("toggleterm.terminal").Terminal:new({ 
                        cmd = "cargo test", 
                        direction = "float", 
                        close_on_exit = false 
                    }):toggle() 
                end, desc = "Cargo Test" },
                ["<leader>cv"] = { 
                    rhs = function() 
                        require("crates").show_versions_popup() 
                    end, 
                    desc = "Crates: Show Versions" 
                },
                ["<leader>cu"] = { 
                    rhs = function() 
                        require("crates").upgrade_crate() 
                    end, 
                    desc = "Crates: Upgrade" 
                },
                ["<leader>cU"] = { 
                    rhs = function() 
                        require("crates").upgrade_all_crates() 
                    end, 
                    desc = "Crates: Upgrade All" 
                },
            }
        },
        
        -- Python keymaps
        python = {
            n = {
                ["<leader>vv"] = { rhs = "<cmd>VenvSelect<cr>", desc = "Select Python Venv" },
                ["<leader>vV"] = { rhs = "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
                ["<leader>pt"] = { 
                    rhs = function() 
                        require("dap-python").test_method() 
                    end, 
                    desc = "Debug Test Method" 
                },
                ["<leader>pT"] = { 
                    rhs = function() 
                        require("dap-python").test_class() 
                    end, 
                    desc = "Debug Test Class" 
                },
                ["<leader>ps"] = { 
                    rhs = function() 
                        require("dap-python").debug_selection() 
                    end, 
                    desc = "Debug Selection" 
                },
            }
        },
    },
}