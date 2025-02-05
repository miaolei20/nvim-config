-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
    require("persistence").load()
end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
    require("persistence").select()
end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function()
    require("persistence").load({ last = true })
end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
    require("persistence").stop()
end)
-- keybindings
local opt = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.keymap.set("n", "<C-l>", "<C-w>l", opt)
vim.keymap.set("n", "<C-h>", "<C-w>h", opt)
vim.keymap.set("n", "<C-j>", "<C-w>j", opt)
vim.keymap.set("n", "<C-k>", "<C-w>k", opt)
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)
vim.keymap.set("n", "<Leader>[", "<C-o>", opt)
vim.keymap.set("n", "<Leader>]", "<C-i>", opt)
-- https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })
-- nvimTree
vim.keymap.set("n", "<F3>", ":NvimTreeToggle<CR>", opt)

vim.keymap.set({ "n", "t" }, "<C-t>", "<cmd>ToggleTerm direction=float<CR>", {
    desc = "Toggle floating terminal",
    silent = true,
})
-- 绑定快捷键自动编译运行当前 C++ 文件
vim.keymap.set("n", "<leader>rr", function()
    local file = vim.fn.expand("%") -- 获取当前文件路径
    local cmd = "g++ -std=c++17 -Wall " .. file .. " && ./a.out"
    require("toggleterm").exec(cmd, 1) -- 在终端 ID 1 中执行
end, { desc = "Compile and Run C++" })
--format
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>:lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>:lua vim.lsp.buf.format()<CR>a", { noremap = true, silent = true })
