-- 在你的 Lazy 插件配置文件中添加如下配置（如：lua/plugins/comment.lua）
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('Comment').setup({
      -- 启用 Tree-sitter 支持
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      
      -- 针对不同模式的快捷键配置
      mappings = {
        -- VS Code 风格的注释快捷键
        basic = true,    -- 启用基础快捷键 (gcc/gbc)
        extra = true,   -- 启用扩展快捷键
        extended = true -- 启用增强模式
      },
      
      -- 自定义 C/C++ 注释样式（可选）
      padding = true,
      sticky = true,
      ignore = nil,
      
      -- 适用于 Visual/Line 模式
      toggler = {
        line = '<C-_>',      -- Ctrl+/ 单行注释，需要终端支持
        block = '<leader>cb' -- 默认块注释
      },
      
      -- 适用于操作符模式
      opleader = {
        line = '<C-_>',
        block = '<leader>cb'
      },
      
      -- 扩展模式
      extra = {
        above = '<leader>cO',
        below = '<leader>co',
        eol = '<leader>cA'
      },
    })

    -- 如果终端支持，手动绑定 Ctrl+/ 快捷键组合
    -- 注意：某些终端需要手动设置才能识别 Ctrl+/ （对应 <C-_>）
    vim.api.nvim_set_keymap('n', '<C-/>', 'gcc', { noremap = false })
    vim.api.nvim_set_keymap('v', '<C-/>', 'gc',  { noremap = false })
  end,
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- 基于上下文的注释
  }
}
