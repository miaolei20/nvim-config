return {
  -- 统一图标配置（适配 Nerd Font）
  {
    event = "VeryLazy",
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          cpp = { icon = "󰙲", color = "#61afef", name = "Cpp" },  -- 统一使用 Material 图标
          py = { icon = "", color = "#e5c07b", name = "Python" },
          lua = { icon = "󰢱", color = "#98c379", name = "Lua" },
          java = { icon = "", color = "#e06c75", name = "Java" },
          rs = { icon = "󱘗", color = "#dea584", name = "Rust" },
          md = { icon = "󰓅", color = "#c678dd", name = "Markdown" }  -- 补充更多文件类型
        }
      })
    end
  },

  -- 统一视觉风格的 Bufferline 配置
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-web-devicons",
      "navarasu/onedark.nvim"
    },
    config = function()
      local colors = require("onedark.palette").dark

      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          
          -- 统一图标风格
          indicator = { icon = "▎", style = "underline" },
          modified_icon = "●",
          left_trunc_marker = "",
          right_trunc_marker = "",
          
          -- 布局参数优化
          max_name_length = 18,
          max_prefix_length = 12,
          truncate_names = true,
          tab_size = 20,
          show_buffer_icons = true,
          show_buffer_close_icons = true,  -- 减少视觉干扰
          
          -- 诊断集成（统一颜色）
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icons = { 
              error = "󰅙",  -- 统一图标风格
              warning = "󰀦",
              info = "󰋼"
            }
            local hl = { error = colors.red, warning = colors.yellow, info = colors.cyan }
            return vim.fn.printf("%s %d", icons[level], count), hl[level]
          end,
          
          offsets = {
            { 
              filetype = "NvimTree",
              text = " Explorer",
              text_align = "left",
              padding = 1,
              separator = true  -- 添加分隔符
            }
          },
          
          -- 视觉风格统一
          separator_style = "slant",  -- 可选：slant | padded_slant | thick | thin
          always_show_bufferline = true,
          enforce_regular_tabs = true,
          
          -- 颜色主题深度整合
          highlights = {
            fill = {
              bg = colors.bg0  -- 背景色与主题一致
            },
            background = {
              bg = colors.bg1,
              fg = colors.fg
            },
            buffer_selected = {
              bg = colors.bg2,
              fg = colors.fg,
              bold = true,
              italic = false
            },
            separator = {
              fg = colors.bg2,
              bg = colors.bg0
            },
            close_button = {
              bg = colors.bg1,
              fg = colors.gray
            }
          }
        }
      })
    end
  }
}
