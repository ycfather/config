vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- 基本
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "No Highlight" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",  { desc = "Help" })

-- 文件树
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File Explorer" })

-- UI 切换
map("n", "<leader>ut", function() -- 切换浅/深色主题
    local current = vim.o.background
    vim.o.background = (current == "dark") and "light" or "dark"
    vim.notify("Background -> " .. vim.o.background)
end, { desc = "Toggle Theme Light/Dark" })

-- 依赖已安装的 toggleterm
local ok, Terminal = pcall(function() return require("toggleterm.terminal").Terminal end)
if ok then
    local function term_cmd(cmd)
        return function()
            Terminal:new({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
        end
    end
    vim.keymap.set("n","<leader>rb", term_cmd("cargo build"), { desc = "Cargo Build" })
    vim.keymap.set("n","<leader>rr", term_cmd("cargo run"),   { desc = "Cargo Run" })
    vim.keymap.set("n","<leader>rt", term_cmd("cargo test"),  { desc = "Cargo Test" })
end

