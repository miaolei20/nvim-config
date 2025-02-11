return {
    {
        event = "BufWritePre",
        "jose-elias-alvarez/null-ls.nvim", -- 用于调用外部工具
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting

            null_ls.setup({
                sources = {
                    -- C/C++ 使用 clang-format
                    formatting.clang_format,
                    -- Python 使用 black
                    formatting.black,
                    -- Java 使用 google-java-format
                    formatting.google_java_format,
                    -- Lua 使用 stylua
                    formatting.stylua,
                },
            })
        end,
    },
}
