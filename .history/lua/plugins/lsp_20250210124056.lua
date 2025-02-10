-- 定义诊断图标和快捷键映射
local signs = {
  Error = " ",
  Warn  = " ",
  Hint  = " ",
  Info  = " ",
}

for type, icon in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign"..type, { text = icon, texthl = "DiagnosticSign"..type })
end

-- 统一 LSP 功能配置
local M = {}

function M.setup()
  -- 全局能力配置
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  -- 通用 on_attach 函数
  local on_attach = function(client, bufnr)
    -- 增强快捷键系统
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: "..desc })
    end

    -- 导航类快捷键
    map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
    map("n", "gr", "<cmd>Telescope lsp_references<cr>", "查看引用")
    map("n", "K", vim.lsp.buf.hover, "悬停文档")

    -- 操作类快捷键
    map("n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作菜单")
    map("n", "<leader>qf", function()  -- 新增快速修复专用快捷键
      vim.lsp.buf.code_action({
        context = { only = { "quickfix" }, diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
      })
    end, "快速修复当前行")

    -- 签名提示配置
    require("lsp_signature").on_attach({
      bind = true,
      handler_opts = { border = "rounded" },
      hint_enable = false,
    }, bufnr)
  end

  -- LSP 服务器配置
  local servers = {
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      }
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
          }
        }
      }
    },
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false }
        }
      }
    }
  }

  -- 统一设置 LSP
  for server, config in pairs(servers) do
    require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = on_attach,
    }, config))
  end
end

return {
  -- LSP 核心配置
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "onsails/lspkind.nvim",
      "ray-x/lsp_signature.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = M.setup
  },

  -- 自动补全系统（保持原有优化）
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { /* 原有依赖 */ },
    config = function()
      -- 保持原有 cmp 配置，可添加：
      require("cmp").setup({
        -- 添加快速修复建议优先显示
        sorting = {
          priority_weight = 2,
          comparators = {
            require("cmp.config.compare").sort_text,
            require("cmp.config.compare").offset,
            require("cmp.config.compare").exact,
          }
        }
      })
    end
  }
}