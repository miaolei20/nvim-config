local dap = require("dap")

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
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
        ignoreFailures = false
      },
    },
  },
}

dap.configurations.c = dap.configurations.cpp
