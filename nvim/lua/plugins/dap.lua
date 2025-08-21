-- lua/plugins/dap.lua
return {
    { "mfussenegger/nvim-dap" },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

            -- 常用按键
            local map = vim.keymap.set
            map("n","<F5>",  dap.continue,          { desc = "DAP Continue" })
            map("n","<F10>", dap.step_over,         { desc = "DAP Step Over" })
            map("n","<F11>", dap.step_into,         { desc = "DAP Step Into" })
            map("n","<F12>", dap.step_out,          { desc = "DAP Step Out" })
            map("n","<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
            map("n","<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
                { desc = "DAP Conditional Breakpoint" })
            map("n","<leader>dr", dap.repl.open,     { desc = "DAP REPL" })
            map("n","<leader>du", dapui.toggle,      { desc = "DAP UI Toggle" })
        end,
    },

    { "theHamsta/nvim-dap-virtual-text", config = true },
    
    {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            -- 从 Mason 读取 debugpy 可执行路径（常见默认路径如下）
            local mason = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
            if vim.fn.executable(mason) ~= 1 then
                -- 回退到系统 python，要求你已 pip 安装 debugpy
                mason = "python"
            end
            require("dap-python").setup(mason)

            -- 常用快捷键（与你现有 DAP 保持风格一致）
            local map = vim.keymap.set
            map("n", "<leader>pt", function() require("dap-python").test_method() end, { desc = "DAP Py: debug test method" })
            map("n", "<leader>pT", function() require("dap-python").test_class()  end, { desc = "DAP Py: debug test class" })
            map("n", "<leader>ps", function() require("dap-python").debug_selection() end, { desc = "DAP Py: debug selection" })
        end,
    },
}

