-- 公共配置模块
local M = {}

-- 诊断图标配置（统一维护）
M.diagnostic_signs = {
  Error = " ",
  Warn  = " ",
  Hint  = " ",
  Info  = " ",
}

-- 初始化诊断图标
function M.setup_diagnostic_signs()
  for type, icon in pairs(M.diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

-- 公共能力配置
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

-- 通用 on_attach 配置
function M.common_on_attach(client, bufnr)
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

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = { border = "rounded" },
    hint_enable = false,
  }, bufnr)
end

-- LSP 服务配置
local lsp_servers = {
  clangd = {
    cmd = {
      "clangd", "--background-index", "--clang-tidy",
      "--header-insertion=iwyu", "--completion-style=detailed", "--cross-file-rename"
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
  },
  pyright = {
    settings = {
      pyright = { autoImportCompletion = true },
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    }
  },
  lua_ls = {
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
    }
  }
}

-- 初始化 LSP 配置
function M.setup_lsp()
  local capabilities = M.get_capabilities()
  for server, config in pairs(lsp_servers) do
    require("lspconfig")[server].setup(vim.tbl_extend("force", {
      capabilities = capabilities,
      on_attach = M.common_on_attach,
    }, config))
  end
end

return M