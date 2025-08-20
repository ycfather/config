return {
  -- 主题（两套可切换）
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark" -- 可与 <leader>ut 配合切换
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },

  -- which-key：键位提示
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- 仪表盘
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "      _   _           _           ",
        " ___ | \\ | | ___   __| | ___ _ __ ",
        "/ _ \\|  \\| |/ _ \\ / _` |/ _ \\ '__|",
        "| (_) | |\\  | (_) | (_| |  __/ |   ",
        " \\___/|_| \\_|\\___/ \\__,_|\\___|_|   ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.config)
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
        globalstatus = true,
      },
    },
  },

  -- Buffer 标签栏
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
      },
    },
  },

  -- 文件树
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      view = { width = 32 },
      renderer = { group_empty = true, highlight_git = true },
      filters = { dotfiles = false },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true },
    },
  },

  -- 模糊搜索
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim",
        build = "make", cond = function() return vim.fn.executable("make") == 1 end },
    },
    config = function()
      local t = require("telescope")
      t.setup({ defaults = { prompt_prefix = "  " } })
      pcall(t.load_extension, "fzf")
    end,
  },

  -- 通知 & 命令行/消息美化
  {
    "rcarriga/nvim-notify",
    opts = { stages = "fade" },
    init = function() vim.notify = require("notify") end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = { progress = { enabled = true } },
      presets = { command_palette = true, long_message_to_split = true },
    },
  },

  -- 对话框选择器 UI 美化（:LspInfo 等）
  { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },

  -- 缩进线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local ibl   = require("ibl")
      local hooks = require("ibl.hooks")

      -- 1) 定义多层级颜色（可按主题喜好调整）
      local colors = { "#E06C75", "#E5C07B", "#98C379", "#61AFEF", "#C678DD", "#56B6C2" }
      
      -- 在每次 colorscheme 之后重新定义高亮组
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for i, c in ipairs(colors) do
          vim.api.nvim_set_hl(0, "IndentLevel"..i, { fg = c, nocombine = true })
        end
        vim.api.nvim_set_hl(0, "IndentScope", { fg = "#7f8490", nocombine = true })
      end)

      -- 2) 返回 ibl 配置
      return {
        -- “粗竖线”：用 U+2503 ┃；想更细就用 "│"；想虚线可用 "┆" / "┇"
        indent = {
          -- 统一用粗竖线
          char = "┆",
          -- 如果想每一层不同字符，改成：
          -- char = { "┃", "│", "┇", "┆", "┃", "│" },
          highlight = {
            "IndentLevel1", "IndentLevel2", "IndentLevel3",
            "IndentLevel4", "IndentLevel5", "IndentLevel6",
          },
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
          highlight = "IndentScope",
        },
        whitespace = { remove_blankline_trail = true },
        exclude = {
          filetypes = {
            "help", "alpha", "dashboard", "neo-tree", "NvimTree",
            "Trouble", "lazy", "mason", "notify", "toggleterm",
          },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        },
      }
    end,
    init = function()
      -- 3) 快捷键：切换缩进线/作用域线
      -- ibl 提供命令 :IBLToggle 和 :IBLToggleScope
      vim.keymap.set("n", "<leader>ui", ":IBLToggle<CR>", { desc = "Toggle Indent Guides" })
      vim.keymap.set("n", "<leader>us", ":IBLToggleScope<CR>", { desc = "Toggle Indent Scope" })
    end,
  },

  -- 滚动条
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {},
  },

  -- Git 行内标记
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { current_line_blame = true },
  },

  -- 彩色括号
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- 使用 treesitter 自动生效
    end,
  },

  -- 颜色值高亮（#RRGGBB）
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", opts = { user_default_options = { names = false } } },

}
