-- 在 plugins/notify.lua 或 plugins/extras/notify.lua 中添加
return {
  "rcarriga/nvim-notify",
  event = { "VeryLazy", "UIEnter" }, -- 双重保险
  config = function()
    local palette = require("onedark.palette") -- 确保你的主题模块路径正确
    require("notify").setup({
      -- 现代化动画效果
      stages = "fade_in_slide_out",
      timeout = 3000,
      fps = 60,
      -- OneDark 主题适配
      background_colour = palette.bg0,
      max_width = math.floor(vim.o.columns * 0.3),
      render = "compact",
      -- 现代化样式调整
      level = 2,
      top_down = false,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎"
      },
      -- 颜色配置（适配 OneDark）
      highlight = {
        background = "NotifyBackground",
        title = "NotifyTitle",
        border = "NotifyBorder",
        icon = "NotifyIcon"
      },
      -- 现代化渐隐效果
      on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          border = "rounded",
          style = "minimal",
        })
      end,
    })

    -- 覆盖默认通知系统
    vim.notify = require("notify")
    
    -- 可选：预发测试通知（测试后可注释）
    -- vim.notify("NVIM-NOTIFY 配置成功！", "info", { title = "通知系统" })
  end
}
