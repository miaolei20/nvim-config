return {
  "kevinhwang91/nvim-ufo",
  version = "*", -- 锁定主版本防止破坏性更新
  dependencies = {
    { "kevinhwang91/promise-async", version = "*" }, -- 显式声明版本
    { "nvim-treesitter/nvim-treesitter", opt = true }, -- 标记为可选依赖
  },
  config = function()
    -- 依赖项安全检查 --
    local has_treesitter, _ = pcall(require, "nvim-treesitter")
    
    -- 全局折叠配置（适配终端类型）--
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldcolumn = has_treesitter and "2" or "1" -- 动态调整列宽
    vim.opt.signcolumn = "auto:1"

    -- 智能选择折叠符号 --
    local fold_icons = {
      open = "",
      close = "",
      separator = " ",
      blank = " "
    }
    -- 终端环境回退到 ASCII
    if vim.fn.has("gui_running") ~= 1 then
  fold_icons = {
    open = "+",
    close = "~",
    separator = "|",
    blank = " "
  }
    end

    vim.opt.fillchars = {
      foldopen = fold_icons.open,
      foldclose = fold_icons.close,
      fold = fold_icons.blank,
      foldsep = fold_icons.separator
    }

    -- 自适应颜色方案 --
    vim.api.nvim_create_autocmd("ColorScheme", { -- 随主题自动更新高亮
      callback = function()
        vim.cmd.highlight("FoldColumn guibg=NONE guifg="..vim.g.colors_name.."Folded")
        vim.cmd.highlight("Folded gui=italic guibg="..vim.g.colors_name.."CursorLine")
      end
    })

    -- 核心 UFO 配置 --
    local ufo = require("ufo")
    ufo.setup({
      provider_selector = function(bufnr, filetype, _)
        -- Lazy load treesitter
        if has_treesitter then
          return (filetype == "markdown" or filetype == "python") 
            and { "treesitter", "indent" } 
            or { "indent" }
        end
        return { "indent" } -- 纯缩进后备方案
      end,
      preview = {
        win_config = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
          winblend = vim.wo.winblend,
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "gg",
          jumpBot = "G",
        },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = "  " .. (endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            if chunkText:len() > 0 then
              table.insert(newVirtText, {chunkText, hlGroup})
            end
            curWidth = curWidth + chunkWidth
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, "MoreMsg"})
        return newVirtText
      end,
    })

    -- 增强型快捷键 --
    local function smart_fold_toggle()
      if ufo.peekFoldedLinesUnderCursor() then
        ufo.openFoldedExceptKinds({ "comment", "imports" })
      else
        vim.lsp.buf.hover()
      end
    end

    vim.keymap.set("n", "zR", ufo.openAllFolds,  { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open non-import folds" })
    vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close class-level folds" })
    vim.keymap.set("n", "K", smart_fold_toggle, { desc = "Smart fold toggle" })
    vim.keymap.set("n", "<leader>ft", "<cmd>UfoToggleFold<CR>", { desc = "[F]old [T]oggle" })

    -- 自动缓存折叠状态 --
    vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
      pattern = "*",
      callback = function()
        local success, _ = pcall(vim.api.nvim_buf_get_var, 0, "ufo_foldinfo")
        if success then ufo.saveFoldStatus() end
      end
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*",
      callback = ufo.restoreFoldStatus,
    })
  end
}
