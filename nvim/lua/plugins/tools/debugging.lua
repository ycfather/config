local utils = require("utils")

return {
    { "mfussenegger/nvim-dap" },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local config = require("config.defaults")
            
            if not config.features.debugging then
                return
            end
            
            local dap_utils = require("utils.dap")
            dap_utils.setup_ui()
            dap_utils.setup_keymaps()
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local config = require("config.defaults")
            
            if config.dap.virtual_text then
                require("nvim-dap-virtual-text").setup()
            end
        end,
    },
}