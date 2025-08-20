return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "bash", "python", "javascript", "typescript",
        "json", "yaml", "toml",
        "markdown", "markdown_inline", "rust",
	"go","gomod","gowork","gosum","gotmpl",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

