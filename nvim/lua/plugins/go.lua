-- ~/.config/nvim/lua/plugins/go.lua
return {
  ---------------------------------------------------------------------------
  -- Go 语言工具：构建/测试/覆盖率/代码生成/格式化（不接管 LSP）
  ---------------------------------------------------------------------------
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = { "ray-x/guihua.lua" }, -- 浮窗/预览依赖
    build = ':lua require("go.install").update_all()', -- 可选：自动安装 go 工具
    config = function()
      require("go").setup({
        -- 不接管 LSP（仍由你的 lspconfig + gopls 负责）
        lsp_cfg = false,
        lsp_keymaps = false,

        -- 格式化：保存时用 goimports + gofumpt
        gofmt = "gofumpt",       -- 使用 gofumpt 规则
        goimports = "goimports", -- 保存时自动组织 import
        tag_options = "json=omitempty", -- :GoTagAdd 的默认行为

        trouble = false,
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
        },
        dap_debug = false, -- 调试交给 nvim-dap-go
      })

      -- 保存时格式化（goimports + gofumpt）
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          -- 先组织 import，再格式化
          require("go.format").goimport()
        end,
      })

      -- 常用键位（可改到你的 keymaps.lua）
      local map = vim.keymap.set
      map("n", "<leader>gr", "<cmd>GoRun<CR>",        { desc = "Go: run" })
      map("n", "<leader>gb", "<cmd>GoBuild<CR>",      { desc = "Go: build" })
      map("n", "<leader>gt", "<cmd>GoTest<CR>",       { desc = "Go: test (pkg)" })
      map("n", "<leader>gT", "<cmd>GoTestFunc<CR>",   { desc = "Go: test (func)" })
      map("n", "<leader>gc", "<cmd>GoCoverage<CR>",   { desc = "Go: coverage" })
      map("n", "<leader>gi", "<cmd>GoImpl<CR>",       { desc = "Go: impl interface" })
      map("n", "<leader>ga", "<cmd>GoTagAdd<CR>",     { desc = "Go: add struct tag" })
      map("n", "<leader>gA", "<cmd>GoTagRm<CR>",      { desc = "Go: remove struct tag" })
      map("n", "<leader>ge", "<cmd>GoIfErr<CR>",      { desc = "Go: add if err" })
    end,
  },

  ---------------------------------------------------------------------------
  -- 调试：dlv + nvim-dap-go（配合你的 dap / dap-ui）
  ---------------------------------------------------------------------------
  {
    "leoluz/nvim-dap-go",
    ft = { "go" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()
      local dap = require("dap")
      local dapgo = require("dap-go")
      local map = vim.keymap.set
      map("n", "<F5>",  dap.continue, { desc = "DAP Continue" })
      map("n", "<leader>dt", dapgo.debug_test, { desc = "DAP Go: debug nearest test" })
      map("n", "<leader>dT", function() dapgo.debug_test({ breakpoints = true }) end,
        { desc = "DAP Go: debug nearest test (with bps)" })
      -- 替换成 run_last（调试上次运行的程序）
      map("n", "<leader>dl", dap.run_last, { desc = "DAP: debug last run" })
    end,
  },

  ---------------------------------------------------------------------------
  -- 测试：neotest-go（如果你已用 neotest，可把适配器合并到原 neotest 配置里）
  ---------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    ft = { "go" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-race" },
          }),
        },
      })
      local nt = require("neotest")
      vim.keymap.set("n", "<leader>tn", function() nt.run.run() end,                  { desc = "Test Nearest" })
      vim.keymap.set("n", "<leader>tf", function() nt.run.run(vim.fn.expand("%")) end,{ desc = "Test File" })
      vim.keymap.set("n", "<leader>ts", nt.summary.toggle,                             { desc = "Test Summary" })
      vim.keymap.set("n", "<leader>to", nt.output.open,                                { desc = "Test Output" })
    end,
  },

  ---------------------------------------------------------------------------
  -- Lint：golangci-lint（建议安装），保存后触发
  ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    ft = { "go" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { go = { "golangcilint" } }

      local function lint_go()
        -- 仅在项目根存在配置时才跑，避免全局误报
        local cfg = vim.fn.findfile(".golangci.yaml", ".;") ~= "" or
                    vim.fn.findfile(".golangci.yml",  ".;") ~= "" or
                    vim.fn.findfile(".golangci.toml", ".;") ~= "" or
                    vim.fn.findfile(".golangci.json", ".;") ~= ""
        if cfg then lint.try_lint() end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        pattern = "*.go",
        callback = lint_go,
      })

      vim.keymap.set("n", "<leader>ll", function() require("lint").try_lint() end,
        { desc = "Lint: golangci-lint" })
    end,
  },
}

