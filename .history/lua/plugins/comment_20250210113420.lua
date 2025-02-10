-- 在你的 lazy.nvim 插件配置文件中加入如下配置
return {
  {
    "terrortylor/nvim-comment",
    event = "BufReadPre",  -- 按需加载，可根据自己情况调整
    config = function()
      -- 设置插件时禁用默认映射（默认映射为 normal 模式 "gcc" 和 visual 模式 "gc"）
      require("nvim_comment").setup({
        create_mappings = false,
        -- 如果你需要根据文件类型自动设置注释风格，
        -- 可以配合 treesitter context commentstring 插件使用，例如：
        hook = function()
          if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
            -- 确保你已安装并配置好 nvim-ts-context-commentstring 插件
            require("ts_context_commentstring.internal").update_commentstring()
          end
        end,
      })

      -- 添加 VSCode 风格的快捷键映射：Ctrl+/（在 Vim 中通常写作 <C-_>）
      --
      -- 对于普通模式，调用 nvim_comment.comment() 切换当前行注释
      vim.keymap.set("n", "<C-_>", function()
        require("nvim_comment").comment()
      end, { desc = "切换当前行注释" })

      -- 对于可视模式，传入 true 表示对选中区域操作
      vim.keymap.set("v", "<C-_>", function()
        require("nvim_comment").comment(true)
      end, { desc = "切换选区注释" })
    end,
  },
}
