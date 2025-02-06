return{
     {
    "nvim-tree/nvim-web-devicons", -- 文件图标支持
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          cpp = { icon = "", color = "#519aba", name = "Cpp" },
          py = { icon = "", color = "#ffd845", name = "Python" },
          lua = { icon = "", color = "#51a0cf", name = "Lua" },
          java = { icon = "", color = "#cc3e44", name = "Java" },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-web-devicons" },
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          mode = "buffers", -- 显示缓冲区而非标签页
          numbers = "ordinal",--none -- 不显示编号
          close_command = "bdelete! %d", -- 关闭命令
          right_mouse_command = "bdelete! %d", -- 右键关闭
          left_mouse_command = "buffer %d", -- 左键切换
          middle_mouse_command = nil, -- 中键操作
          indicator = {
            icon = "▎", -- 指示器图标
            style = "underline", -- 指示器样式
          },
          buffer_close_icon = "󰅖", -- 关闭图标（Nerd Font 符号）
          modified_icon = "●", -- 修改状态图标
          close_icon = "", -- 关闭按钮图标
          left_trunc_marker = "", -- 左侧截断标记
          right_trunc_marker = "", -- 右侧截断标记
          max_name_length = 18, -- 文件名最大长度
          max_prefix_length = 15, -- 前缀最大长度
          truncate_names = true, -- 截断过长文件名
          tab_size = 20, -- 标签宽度
          diagnostics = "nvim_lsp", -- 显示 LSP 诊断
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = " File Explorer",
              highlight = "Directory",
              text_align = "left",
              padding = 1,
            },
          },
          color_icons = true, -- 彩色图标
          show_buffer_icons = true, -- 显示图标
          show_buffer_close_icons = true, -- 显示关闭按钮
          show_close_icon = true, -- 显示右侧关闭图标
          show_tab_indicators = true, -- 显示标签指示器
          persist_buffer_sort = true, -- 持久化排序
          separator_style = "slant", -- 分隔符样式：slant | thick | thin
          enforce_regular_tabs = false, -- 强制规则标签
          always_show_bufferline = true, -- 始终显示
          hover = {
            enabled = true, -- 悬停高亮
            delay = 200,
            reveal = { "close" },
          },
          -- 自定义高亮颜色（适配主题）
          highlights = require("catppuccin.groups.integrations.bufferline").get(),
        },
      })
    end,
  },
}
