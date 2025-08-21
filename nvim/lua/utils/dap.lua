local utils = require("utils")
local map = require("utils.keymap")

local M = {}

M.setup_ui = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    dapui.setup()
    
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
end

M.setup_keymaps = function()
    local keybindings = utils.safe_require("config.keybindings")
    if keybindings and keybindings.dap then
        map.map_group(keybindings.dap)
    else
        M.default_mappings()
    end
end

M.default_mappings = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    local mappings = {
        n = {
            ["<F5>"] = { rhs = dap.continue, desc = "DAP Continue" },
            ["<F10>"] = { rhs = dap.step_over, desc = "DAP Step Over" },
            ["<F11>"] = { rhs = dap.step_into, desc = "DAP Step Into" },
            ["<F12>"] = { rhs = dap.step_out, desc = "DAP Step Out" },
            ["<leader>db"] = { rhs = dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
            ["<leader>dB"] = { 
                rhs = function() 
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) 
                end, 
                desc = "Conditional Breakpoint" 
            },
            ["<leader>dr"] = { rhs = dap.repl.open, desc = "DAP REPL" },
            ["<leader>du"] = { rhs = dapui.toggle, desc = "DAP UI Toggle" },
            ["<leader>dl"] = { rhs = dap.run_last, desc = "Run Last" },
        }
    }
    
    map.map_group(mappings)
end

M.get_codelldb_adapter = function()
    local mason_path = utils.get_mason_path("codelldb")
    if not mason_path then
        return nil
    end
    
    local os_uname = (vim.uv or vim.loop).os_uname()
    local sys = os_uname and os_uname.sysname or ""
    
    local ext = mason_path .. "/extension/"
    local codelldb_path = ext .. "adapter/codelldb"
    local liblldb_path = ext .. (sys == "Darwin" and "lldb/lib/liblldb.dylib" or "lldb/lib/liblldb.so")
    
    if utils.executable(codelldb_path) then
        return require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
    end
    
    return nil
end

M.python_config = function()
    local mason_python = utils.get_mason_path("debugpy")
    if mason_python then
        return mason_python .. "/venv/bin/python"
    end
    return "python"
end

return M