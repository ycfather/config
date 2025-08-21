local opt = vim.opt

-- 行号与光标
opt.number = true         -- 绝对行号
opt.relativenumber = true -- 相对行号
opt.cursorline = true     -- 高亮当前行
opt.signcolumn = "yes"    -- 永远显示诊断标记栏

-- 颜色与渲染
opt.termguicolors = true
opt.scrolloff = 6
opt.sidescrolloff = 8

-- 窗口/分屏
opt.splitright = true
opt.splitbelow = true

-- 性能体验
opt.updatetime = 300

-- Tab / 缩进设置（默认 4 空格）
opt.tabstop = 4        -- 一个 Tab 显示为 4 个空格
opt.shiftwidth = 4     -- 缩进操作使用 4 个空格
opt.softtabstop = 4    -- 插入模式 Tab = 4 空格
opt.expandtab = true   -- Tab 转为空格
opt.smartindent = true -- 智能缩进
