return {
  "kevinhwang91/nvim-ufo",
  version = "*",
  dependencies = {
    "kevinhwang91/promise-async",
    { "nvim-treesitter/nvim-treesitter", optional = true }
  },
  config = function()
    -- 环境检测 --
    local is_gui = vim.fn.has("gui_running") == 1
    local has_treesitter = pcall(require, "nvim-treesitter")

    -- 基础折叠配置 --
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldcolumn = has_treesitter and "2" or "1"
    vim.opt.signcolumn = "auto:1"

    -- 智能图标系统 --
    local fold_icons = {
      gui = {
        open = "",
        close = "",
        separator = " ",
        blank = " "
      },
      term = {
        open = "+",
        close = "~",
        separator = "|",
        blank = " "
      }
    }
    vim.opt.fillchars:append({
      foldopen = is_gui and fold_icons.gui.open or fold_icons.term.open,
      foldclose = is_gui and fold_icons.gui.close or fold_icons.term.close,
      fold = fold_icons.gui.blank,
      foldsep = is_gui and fold_icons.gui.separator or fold_icons.term.separator
    })

    -- 主题适配系统 --
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.cmd.highlight.link("FoldColumn", "SignColumn")
        vim.cmd.highlight("Folded gui=italic")
      end
    })

    -- UFO 核心配置 --
    local ufo = require("ufo")
    ufo.setup({
      provider_selector = function(_, filetype)
        if not has_treesitter then return { "indent" } end
        local strategy = {
          markdown = { "treesitter", "indent" },
          python = { "treesitter", "indent" },
          lua = { "treesitter" },
          _ = { "indent" }
        }
        return strategy[filetype] or strategy._
      end,
      preview = {
        win_config = {
          border = "rounded",
          winblend = vim.wo.winblend,
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "gg",
          jumpBot = "G"
        }
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local suffix = ("  %d "):format(endLnum - lnum)
        local targetWidth = width - vim.fn.strdisplaywidth(suffix)
        local result = {}
        local currentWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if currentWidth + chunkWidth > targetWidth then
            chunkText = truncate(chunkText, targetWidth - currentWidth)
            table.insert(result, { chunkText, chunk[2] })
            break
          end
          table.insert(result, chunk)
          currentWidth = currentWidth + chunkWidth
        end
        table.insert(result, { suffix, "Comment" })
        return result
      end
    })

    -- 安全折叠操作
    local ufo = require("ufo")
    local function safe_call(fn, ...)
      if type(ufo[fn]) == "function" then
        return ufo[fn](...)
      else
        vim.notify("UFO: 不可用的操作 "..fn, vim.log.levels.WARN)
      end
    end

    -- 健壮的快捷鍵设置
    vim.keymap.set("n", "zR", function() safe_call("openAllFolds") end, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", function() safe_call("closeAllFolds") end, { desc = "Close all folds" })
    
    -- 更通用的交互操作
    vim.keymap.set("n", "<leader>z", function()
      if ufo.peekFoldedLinesUnderCursor() then
        safe_call("openFolds")
      else
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold or hover' })

    -- 状态缓存优化 --
    local group = vim.api.nvim_create_augroup("UfoPersist", {})
    vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
      group = group,
      pattern = "*",
      callback = function()
        if vim.bo.filetype ~= "" and ufo.saveFoldStatus then
          ufo.saveFoldStatus()
        end
      end
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
      group = group,
      pattern = "*",
      callback = function()
        if ufo.restoreFoldStatus then
          vim.schedule(ufo.restoreFoldStatus)
        end
      end
    })
  end
}
