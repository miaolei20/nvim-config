-- file: lsp.lua
return {
  -- ==================== 核心 LSP 配置 ==================== --
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "onsails/lspkind.nvim",
      "ray-x/lsp_signature.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs"
    },
    config = function()
      -- 诊断图标配置
      for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
        vim.fn.sign_define("DiagnosticSign"..type, { text = icon, texthl = "DiagnosticSign"..type })
      end

      -- 通用配置
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      local on_attach = function(client, bufnr)
        local map = vim.keymap.set
        for keys, func in pairs({
          gd = vim.lsp.buf.definition,
          gr = vim.lsp.buf.references,
          K  = vim.lsp.buf.hover,
          ["<leader>rn"] = vim.lsp.buf.rename,
          ["<leader>ca"] = vim.lsp.buf.code_action
        }) do map("n", keys, func, { buffer = bufnr, silent = true }) end

        require("lsp_signature").on_attach({
          bind = true, 
          handler_opts = { border = "rounded" },
          hint_enable = false
        }, bufnr)
      end

      -- 服务器配置
      for server, config in pairs({
        clangd = { cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed" }},
        pyright = { settings = { python = { analysis = { typeCheckingMode = "basic" }}}},
        lua_ls = { settings = { Lua = { runtime = { version = "LuaJIT" }, workspace = { checkThirdParty = false }}}}
      }) do require("lspconfig")[server].setup(vim.tbl_deep_extend("force", { capabilities = capabilities, on_attach = on_attach }, config)) end

      -- 自动补全配置
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            cmp.visible() and cmp.select_next_item() or fallback()
          end, {"i","s"})
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp", priority = 1000 }, { name = "luasnip", priority = 750 } }
        ),
        formatting = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 40, ellipsis_char = "…" })
      })

      require("nvim-autopairs").setup()
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end
  }
}
