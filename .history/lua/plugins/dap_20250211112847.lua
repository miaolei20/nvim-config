-- Lazy.nvim plugin manager configuration
require('lazy').setup({
  -- Other plugins...
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      "williamboman/mason.nvim",           -- Mason 管理安装工具
      "jay-babu/mason-nvim-dap.nvim",       -- Mason 与 nvim-dap 的桥梁
      "rcarriga/nvim-dap-ui",               -- 调试 UI
      "theHamsta/nvim-dap-virtual-text",    -- 调试时在代码旁显示变量信息
      "nvim-neotest/nvim-nio",              -- 用于测试
    },
    config = function()
      local dap = require('dap')
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = 'path/to/OpenDebugAD7', -- Adjust this path
        options = {
          detached = false
        }
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
          },
          args = {},
          runInTerminal = true,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    requires = {'mfussenegger/nvim-dap'},
    config = function()
      require('dapui').setup()
    end
  },
  -- Other plugins...
})

