return {
  -- 优化图标配置
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          cpp = { icon = "", color = "#61afef", name = "Cpp" },
          py = { icon = "", color = "#e5c07b", name = "Python" },
          lua = { icon = "", color = "#98c379", name = "Lua" },
          java = { icon = "", color = "#e06c75", name = "Java" },
          ["rs"] = { icon = "", color = "#dea584", name = "Rust" }  -- 补充缺失的常见文件类型
        }
      })
    end
  },
  
  -- 精简 bufferline 配置
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-web-devicons",
      "navarasu/onedark.nvim"
    },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          
          -- 视觉元素优化
          indicator = { icon = "▎", style = "underline" },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          
          -- 布局参数调优
          max_name_length = 20,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 22,
          
          -- 诊断集成
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icons = { error = " ", warning = " ", info = " "}
            return " " .. (icons[level:lower()] or "") .. count
          end,
          
          offsets = {
            { filetype = "NvimTree", text = " Explorer", text_align = "left", padding = 1 }
          },
          
          -- 视觉风格统一
          separator_style = "slant",
          always_show_bufferline = true
        }
      })
    end
  }
}