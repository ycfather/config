local M = {}

M.get_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    
    return capabilities
end

M.on_attach = function(client, bufnr)
    -- Use safe_require to avoid circular dependencies
    local utils = require("utils")
    local map = require("utils.keymap")
    local keybindings = utils.safe_require("config.keybindings")
    
    if keybindings and keybindings.lsp then
        map.create_buf_mappings(bufnr, keybindings.lsp)
    else
        M.default_mappings(bufnr)
    end
    
    local config = utils.safe_require("config.defaults")
    if config and config.lsp and config.lsp.format_on_save and client.supports_method("textDocument/formatting") then
        M.setup_format_on_save(bufnr, client)
    end
end

M.default_mappings = function(bufnr)
    local mappings = {
        n = {
            ["gd"] = { rhs = vim.lsp.buf.definition, desc = "Go to Definition" },
            ["gr"] = { rhs = vim.lsp.buf.references, desc = "References" },
            ["K"] = { rhs = vim.lsp.buf.hover, desc = "Hover Documentation" },
            ["<leader>rn"] = { rhs = vim.lsp.buf.rename, desc = "Rename Symbol" },
            ["<leader>ca"] = { rhs = vim.lsp.buf.code_action, desc = "Code Action" },
            ["[d"] = { rhs = vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
            ["]d"] = { rhs = vim.diagnostic.goto_next, desc = "Next Diagnostic" },
            ["<leader>f"] = { 
                rhs = function() vim.lsp.buf.format({ async = true }) end, 
                desc = "Format Document" 
            },
        }
    }
    map.create_buf_mappings(bufnr, mappings)
end

M.setup_format_on_save = function(bufnr, client)
    local utils = require("utils")
    local augroup = utils.create_augroup("LspFormatOnSave_" .. bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ 
                async = false,
                filter = function(c) return c.id == client.id end
            })
        end,
    })
end

M.setup_server = function(server, opts)
    local utils = require("utils")
    opts = opts or {}
    local default_opts = {
        capabilities = M.get_capabilities(),
        on_attach = M.on_attach,
    }
    
    opts = utils.merge_tables(default_opts, opts)
    require("lspconfig")[server].setup(opts)
end

M.conditional_server = function(server, condition, opts)
    if type(condition) == "function" then
        condition = condition()
    end
    
    if condition then
        M.setup_server(server, opts)
    end
end

return M