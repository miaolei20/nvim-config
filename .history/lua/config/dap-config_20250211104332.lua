--[[ 
  nvim-dap 配置：C/C++ 调试支持（含交互式输入）及简单美化
  前提条件：
    1. 已通过 mason 安装 codelldb （mason 包名通常为 "codelldb"）
    2. 已安装 nvim-dap 和 nvim-dap-ui 插件（可通过 lazy.nvim 管理）
  
  使用方法：
    - 在 init.lua 中加入： require("dap-config")
    - 编译好 C/C++ 程序后，调试时会提示输入可执行文件路径
    - 调试会话中如果程序需要输入数据，调试终端会在右侧垂直分屏中打开，支持交互输入
--]]

local dap_status, dap = pcall(require, "dap")
if not dap_status then
  vim.notify("nvim-dap 未安装！", vim.log.levels.ERROR)
  return
end

-- 配置 codelldb 调试适配器（请确保 mason 已安装并下载了 codelldb）
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- 如果 mason 安装了 codelldb，可通过 mason 获取路径，或者将 "codelldb" 命令放在 PATH 中
    command = "codelldb", 
    args = {"--port", "${port}"},
  }
}

-- 针对 C++ 的调试配置
dap.configurations.cpp = {
  {
    name = "Launch file",       -- 调试会话名称
    type = "codelldb",          -- 使用上面配置的适配器
    request = "launch",         -- 启动调试
    program = function()
      -- 自动提示输入可执行文件路径（建议先编译好程序再启动调试）
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}', -- 当前工作目录
    stopOnEntry = false,        -- 不在入口处暂停
    runInTerminal = true,       -- 必须为 true，才能支持交互式终端输入
  },
}

-- 如果需要 C 语言也支持，直接复用 C++ 配置
dap.configurations.c = dap.configurations.cpp

-- 设置调试会话使用的终端窗口命令：这里使用垂直分屏打开一个 50 列宽的终端窗口
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

---------------------------------------------------------------------
-- 以下为 nvim-dap-ui 的简单美化配置（非必须，但推荐使用）
local dapui_status, dapui = pcall(require, "dapui")
if dapui_status then
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      -- 可以根据个人习惯修改快捷键
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
    },
    -- 布局配置：左侧显示变量、右侧显示堆栈等信息
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.5 },
          { id = "breakpoints", size = 0.2 },
          { id = "stacks", size = 0.2 },
          { id = "watches", size = 0.1 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom",
      },
    },
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "⏸",
        play = "▶",
        step_into = "⏎",
        step_over = "⏭",
        step_out = "⏮",
        step_back = "↩",
        run_last = "↻",
        terminate = "⏹",
      },
    },
  })

  -- 自动打开/关闭 dap-ui 面板
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

---------------------------------------------------------------------
-- 可选：为常用调试操作绑定快捷键（你可以根据需要自定义或放到自己的 keymap 配置中）
vim.fn.sign_define("DapBreakpoint", {text = "●", texthl = "", linehl = "", numhl = ""})
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>b', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', '<Leader>B', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)

-- 提示信息：可通过 :help nvim-dap 查看详细文档
vim.notify("nvim-dap 配置加载成功！", vim.log.levels.INFO)
