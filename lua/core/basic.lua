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
set.clipboard="unnamedplus",
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
--一键运行
-- 定义一个编译并运行当前 C/C++ 文件的函数
local function compile_and_run()
  -- 获取当前文件名、无后缀文件名和文件扩展名
  local file = vim.fn.expand('%')
  local file_no_ext = vim.fn.expand('%:r')
  local ext = vim.fn.expand('%:e')
  local cmd = nil

  if ext == "c" then
    -- 对于 C 文件，使用 gcc 编译
    cmd = string.format("gcc %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  elseif ext == "cpp" then
    -- 对于 C++ 文件，使用 g++ 编译
    cmd = string.format("g++ %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  else
    print("当前文件不是 C/C++ 文件！")
    return
  end

  -- 在下方拆分窗口打开终端，并运行命令
  vim.cmd("botright split | resize 10 | terminal " .. cmd)
end

-- 创建一个用户命令 RunCode 调用上面的函数
vim.api.nvim_create_user_command("RunCode", compile_and_run, {})

-- 绑定快捷键
vim.api.nvim_set_keymap("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = true })
