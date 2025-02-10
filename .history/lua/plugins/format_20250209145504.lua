return {
    {
        cmd = "Format",
        keys = {
            {
                "<C-s>",
                function()
                    vim.cmd([[Format]])
                end,
                desc = "Format",
            },
        },  
        "jose-elias-alvarez/null-ls.nvim", -- 用于调用外部工具
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting

            null_ls.setup({
                sources = {
                    -- C/C++ 使用 clang-format，配置为 LLVM 风格
                    formatting.clang_format.with({
                        extra_args = { "-style=LLVM" },
                    }),
                    -- Python 使用 black
                    formatting.black,
                    -- Java 使用 google-java-format
                    formatting.google_java_format,
                    -- Lua 使用 stylua
                    formatting.stylua,
                },
            })
            vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>:lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>:lua vim.lsp.buf.format()<CR>a", { noremap = true, silent = true })
        end,
    },
}
