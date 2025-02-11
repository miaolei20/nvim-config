-- Lazy.nvim plugin manager configuratio
  -- Other plugins...
  return
  {
    'mfussenegger/nvim-dap',
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

-- Key mappings for DAP
vim.fn.nvim_set_keymap('n', '<F5>', '<Cmd>lua require\'dap\'.continue()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<F10>', '<Cmd>lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<F11>', '<Cmd>lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<F12>', '<Cmd>lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<Leader>b', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<Leader>dr', '<Cmd>lua require\'dap\'.repl.open()<CR>', { noremap = true, silent = true })
vim.fn.nvim_set_keymap('n', '<Leader>du', '<Cmd>lua require\'dapui\'.toggle()<CR>', { noremap = true, silent = true })