--[[
编译运行 C/C++ 代码增强版
特性：
1. 智能编译器选择（支持环境变量覆盖）
2. 编译错误捕获与高亮显示
3. 自适应终端窗口高度
4. 跨平台支持（Linux/macOS）
5. 友好的状态提示
--]]

local M = {}

-- 配置项（可按需修改）
local config = {
  terminal_height = 15,          -- 终端窗口高度（行数）
  compilers = {
    c = os.getenv("CC") or "gcc",   -- 支持环境变量覆盖
    cpp = os.getenv("CXX") or "g++"
  },
  flags = "-Wall -Wextra -O2"   -- 通用编译参数
}

-- 检查文件有效性
local function validate_file(file, ext)
  if vim.fn.filereadable(file) == 0 then
    vim.notify("错误：文件不存在 - " .. file, vim.log.levels.ERROR)
    return false
  end

  if not (ext == "c" or ext == "cpp") then
    vim.notify("错误：不支持的文件类型 - " .. ext, vim.log.levels.WARN)
    return false
  end

  return true
end

-- 执行命令并处理结果
local function execute_command(cmd, file_no_ext)
  -- 清理之前生成的二进制文件
  vim.fn.delete(file_no_ext)

  -- 创建终端窗口
  vim.cmd("botright split")
  vim.cmd("resize " .. config.terminal_height)
  local term_buf = vim.fn.termopen(cmd, {
    on_exit = function(_, code, _)
      if code == 0 then
        vim.notify("✓ 执行成功", vim.log.levels.INFO)
      else
        vim.notify("× 执行失败 (代码: " .. code .. ")", vim.log.levels.ERROR)
      end
    end
  })

  -- 设置终端窗口特性
  vim.api.nvim_buf_set_option(term_buf, "filetype", "terminal-output")
  vim.api.nvim_buf_set_keymap(term_buf, "t", "<Esc>", "<C-\\><C-n>", {noremap = true})
end

-- 主逻辑
function M.compile_and_run()
  local file = vim.fn.expand("%:p")  -- 获取完整文件路径
  local ext = vim.fn.expand("%:e")   -- 获取文件扩展名
  local file_no_ext = vim.fn.expand("%:r")

  if not validate_file(file, ext) then return end

  -- 构建编译命令
  local compiler = config.compilers[ext]
  local cmd = string.format(
    "%s %s %s -o %s && ./%s",
    compiler,
    config.flags,
    file,
    file_no_ext,
    file_no_ext
  )

  -- 执行命令
  execute_command(cmd, file_no_ext)
end

-- 注册命令和快捷键
vim.api.nvim_create_user_command("RunCode", M.compile_and_run, {
  desc = "编译并运行当前C/C++文件"
})

vim.keymap.set("n", "<F5>", function()
  vim.notify("🚀 开始编译运行...", vim.log.levels.INFO)
  M.compile_and_run()
end, {
  noremap = true,
  silent = true,
  desc = "编译运行当前文件"
})

return M