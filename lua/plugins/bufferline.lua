return {
  -- 优化后的图标配色方案（适配 Onedark）
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          cpp = { icon = "", color = "#61afef", name = "Cpp" },    -- Onedark 蓝色
          py = { icon = "", color = "#e5c07b", name = "Python" },  -- Onedark 浅黄
          lua = { icon = "", color = "#98c379", name = "Lua" },    -- Onedark 绿色
          java = { icon = "", color = "#e06c75", name = "Java" },  -- Onedark 红色
        }
      })
    end
  },
  
  -- 重构后的 bufferline 配置
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-web-devicons",
      "navarasu/onedark.nvim"  -- 切换主题依赖
    },
    config = function()
      vim.cmd.colorscheme("onedark")  -- 应用新主题

      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          
          -- 图标风格优化
          indicator = { icon = "▎", style = "underline" },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          
          -- 显示参数调优
          max_name_length = 20,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 22,
          
          -- 诊断指示器优化
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icons = { error = " ", warning = " ", info = " "}
            return " " .. (icons[level:lower()] or "") .. count
          end,
          
          offsets = {
            { filetype = "NvimTree", text = " Explorer", text_align = "left", padding = 1 }
          },
          
          -- 视觉风格适配 Onedark
          separator_style = "slant",
          always_show_bufferline = true,
          
          -- 颜色系统深度整合
          highlights = require("onedark").setup({
            highlights = {
              BufferLineBufferSelected = { bg = '#31353f', fg = '#abb2bf', bold = true },
              BufferLineDiagnosticSelected = { bg = '#31353f', fg = '#e5c07b', bold = true },
              BufferLineHintSelected = { bg = '#31353f', fg = '#56b6c2', bold = true }
            }
          })
        }
      })
    end
  }
}
