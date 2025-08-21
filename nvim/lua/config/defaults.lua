return {
    leader = " ",
    localleader = "\\",
    
    -- UI settings
    ui = {
        transparency = false,
        colorscheme = "tokyonight",
        background = "dark",
        icons = true,
        border = "rounded",
        winblend = 0,
    },
    
    -- Editor settings
    editor = {
        number = true,
        relativenumber = true,
        cursorline = true,
        signcolumn = "yes",
        scrolloff = 6,
        sidescrolloff = 8,
        updatetime = 300,
        
        -- Indentation
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        expandtab = true,
        smartindent = true,
    },
    
    -- LSP settings
    lsp = {
        format_on_save = true,
        virtual_text = true,
        inlay_hints = true,
        auto_install = true,
        
        -- Diagnostic settings
        diagnostics = {
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        },
        
        -- Servers to install automatically
        -- Note: rust_analyzer is handled by rustaceanvim, not nvim-lspconfig
        servers = {
            "lua_ls",
            "pyright", 
            "ts_ls",
            "gopls",
            "yamlls",
            "jsonls",
        },
    },
    
    -- DAP settings
    dap = {
        auto_open_ui = true,
        virtual_text = true,
        
        -- Language adapters
        adapters = {
            python = "debugpy",
            rust = "codelldb",
            go = "dlv",
        },
    },
    
    -- Plugin toggles
    features = {
        autopairs = true,
        git_integration = true,
        debugging = true,
        testing = true,
        terminal = true,
        completion = true,
        treesitter = true,
        telescope = true,
        file_explorer = true,
        statusline = true,
        bufferline = true,
        indent_guides = true,
        colorizer = true,
        notify = true,
        which_key = true,
    },
    
    -- Language-specific settings
    languages = {
        lua = {
            enabled = true,
            formatters = { "stylua" },
            linters = { "luacheck" },
        },
        python = {
            enabled = true,
            formatters = { "ruff_format", "black" },
            linters = { "ruff" },
            venv_selector = true,
        },
        javascript = {
            enabled = true,
            formatters = { "prettier" },
            linters = { "eslint" },
        },
        typescript = {
            enabled = true,
            formatters = { "prettier" },
            linters = { "eslint" },
        },
        go = {
            enabled = true,
            formatters = { "gofumpt", "goimports" },
            linters = { "golangcilint" },
        },
        rust = {
            enabled = true,
            formatters = { "rustfmt" },
            linters = { "clippy" },
        },
    },
    
    -- Keymap settings
    keymaps = {
        leader_timeout = 1000,
        which_key_delay = 300,
    },
    
    -- Performance settings
    performance = {
        lazy_load = true,
        startup_time_goal = 50, -- milliseconds
    },
}