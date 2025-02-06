local set = vim.o
set.number = true
set.relativenumber = true
vim.opt.expandtab = true   -- 将 Tab 转换为空格
vim.opt.tabstop = 4        -- Tab 显示为 4 空格
vim.opt.shiftwidth = 4     -- 自动缩进时每级缩进 4 空格
vim.opt.smartindent = true -- 智能缩进
set.termguicolors = true
set.ignorecase = true
set.smartcase = true
-- 在 copy 后高亮
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank({
            timeout = 300,
        })
    end,
})

vim.cmd([[
  highlight RainbowDelimiterRed    guifg=#ff0000
  highlight RainbowDelimiterYellow guifg=#ffff00
  highlight RainbowDelimiterBlue   guifg=#0000ff
  highlight RainbowDelimiterOrange guifg=#ffa500
  highlight RainbowDelimiterGreen  guifg=#00ff00
  highlight RainbowDelimiterViolet guifg=#ee82ee
  highlight RainbowDelimiterCyan   guifg=#00ffff
]])
-- 在 ~/.config/nvim/init.lua 中添加
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt.makeprg = "g++ -std=c++17 -Wall -o %:r % && ./%:r"
  end
})

-- 绑定快捷键（例如 <F5>）
vim.api.nvim_set_keymap("n", "<F5>", ":make<CR>", { noremap = true, silent = true })