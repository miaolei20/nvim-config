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

--format
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>:lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>:lua vim.lsp.buf.format()<CR>a", { noremap = true, silent = true })
-- 快速跳转
vim.keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5" })
vim.keymap.set("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", { desc = "Go to buffer 6" })
vim.keymap.set("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", { desc = "Go to buffer 7" })
vim.keymap.set("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", { desc = "Go to buffer 8" })
vim.keymap.set("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", { desc = "Go to buffer 9" })


-- 关闭操作
vim.keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })

