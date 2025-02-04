-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
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
-- lsp 快捷键设置
 -- rename
 vim.keymap.set("n", "<leader>r", ":lua vim.lsp.buf.rename<CR>", opt)
 -- code action
 vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>", opt)
 -- go to definition
 vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opt)
 -- show hover
 vim.keymap.set("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opt)
 -- format
 vim.keymap.set("n", "<leader>=", ":lua vim.lsp.buf.format { async = true }<CR>", opt)
-- nvimTree
vim.keymap.set('n', '<F3>', ':NvimTreeToggle<CR>', opt)
