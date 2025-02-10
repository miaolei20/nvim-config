return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "onedark",  -- 强制使用 onedark 主题
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          icons_enabled = true,
          globalstatus = true  -- 多窗口状态栏统一
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },  -- 添加诊断显示
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { 
            { "datetime", style = "%H:%M" },  -- 添加时间显示
            "location" 
          },
        },
        extensions = { "nvim-tree", "toggleterm" }  -- 支持常用插件
      })
    end,
  },
}