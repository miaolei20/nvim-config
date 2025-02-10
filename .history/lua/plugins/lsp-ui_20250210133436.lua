local M = {}

-- 主题配置（合并到公共模块）
function M.setup_theme()
  require("onedark").setup({
    style = 'dark',
    custom_highlights = function(colors)
      return {
        DiagnosticError = { fg = colors.red },
        DiagnosticWarn = { fg = colors.yellow },
        DiagnosticInfo = { fg = colors.cyan },
        DiagnosticHint = { fg = colors.blue },
        FloatBorder = { fg = colors.gray },
        NormalFloat = { bg = colors.bg2 },
        TroubleText = { fg = colors.fg },
        TroubleCount = { fg = colors.purple, bold = true },
        TroubleNormal = { bg = colors.bg0 },
      }
    end
  })
  vim.cmd.colorscheme("onedark")
end

-- 错误提示统一配置
function M.setup_diagnostics()
  require("trouble").setup({
        position = "bottom",  -- 面板位置
        height = 12,          -- 面板高度
        icons = true,
        use_diagnostic_signs = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = { "<cr>", "<tab>" },
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = { "o" },
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = { "zM", "zm" },
          open_folds = { "zR", "zr" },
          toggle_fold = { "zA", "za" },
          previous = "k",
          next = "j",
        },
        indent_lines = false,
        auto_preview = true,
        auto_fold = false,
        auto_jump = { "lsp_definitions" },
        include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions"  },
        signs = {
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "﫠"
        },
        fold_closed = "",
        fold_open = "",
      })

  require("lsp_lines").setup()
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { only_current_line = true },
  })
  vim.api.nvim_set_hl(0, "LspLinesVirtualText", { link = "Comment" })
end

-- 插件配置聚合
M.plugins = {
  { "folke/trouble.nvim", config = M.setup_diagnostics },
  { "navarasu/onedark.nvim", priority = 1000, config = M.setup_theme },
  { "ray-x/lsp_signature.nvim", config = require("lsp").common_on_attach },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({
        signs = false, -- 禁用自带图标
        keywords = {
          FIX = { icon = " ", color = "error" },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning" },
          PERF = { icon = " ", color = "default" },
          NOTE = { icon = "󰎞 ", color = "hint" },
        },
        highlight = {
          pattern = [[.*<(KEYWORDS)\s*:]], -- 匹配模式
          comments_only = false,           -- 全文件扫描
        }
      })
    end
  }
}

return M