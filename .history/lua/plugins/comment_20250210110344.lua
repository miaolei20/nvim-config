return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      local comment = require("Comment")
      local utils = require("Comment.utils")
      local ft = require("Comment.ft")

      -- ==================== C/C++ 注释规则增强 ==================== --
      -- 设置 C 系语言注释风格
      ft.set("c", { "//%s", "/*%s*/" })
      ft.set("cpp", { "//%s", "/*%s*/" })

      -- 多行注释自动检测优化
      local cpp_ctx = {
        ctx = [[
          ((
            (comment) @_cmt
            (#not-match? @_cmt "^/\\*")
          ) @algo
          (#offset! @algo 0 0 0 0)
        )]],
      }

      -- ==================== 核心配置 ==================== --
      comment.setup({
        -- 基础配置
        padding = true,  -- 注释符号后添加空格
        sticky = true,   -- 保持光标位置
        ignore = "^$",   -- 不注释空行
        
        -- 增强的 C/C++ 注释处理
        pre_hook = function(ctx)
          -- 文件类型特定处理
          if vim.bo.filetype == "cpp" or vim.bo.filetype == "c" then
            -- 检测多行注释需求
            local U = require("Comment.utils")
            local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
            
            -- 智能切换注释类型
            local range = U.get_region(ctx)
            local lines = U.get_lines(range)
            
            if #lines > 1 then
              return vim.bo.commentstring:gsub("$", " ")
            end
          end
        end,

        -- Treesitter 集成（需要安装 nvim-treesitter）
        post_hook = function(ctx)
          if not package.loaded["nvim-treesitter"] then return end
          
          local row = ctx.range.srow - 1
          local col = ctx.range.scol - 1
          local buf = vim.api.nvim_get_current_buf()
          
          -- 跳过已注释区域
          local ts_utils = require("nvim-treesitter.ts_utils")
          local node = ts_utils.get_node_at_cursor()
          if node and node:type() == "comment" then
            return
          end
        end,
      })

      -- ==================== 快捷键优化 ==================== --
      local map = vim.keymap.set
      -- 基础注释
      map({ "n", "v" }, "gcc", function() require("Comment.api").toggle.linewise.current() end)
      map({ "n", "v" }, "gbc", function() require("Comment.api").toggle.blockwise.current() end)

      -- 增强型注释操作
      map("n", "<leader>cf", function()
        require("Comment.api").call("toggle.linewise", "g@$")
        vim.cmd("normal! _")
      end, { desc = "注释函数" })

      map("x", "<leader>c", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
      
      -- C/C++ 专用多行注释
      map("n", "<leader>cm", function()
        local line = vim.api.nvim_get_current_line()
        if line:match("^%s*//") then
          require("Comment.api").toggle.linewise.current()
        else
          vim.cmd("normal! O/*  */")
          vim.cmd("normal! 2hi")
        end
      end, { desc = "智能多行注释" })
    end
  },
}