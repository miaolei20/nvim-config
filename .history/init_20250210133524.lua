require("core.keymaps")
require("core.basic")
require("core.clang-format")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
-- init.lua 中加载配置
local lsp = require("lsp")
local lsp_ui = require("lsp-ui")

lsp.setup_diagnostic_signs()
lsp.setup_lsp()

-- 加载UI相关插件
require("lazy").setup(lsp_ui.plugins)
