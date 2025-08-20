return {
  -- 基础依赖
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- which-key：快捷键提示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {}
  },

  -- 加一个轻量通知改良（可选）
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      vim.notify = require("notify")
    end,
  },
}
