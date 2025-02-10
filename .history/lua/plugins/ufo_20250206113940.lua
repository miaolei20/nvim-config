return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
      -- 关键选项：禁用初始折叠
    vim.opt.foldlevel = 99        -- 文件打开时不折叠任何代码块
    vim.opt.foldlevelstart = 99   -- 新缓冲区初始折叠级别（99 = 全展开）
    -- 基础配置 -------------------------------------------------------
    vim.opt.foldcolumn = '2'   -- 折叠列宽度为 2，避免被行号覆盖
    vim.opt.fillchars = {
      foldopen = '',
      foldclose = '',
      fold = ' ',              -- ★ 关键：必须设置空格才能显示 Nerd Font 符号
      foldsep = ' ',           -- 折叠线分隔符
    }
    vim.opt.number = true       -- 显示绝对行号
    vim.opt.relativenumber = true  -- 显示相对行号
    vim.opt.signcolumn = 'yes:1'   -- 符号列保留空间

    -- 高亮设置 ------------------------------------------------------
    vim.cmd[[
      highlight FoldColumn guifg=#89b4fa guibg=NONE
      highlight Folded      guibg=#313244 gui=italic
    ]]

    -- UFO 插件主配置 -------------------------------------------------
    local ufo = require('ufo')
    ufo.setup({
      provider_selector = function(_, ft, _)
        return ft == 'python' and { 'treesitter', 'indent' } or { 'indent' }
      end,
      preview = {
        win_config = { border = 'single', winblend = 10 },
        mappings = { scrollU = '<C-u>', scrollD = '<C-d>' }
      }
    })

    -- Treesitter 配置 -------------------------------------------------
    require('nvim-treesitter.configs').setup({
      fold = { enable = true }  -- 启用 Treesitter 折叠
    })

    -- 快捷键映射 ------------------------------------------------------
    local keymap = vim.keymap.set
    keymap('n', 'zR', ufo.openAllFolds)  -- 展开所有折叠
    keymap('n', 'zM', ufo.closeAllFolds) -- 关闭所有折叠
    -- 使用更直观的快捷鍵
    keymap('n', '<leader>z', function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
    end, { desc = 'Peek fold or hover' })
  end
}
