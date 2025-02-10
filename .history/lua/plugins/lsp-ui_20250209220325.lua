return {
  -- ================ 错误提示美化核心插件 ================ --
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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

      -- 快捷键绑定
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "打开/关闭问题面板" })
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "工作区诊断" })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "文档诊断" })
    end
  },

  -- ================ 行内错误提示美化 ================ --
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      -- 禁用默认虚拟文本
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { only_current_line = true },
      })
      
      -- 自定义高亮
      vim.api.nvim_set_hl(0, "LspLinesVirtualText", { link = "Comment" })
    end,
  },

  -- ================ 高级高亮配置 ================ --
  {
    "rebelot/kanagawa.nvim",  -- 示例使用日式主题
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          return {
            -- 自定义诊断高亮
            DiagnosticError = { fg = colors.samuraiRed },
            DiagnosticWarn = { fg = colors.roninYellow },
            DiagnosticInfo = { fg = colors.waveAqua1 },
            DiagnosticHint = { fg = colors.dragonBlue },
            
            -- 浮动窗口样式
            FloatBorder = { fg = colors.fujiWhite },
            NormalFloat = { bg = colors.sumiInk2 },
            
            -- Trouble.nvim 主题适配
            TroubleText = { fg = colors.fujiWhite },
            TroubleCount = { fg = colors.springViolet1, bold = true },
            TroubleNormal = { bg = colors.sumiInk1 },
          }
        end
      })
      vim.cmd.colorscheme("kanagawa")
    end
  },

  -- ================ 悬浮提示优化 ================ --
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded"  -- 圆角边框
        },
        hint_enable = false,  -- 禁用内置提示
        hi_parameter = "Visual",  -- 高亮当前参数
        floating_window = true,
        floating_window_above_cur_line = true,
        toggle_key = "<M-s>"  -- Alt+s 切换签名帮助
      })
    end
  },

  -- ================ 错误快速跳转 ================ --
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
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