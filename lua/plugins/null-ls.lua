local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- 配置 black 作为格式化源
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length", "88" } -- 自定义参数（可选）
        }),
        -- 其他工具（可选）
        -- null_ls.builtins.formatting.autopep8,
        -- null_ls.builtins.formatting.yapf,
    },
})

-- 保存时自动调用 LSP 格式化
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.lsp.buf.format({ async = false }) -- 同步格式化确保保存前完成
    end
})
