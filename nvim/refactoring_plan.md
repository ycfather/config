# Neovim Configuration Refactoring Plan

## Current State Analysis

### Strengths
- Clean lazy.nvim plugin management
- Language-specific organization
- Good separation between core functionality and plugins
- Comprehensive feature coverage

### Issues Identified

1. **Code Duplication**: Repeated keymap definitions across multiple files
2. **Mixed Concerns**: LSP configs scattered in multiple files
3. **Hard-coded Values**: Magic numbers and strings throughout
4. **No Shared Utilities**: Common helper functions duplicated
5. **Inconsistent Patterns**: Different coding styles across files
6. **No Configuration System**: No centralized config management

## Proposed Refactored Architecture

```
lua/
├── init.lua                    # Entry point
├── core/                       # Core functionality
│   ├── options.lua            # Editor options
│   ├── keymaps.lua           # Global keymaps only
│   ├── autocmds.lua          # Global autocommands
│   └── lazy.lua              # Plugin manager setup
├── config/                    # Configuration management
│   ├── defaults.lua          # Default settings
│   ├── keybindings.lua       # Keymap definitions
│   └── icons.lua             # Icon definitions
├── utils/                     # Shared utilities
│   ├── init.lua              # Utility functions
│   ├── lsp.lua               # LSP helpers
│   ├── dap.lua               # DAP helpers
│   └── keymap.lua            # Keymap helpers
├── plugins/                   # Plugin configurations
│   ├── init.lua              # Plugin loading
│   ├── editor/               # Editor enhancement plugins
│   │   ├── completion.lua
│   │   ├── treesitter.lua
│   │   └── formatting.lua
│   ├── ui/                   # UI plugins
│   │   ├── colorscheme.lua
│   │   ├── statusline.lua
│   │   └── dashboard.lua
│   ├── tools/                # Development tools
│   │   ├── telescope.lua
│   │   ├── git.lua
│   │   └── terminal.lua
│   └── lsp/                  # Language support
│       ├── init.lua          # LSP base setup
│       ├── servers.lua       # Server configurations
│       ├── debugging.lua     # DAP setup
│       └── languages/        # Language-specific configs
│           ├── lua.lua
│           ├── python.lua
│           ├── go.lua
│           └── rust.lua
```

## Detailed Refactoring Plan

### Phase 1: Foundation Layer

#### 1.1 Create Utility System
```lua
-- lua/utils/init.lua
local M = {}

M.has_plugin = function(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

M.safe_require = function(module)
    local ok, result = pcall(require, module)
    return ok and result or nil
end

M.executable = function(name)
    return vim.fn.executable(name) == 1
end

return M
```

#### 1.2 Configuration Management
```lua
-- lua/config/defaults.lua
return {
    leader = " ",
    localleader = "\\",
    
    -- UI settings
    ui = {
        transparency = false,
        colorscheme = "tokyonight",
        icons = true,
    },
    
    -- LSP settings
    lsp = {
        format_on_save = true,
        virtual_text = true,
        inlay_hints = true,
    },
    
    -- Plugin toggles
    features = {
        autopairs = true,
        git_integration = true,
        debugging = true,
        testing = true,
    }
}
```

#### 1.3 Keymap Management
```lua
-- lua/utils/keymap.lua
local M = {}

M.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

M.create_mapping_group = function(prefix, name)
    require("which-key").register({ [prefix] = { name = name } })
end

return M
```

### Phase 2: Plugin Architecture Redesign

#### 2.1 Modular Plugin Loading
```lua
-- lua/plugins/init.lua
local modules = {
    "plugins.editor",
    "plugins.ui", 
    "plugins.tools",
    "plugins.lsp",
}

local specs = {}
for _, module in ipairs(modules) do
    local ok, plugin_specs = pcall(require, module)
    if ok then
        vim.list_extend(specs, plugin_specs)
    end
end

return specs
```

#### 2.2 LSP Abstraction
```lua
-- lua/utils/lsp.lua
local M = {}

M.setup_server = function(server, opts)
    local config = require("config.defaults").lsp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    
    opts = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = M.on_attach,
    }, opts or {})
    
    require("lspconfig")[server].setup(opts)
end

M.on_attach = function(client, bufnr)
    local map = require("utils.keymap").set
    local keymaps = require("config.keybindings").lsp
    
    for mode, mappings in pairs(keymaps) do
        for lhs, mapping in pairs(mappings) do
            map(mode, lhs, mapping.rhs, { 
                buffer = bufnr, 
                desc = mapping.desc 
            })
        end
    end
end

return M
```

### Phase 3: Language-Specific Modules

#### 3.1 Language Configuration Factory
```lua
-- lua/plugins/lsp/languages/init.lua
local M = {}

M.create_language_config = function(name, config)
    return {
        name = name,
        lsp = config.lsp or {},
        dap = config.dap or {},
        formatters = config.formatters or {},
        linters = config.linters or {},
        treesitter = config.treesitter or {},
        plugins = config.plugins or {},
    }
end

return M
```

#### 3.2 Python Configuration Example
```lua
-- lua/plugins/lsp/languages/python.lua
local language = require("plugins.lsp.languages")

return language.create_language_config("python", {
    lsp = {
        servers = { "pyright", "ruff_lsp" },
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                }
            }
        }
    },
    
    formatters = { "black", "ruff_format" },
    linters = { "ruff" },
    
    dap = {
        adapter = "debugpy",
        config = function()
            return require("utils.dap").python_config()
        end
    },
    
    plugins = {
        "linux-cultist/venv-selector.nvim",
    }
})
```

### Phase 4: Enhanced Configuration System

#### 4.1 Dynamic Feature Loading
```lua
-- lua/core/init.lua
local config = require("config.defaults")
local utils = require("utils")

-- Conditionally load features
if config.features.git_integration then
    require("plugins.tools.git")
end

if config.features.debugging then
    require("plugins.lsp.debugging")
end
```

#### 4.2 Plugin Dependency Management
```lua
-- lua/plugins/manager.lua
local M = {}

M.conditional_plugin = function(condition, spec)
    if type(condition) == "function" then
        condition = condition()
    end
    
    return condition and spec or {}
end

M.language_plugin = function(language, spec)
    return M.conditional_plugin(
        function()
            local config = require("config.defaults")
            return config.languages[language] ~= false
        end,
        spec
    )
end

return M
```

## Implementation Benefits

### 1. **Modularity**
- Clear separation of concerns
- Reusable components
- Independent feature loading

### 2. **Maintainability**
- Centralized configuration
- Consistent patterns
- Reduced duplication

### 3. **Extensibility**
- Plugin factory patterns
- Language configuration templates
- Feature toggle system

### 4. **Performance**
- Conditional loading
- Lazy initialization
- Reduced startup time

### 5. **User Experience**
- Consistent keybindings
- Unified configuration API
- Better error handling

## Migration Strategy

1. **Phase 1**: Create utility layer and configuration system
2. **Phase 2**: Refactor existing plugins to use new architecture
3. **Phase 3**: Implement language-specific modules
4. **Phase 4**: Add advanced features and optimizations
5. **Phase 5**: Documentation and testing

This refactoring plan transforms the configuration from a collection of plugin files into a cohesive, modular system that's easier to maintain, extend, and customize.