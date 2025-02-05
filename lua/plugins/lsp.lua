return {
  -- LSP 配置（强化版）
  {
      event = "VeryLazy",
    "neovim/nvim-lspconfig",
    dependencies ={  "onsails/lspkind.nvim",},
    config = function()
      require("lspconfig").clangd.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        -- 关键配置：启用头文件补全和代码片段
        cmd = {
          "clangd",
          "--header-insertion=iwyu", -- 自动插入头文件
          "--suggest-missing-includes" -- 提示缺少的头文件
        }
      })
    end
  },

  -- 自动补全引擎（新增代码片段支持）
  {
      event = "VeryLazy",
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "windwp/nvim-autopairs",
      -- 新增代码片段引擎
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    },
    config = function()
      -- 初始化代码片段引擎
      require("luasnip.loaders.from_vscode").lazy_load()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local lspkind = require("lspkind") 
      lspkind.init({
    symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    },
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      -- 自动括号补全配置
      require("nvim-autopairs").setup()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- 强化版补全配置
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- 启用代码片段展开
          end,
        },
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- 添加代码片段源
          { name = "buffer" },
          { name = "path" },
        }),
        -- 新增视觉优化配置
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",  -- 显示图标和文字
      maxwidth = 50,         -- 限制补全项宽度
      ellipsis_char = "...", -- 过长内容显示为...

      -- 自定义图标标签显示格式
      before = function(entry, vim_item)
        -- 显示补全来源的名称（如 LSP、Snippet 等）
        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
        return vim_item
      end
    })
  },

  -- 配置补全窗口样式
  window = {
    completion = {
      border = "rounded",         -- 圆角边框
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      scrollbar = false,          -- 隐藏滚动条
      col_offset = -3,            -- 对齐图标和文本
      side_padding = 0,           -- 两侧无额外填充
    },
    documentation = {
      border = "rounded",         -- 文档窗口同样圆角
    },
  },

  -- 调整补全菜单排序优先级（可选）
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    }
  }
})
    end
  }
}
