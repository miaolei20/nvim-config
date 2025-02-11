-- 在Lazy插件配置中添加以下代码（通常位于 ~/.config/nvim/lua/plugins.lua 或类似文件）
return {
  {
    event = "BufWritePost",
    "rcarriga/nvim-notify",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 图标支持
      "nvim-lua/plenary.nvim",       -- 异步操作支持
    },
    config = function()
      local palette = require("onedark.palette") -- 如果使用的是onedark pro可能需要调整
      
      -- 配置现代化风格参数
      require("notify").setup({
        -- 动画样式（推荐现代风格）
        stages = {
  fade_in_slide_out = {
    direction = "left", -- 更现代的滑动方向
  }
},
        timeout = 3000,
        fps = 60,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎"
        },
        -- 背景颜色与onedark主题适配
        background_colour = "#282c34", -- onedark背景色
        max_width = math.floor(vim.o.columns * 0.3),
        max_height = math.floor(vim.o.lines * 0.3),
        -- 现代化透明效果
        render = "wrapped-compact",
        level = 2,
        minimum_width = 25,
        -- 颜色配置匹配onedark
        highlight = {
          background = "NotifyBackground",
          title = "Normal",
          border = "NotifyBorder",
          icon = "NotifyIcon"
        },
        
        -- 现代化窗口样式
        timeout = 3000,
        top_down = false,
        -- 自定义颜色覆盖（根据你的onedark版本可能需要调整）
        colors = {
          background = "#282c34",
          title = "#e06c75", -- onedark红色
          border = "#5c6370", -- onedark注释灰
          text = "#abb2bf" -- onedark前景色
        }
      })

      -- 覆盖vim默认通知
      vim.notify = require("notify")
    end,
  }
}