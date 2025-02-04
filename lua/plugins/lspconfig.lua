  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  cmd = { "clangd", "--background-index", "--clang-tidy" }
})

--pyright
lspconfig.pyright.setup({
    capabilities =capabilities,
})

-- lua
-- 配置 lua_ls（Lua Language Server）
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      -- 启用 LSP 内置格式化功能
      format = {
        enable = true, -- 开启自动格式化
        defaultConfig = {
          indent_style = "space",
          indent_size = "4", -- 缩进 4 空格
        }
      },
      -- 其他 LSP 配置（可选）
      diagnostics = { globals = { "vim" } }, -- 避免 vim 全局变量报错
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- 设置保存文件时自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function()
    -- 调用 LSP 格式化（仅由 lua_ls 处理）
    vim.lsp.buf.format({
      filter = function(client)
        return client.name == "lua_ls" -- 仅允许 lua_ls 格式化
      end,
      async = false, -- 同步执行确保保存前完成
    })
  end,
})
require("mason").setup()
require("mason-lspconfig").setup()
