-- 在保存C/C++文件时自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = function(args)
    -- 获取当前文件的绝对路径
    local filepath = vim.api.nvim_buf_get_name(args.buf)
    -- 指定Mason安装的clang-format路径
    local clang_format = vim.fn.expand("~/.local/share/nvim/mason/bin/clang-format")
    -- 构建格式化命令，--assume-filename确保应用正确的文件类型样式
    local cmd = clang_format .. " --assume-filename=" .. vim.fn.shellescape(filepath)
    -- 执行格式化（保留跳转历史，避免光标位置突变）
    vim.cmd("keepjumps %!" .. cmd)
  end
})
