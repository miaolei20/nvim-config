return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      -- 设置超时时间（单位：毫秒）
      vim.o.timeout = true
      vim.o.timeoutlen = 500  -- 按键提示延迟
    end,
    opts = {
      -- 窗口视觉配置
      window = {
        border = "rounded",  -- 支持 none/single/double/rounded/shadow
        padding = { 1, 2, 1, 2 },  -- 上/右/下/左
        winblend = 10,        -- 窗口透明度（0-100）
      },
      -- 布局优化
      layout = {
        height = { min = 4, max = 12 },
        width = { min = 20, max = 50 },
      },
      -- 忽略无用按键
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua" },
      -- 禁用默认插件映射
      plugins = { spelling = { enabled = false } },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- 核心按键映射
      wk.register({
        ["<leader>"] = {
          -- 增强描述信息
          ["?"] = { "<cmd>WhichKey<CR>", "显示全局快捷键" },
          [","] = { "<cmd>WhichKey ','<CR>", "显示逗号前缀快捷键" },
          -- 补充常用前缀
          g = { name = "Git 操作" },  -- 示例分组
          f = { name = "文件操作" },  -- 自动识别 telescope 等插件映射
        },
      })

      -- 支持浮动窗口本地按键提示
      vim.keymap.set("n", "<leader>??", function()
        wk.show({ mode = "n", prefix = "<leader>", buffer = nil })
      end, { desc = "显示本地缓冲区快捷键" })
    end
  }
}