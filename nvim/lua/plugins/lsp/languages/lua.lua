local config = require("config.defaults")

-- Check if Lua is enabled
if not config.languages.lua or not config.languages.lua.enabled then
    return {}
end

-- Setup Lua LSP
local lsp_utils = require("utils.lsp")
lsp_utils.setup_server("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { 
                globals = { "vim" } 
            },
            workspace = { 
                checkThirdParty = false,
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
            telemetry = { enable = false },
            hint = { enable = true },
        },
    },
})

-- Return empty plugins array (Lua doesn't need additional plugins)
return {}