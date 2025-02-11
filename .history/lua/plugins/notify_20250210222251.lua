return {
  "rcarriga/nvim-notify",
  event = "UIEnter", -- 单一事件触发
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- 显式声明依赖
    "nvim-lua/plenary.nvim"
  },
  config = function()
    -- 安全获取颜色（不阻塞启动）
    local get_bg_color = function()
      if package.loaded["onedark"] then
        return require("onedark.palette").bg0
      end
      return "#282c34" -- 默认颜色
    end

    -- 精简配置
    require("notify").setup({
      stages = "fade",
      timeout = 2500,
      fps = 30,
      background_colour = get_bg_color(),
      max_width = math.floor(vim.o.columns * 0.25), -- 更窄的宽度
      render = "minimal",
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = ""
      },
      on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          border = "rounded",
          style = "minimal",
        })
        max_history = 50 -- 限制历史记录数量
      end,
    })


-- 使用定时器延迟初始化
vim.defer_fn(function()
  require("notify").setup()
end, 1000) -- 延迟 1 秒
    -- 按需加载覆盖
    local notify_loaded = false
    vim.notify = function(msg, level, opts)
      if not notify_loaded then
        require("notify").setup() -- 确保初始化
        notify_loaded = true
      end
      return require("notify")(msg, level, opts)
    end
  end
}