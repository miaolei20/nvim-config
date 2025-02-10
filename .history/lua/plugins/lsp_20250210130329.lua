-- 诊断图标配置
local function setup_diagnostic_signs()
  local signs = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
  }
  for type, icon in pairs(signs) do
    vim.fn.sign_define("DiagnosticSign"..type, {text = icon, texthl = "DiagnosticSign"..type})
  end
end

-- 通用 LSP 配置
local function create_common_config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  local on_attach = function(client, bufnr)
    local map = function(keys, func) 
      vim.keymap.set("n", keys, func, {buffer = bufnr, silent = true}) 
    end

    map("gd", vim.lsp.buf.definition)
    map("gr", vim.lsp.buf.references)
    map("K",  vim.lsp.buf.hover)
    map("<leader>rn", vim.lsp.buf.rename)
    map("<leader>ca", vim.lsp.buf.code_action)

    require("lsp_signature").on_attach({
      bind = true, 
      handler_opts = { border = "rounded" },
      hint_enable = false
    }, bufnr)
  end

  return { capabilities = capabilities, on_attach = on_attach }
end

-- LSP 服务器配置
local function setup_servers(common)
  local servers = {
    clangd = {
      cmd = {
        "clangd", "--background-index", "--clang-tidy",
        "--header-insertion=iwyu", "--completion-style=detailed"
      }
    },
    pyright = {
      settings = {
        python = { analysis = { typeCheckingMode = "basic" } }
      }
    },
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = { checkThirdParty = false }
        }
      }
    }
  }

  for server, config in pairs(servers) do
    require("lspconfig")[server].setup(vim.tbl_deep_extend("force", common, config))
  end
end

return {
  -- ==================== 核心 LSP 配置 ==================== --
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "onsails/lspkind.nvim",
      "ray-x/lsp_signature.nvim",
    },
    config = function()
      setup_diagnostic_signs()
      setup_servers(create_common_config())
    end
  },

  -- ==================== 自动补全系统 ==================== --
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- 公共映射配置
      local mappings = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          else fallback() end
        end, {"i","s"})
      })

      -- 基础配置
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = mappings,
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 }
        }),
        formatting = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 40,
          ellipsis_char = "…"
        })
      })

      -- 自动配对集成
      require("nvim-autopairs").setup()
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end
  }
}