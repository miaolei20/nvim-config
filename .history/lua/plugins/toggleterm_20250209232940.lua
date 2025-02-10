return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      -- 定义带不同参数的快捷键，直接集成到keys表中
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal id=1<cr>", desc = "水平终端" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical id=2<cr>",   desc = "垂直终端" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",          desc = "浮动终端" },
      -- 添加终端模式切换快捷键（需要Neovim 0.7+）
      { [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" },        desc = "切换终端" }
    },
    config = function()
      require("toggleterm").setup({
        -- 终端尺寸智能计算
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        -- 保持窗口尺寸变化
        persist_size = true,
        -- 默认打开方向
        direction = "float",
        -- 终端关闭时自动隐藏
        close_on_exit = true,
        -- 自动滚动到底部
        auto_scroll = true,
        -- 浮动窗口配置
        float_opts = {
          border = "rounded",
          winblend = 15,  -- 增强透明度效果
          width = function() return math.min(120, vim.o.columns * 0.9) end,
          height = function() return math.min(30, vim.o.lines * 0.85) end,
        },
        -- 高亮配置
        highlights = {
          FloatBorder = { link = "NormalFloat" },  -- 更自然的高亮链接
        },
        -- 使用当前shell配置
        shell = vim.o.shell,
        -- 增强型终端 shading
        shade_terminals = true,
        -- 自定义终端启动命令（可选）
        -- start_in_insert = true,
        -- persist_mode = true
      })

      -- 自定义终端自动命令（示例：进入终端时自动切换到插入模式）
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          vim.cmd.startinsert()
        end
      })
    end
  }
}

