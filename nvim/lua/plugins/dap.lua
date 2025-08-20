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
}

