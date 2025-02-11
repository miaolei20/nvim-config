return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark",
        transparent = false,
        term_colors = true,
        ending_tildes = false,

        -- 增强语法高亮
        code_style = {
          comments = "italic",
          keywords = "bold",
          functions = "bold",
          strings = "none",
          variables = "italic",
        },

        -- 统一高亮组配置
        highlights = {
          -- Bufferline 集成
          BufferLineBufferSelected = { bg = '#31353f', fg = '#abb2bf', bold = true },
          BufferLineDiagnosticSelected = { fg = '#e5c07b', bg = '#31353f' },
          BufferLineHintSelected = { fg = '#56b6c2', bg = '#31353f' },
          BufferLineSeparatorSelected = { fg = '#31353f', bg = '#31353f' },
          BufferLineCloseButtonSelected = { fg = '#e06c75', bg = '#31353f' },

          -- Lualine 适配
          StatusLine = { bg = '#282c34', fg = '#abb2bf' },
          StatusLineNC = { bg = '#282c34', fg = '#5c6370' }
        },

        -- 插件兼容配置
        diagnostics = {
          background = true,
          undercurl = true,
        }
      })
      
      vim.cmd.colorscheme("onedark")  -- 确保主题加载
    end,
  },
}