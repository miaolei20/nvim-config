--- 现代化透明通知系统
--- 路径：~/.config/nvim/lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    -- 模块化配置声明
    local notify = require("notify")
    local colors = require("onedark.palette")

    -- 透明美学参数组
    local opts = {
      stages = "fade",            -- 纯淡入淡出动画
      timeout = 2750,             -- 优化消失动效时长
      fps = 144,                  -- 高刷新率动画
      background_colour = colors.bg0 .. "70",  -- 主色叠加70%透明度
      max_width = math.min(        -- 响应式宽度约束
        math.floor(vim.o.columns * 0.4),
        500
      ),
      render = "compact",         -- 紧凑型布局
      level = vim.log.levels.INFO,
      top_down = false,           -- 底部向上排列

      -- 极简图标系统
      icons = {
        ERROR = "󰅙 ",  -- 错误符号
        WARN = "󰀪 ",   -- 警告符号
        INFO = "󰛨 ",   -- 信息符号
        DEBUG = " ",  -- 调试符号
        TRACE = "󰛨 "   -- 追踪符号
      },

      -- 透明视觉层次
      blend = 20,  -- 混合背景模式
      minimum_width = 50,

      -- 空气感边框
      border_style = {
        { "▗", "FloatBorder" },
        { "▀", "FloatBorder" },
        { "▖", "FloatBorder" },
        { "▌", "FloatBorderTrans" },  -- 半透明侧边框
        { "▙", "FloatBorder" },
        { "▄", "FloatBorder" },
        { "▟", "FloatBorder" },
        { "▐", "FloatBorderTrans" }
      },

      -- 微交互优化
      on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          zindex = 100,
          focusable = false,
          style = "minimal",
          border = "single"
        })
        vim.api.nvim_win_set_blend(win, 15)  -- 窗体透明度叠加
      end
    }

    -- 热重载保护
    if package.loaded["notify"] then
      notify.setup(opts)
    else
      require("notify").setup(opts)
    end

    -- 全局接管通知系统
    vim.notify = setmetatable({}, {
      __call = function(_, msg, level, opts)
        return notify(msg, level, vim.tbl_extend("force", {
          merge_messages = true,  -- 消息聚合
          hide_from_history = string.len(msg) < 30  -- 短消息不保存历史
        }, opts or {}))
      end
    })

    -- 视觉调试模式
    if vim.env.NVIM_DEBUG_NOTIFY then
      vim.notify("透明度："..opts.background_colour:sub(-2).."%", "info", {
        title = "通知系统就绪",
        icon = "󰄛 ",
        on_close = function() print("关闭回调测试") end
      })
    end
  end
}
