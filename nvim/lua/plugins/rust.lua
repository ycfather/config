-- lua/plugins/rust.lua
return {
  ---------------------------------------------------------------------------
  -- Rust LSP / Tools（使用 rustaceanvim，替代 rust-tools）
  ---------------------------------------------------------------------------
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    init = function()
      -- === LSP 公共能力 & on_attach ===
      local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd",         vim.lsp.buf.definition,        "Goto Definition")
        map("n", "gr",         vim.lsp.buf.references,        "References")
        map("n", "K",          vim.lsp.buf.hover,             "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename,            "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action,       "Code Action")
        map("n", "[d",         vim.diagnostic.goto_prev,      "Prev Diagnostic")
        map("n", "]d",         vim.diagnostic.goto_next,      "Next Diagnostic")
        map("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "Format")

        -- 仅对 rust-analyzer：保存前自动格式化
        if client.name == "rust_analyzer" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ async = false }) end,
          })
        end
      end

      -- === 健壮的 codelldb 适配器探测 ===
      local function get_codelldb_adapter()
        local os_uname = (vim.uv or vim.loop).os_uname()
        local sys = os_uname and os_uname.sysname or ""

        -- 优先从 mason-registry 读取（兼容不同 API）
        local ok_registry, mason_registry = pcall(require, "mason-registry")
        if ok_registry then
          local ok_pkg, pkg = pcall(mason_registry.get_package, "codelldb")
          if ok_pkg and pkg and (pkg.is_installed == nil or pkg:is_installed()) then
            local install_path
            if type(pkg.get_install_path) == "function" then
              install_path = pkg:get_install_path()
            elseif type(pkg.install_path) == "string" then
              install_path = pkg.install_path
            end
            if install_path then
              local ext = install_path .. "/extension/"
              local codelldb_path = ext .. "adapter/codelldb"
              local liblldb_path = ext .. (sys == "Darwin" and "lldb/lib/liblldb.dylib" or "lldb/lib/liblldb.so")
              return require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
            end
          end
        end

        -- 兜底：按常见默认路径尝试
        local base = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
        local codelldb = base .. "adapter/codelldb"
        local liblldb  = base .. (sys == "Darwin" and "lldb/lib/liblldb.dylib" or "lldb/lib/liblldb.so")
        if vim.fn.executable(codelldb) == 1 then
          return require("rustaceanvim.config").get_codelldb_adapter(codelldb, liblldb)
        end
        -- 找不到就返回 nil（调试暂不可用，但不阻塞 LSP）
        return nil
      end

      -- === rustaceanvim 全局配置（按官方要求放在 g 变量上）===
      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              -- 保存时使用 clippy（不同版本兼容两字段）
              checkOnSave = { command = "clippy" },
              check       = { command = "clippy" },
              inlayHints  = {
                lifetimeElisionHints      = { enable = true, useParameterNames = true },
                bindingModeHints          = { enable = true },
                closureReturnTypeHints    = { enable = "always" },
                expressionAdjustmentHints = { enable = "always" },
                reborrowHints             = { enable = "always" },
                parameterHints            = { enable = true },
                typeHints                 = { enable = true },
              },
            },
          },
        },
        dap   = { adapter = get_codelldb_adapter() },
        tools = { float_win_config = { border = "rounded" } },
      }
    end,
  },

  ---------------------------------------------------------------------------
  -- Cargo.toml 智能补全/版本管理
  ---------------------------------------------------------------------------
  {
    "saecki/crates.nvim",
    event = { "BufReadPost Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local crates = require("crates")
      crates.setup({})

      -- 与 nvim-cmp 集成：在 toml 文件启用 crates 源
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        cmp.setup.filetype("toml", {
          sources = cmp.config.sources(
            { { name = "crates" } },
            { { name = "path" }, { name = "buffer" } }
          ),
        })
      end

      -- 实用按键（仅在 Cargo.toml buffer 有效）
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "toml",
        callback = function(args)
          local bmap = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          bmap("<leader>cv", crates.show_versions_popup, "Crates: show versions")
          bmap("<leader>cu", crates.upgrade_crate,       "Crates: upgrade")
          bmap("<leader>cU", crates.upgrade_all_crates,  "Crates: upgrade all")
        end,
      })
    end,
  },

  -- neotest-rust
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust")({
            args = { "--nocapture" }, -- 查看 println!
          }),
        },
      })
      local nt = require("neotest")
      vim.keymap.set("n","<leader>tn", function() nt.run.run() end,                { desc = "Test Nearest" })
      vim.keymap.set("n","<leader>tf", function() nt.run.run(vim.fn.expand("%")) end, { desc = "Test File" })
      vim.keymap.set("n","<leader>ts", nt.summary.toggle,                           { desc = "Test Summary" })
      vim.keymap.set("n","<leader>to", nt.output.open,                              { desc = "Test Output" })
    end,
  },
}

