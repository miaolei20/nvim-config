-- 优化：定义诊断图标（可按个人喜好调整）
local diagnostic_signs = {
  Error = " ",
  Warn  = " ",
  Hint  = " ",
  Info  = " ",
}

for type, icon in pairs(diagnostic_signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- LSP 核心配置
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymaps = {
    { mode = "n", key = "gd",   action = vim.lsp.buf.definition,   desc = "转到定义" },
    { mode = "n", key = "gr",   action = vim.lsp.buf.references,   desc = "查找引用" },
    { mode = "n", key = "K",    action = vim.lsp.buf.hover,        desc = "显示文档" },
    { mode = "n", key = "<leader>rn", action = vim.lsp.buf.rename,   desc = "重命名" },
    { mode = "n", key = "<leader>ca", action = vim.lsp.buf.code_action, desc = "代码操作" },
  }
  for _, map in ipairs(keymaps) do
    vim.keymap.set(map.mode, map.key, map.action, vim.tbl_extend("force", opts, { desc = map.desc }))
  end

  -- 启用 lsp_signature 插件：显示函数签名
  lsp_signature.on_attach({
    bind = true,
    handler_opts = { border = "rounded" },
    hint_enable = false,  -- 防止与 cmp 冲突
  }, bufnr)
end

-- Clangd 配置（C/C++）
lspconfig.clangd.setup({
  capabilities = capabilities,
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

-- Python 配置（pyright）
lspconfig.pyright.setup({
  capabilities = capabilities,
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

-- Lua 配置（lua_ls）
lspconfig.lua_ls.setup({
  capabilities = capabilities,
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

-- 自动补全系统配置
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- 初始化代码片段引擎
luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "./snippets" },  -- 如有自定义代码片段，可添加路径
})

-- 自动配对集成：确认补全时自动添加匹配符号
require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt" },
})
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- lspkind 配置：为补全菜单添加图标
lspkind.init({
  symbol_map = {
    Codeium = "",
    Copilot = "",
    TabNine = "",
  },
})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({
      select = true,
      behavior = cmp.ConfirmBehavior.Replace,
    }),
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
      before = function(entry, vim_item)
        vim_item.menu = ("[%s]"):format(entry.source.name:upper())
        return vim_item
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
      hl_group = "Comment",  -- 虚拟文本使用注释的高亮组
    },
  },
})

-- 针对 gitcommit 文件类型的特殊配置
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})