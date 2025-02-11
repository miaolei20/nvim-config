{
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text"
  },
  config = function()
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()
  end
}
