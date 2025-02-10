-- 定义各个诊断类型对应的图标（图标可根据自己的喜好进行调整）
local signs = {
  Error = " ",  -- 错误图标：常用图标有 ""、""、"✘"
  Warn  = " ",  -- 警告图标：常用图标有 ""、""
  Hint  = " ",  -- 提示图标：常用图标有 ""、""
  Info  = " ",  -- 信息图标：常用图标有 ""、""
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

return {
  -- ==================== LSP 核心配置 ==================== --
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "onsails/lspkind.nvim",
      "ray-x/lsp_signature.nvim",  -- 新增：函数参数提示
    },
    config = function()
      -- 全局 LSP 配置
      local lsp_utils = require("lspconfig.util")
      local default_capabilities = vim.lsp.protocol.make_client_capabilities()
      default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)
      default_capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      -- 通用 LSP 设置
      local on_attach = function(client, bufnr)
        -- 增强版快捷键绑定
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- 启用 LSP 签名提示
        require("lsp_signature").on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
          hint_enable = false,  -- 防止与 cmp 冲突
        }, bufnr)
      end

      -- Clangd 配置
      require("lspconfig").clangd.setup({
        capabilities = default_capabilities,
        on_attach = on_attach,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--cross-file-rename",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
      })

      -- Python 配置
      require("lspconfig").pyright.setup({
        capabilities = default_capabilities,
        on_attach = on_attach,
        settings = {
          pyright = { autoImportCompletion = true },
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Lua 配置（强化版）
      require("lspconfig").lua_ls.setup({
        capabilities = default_capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })
    end,
  },

  -- ==================== 自动补全系统 ==================== --
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",  -- 新增：社区代码片段
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- 代码片段引擎初始化
      luasnip.config.setup({ history = true, updateevents = "TextChanged,TextChangedI" })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { "./snippets" },  -- 自定义片段路径
      })

      -- 自动配对集成
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt" } })
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- 视觉优化配置
      lspkind.init({
        symbol_map = {
          Codeium = "",
          Copilot = "",
          TabNine = "",
        },
      })

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 40,
            ellipsis_char = "…",
            before = function(entry, item)
              item.menu = ("[%s]"):format(entry.source.name:upper())
              return item
            end,
          }),
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            col_offset = -1,
            side_padding = 0,
          }),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment",  -- 更自然的虚拟文本颜色
          },
        },
      })

      -- 文件类型特定配置
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}