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
}
}