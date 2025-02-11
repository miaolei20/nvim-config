return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "williamboman/mason.nvim",           -- Mason 管理安装工具
      "jay-babu/mason-nvim-dap.nvim",       -- Mason 与 nvim-dap 的桥梁
      "rcarriga/nvim-dap-ui",               -- 调试 UI
      "theHamsta/nvim-dap-virtual-text",    -- 调试时在代码旁显示变量信息
      "nvim-neotest/nvim-nio",              -- 用于测试
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      ----------------------------
      -- 1. 初始化 UI 与虚拟文本
      ----------------------------
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
        },
        layouts = {
          {
            elements = {
              "scopes",
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = { "repl", "console" },
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
            step_back = "⏪",
            run_last = "↻",
            terminate = "⏹",
          },
        },
      })

      require("nvim-dap-virtual-text").setup()

      ----------------------------------------
      -- 2. 配置 C/C++ 调试适配器（cppdbg）
      ----------------------------------------
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        -- Mason 默认安装路径下的 OpenDebugAD7 可执行文件
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "Enable GDB pretty printing",
              ignoreFailures = false,
            },
          },
        },
      }
      -- C 与 C++ 使用相同的配置
      dap.configurations.c = dap.configurations.cpp

      ------------------------------------------------
      -- 3. 自动控制 UI 打开与关闭以及自定义图标
      ------------------------------------------------
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "⭐", texthl = "", linehl = "", numhl = "" })
    end,
  },
}