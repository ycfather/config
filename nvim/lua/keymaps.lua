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
