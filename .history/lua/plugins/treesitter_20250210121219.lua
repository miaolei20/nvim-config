return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- 自动更新语法解析器
        config = function()
            vim.g.skip_ts_context_commentstring_module = true,
            require("nvim-treesitter.configs").setup({
                context_commentstring = {
                enable_autocmd = false,
                },
                vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'c', 'cpp' },
                callback = function()
                vim.bo.commentstring = '// %s'
                -- 或使用块注释
                -- vim.bo.comments = ':/**,:*/'
                end
                })
                -- 启用语法高亮
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                -- 启用括号高亮
                rainbow = {
                    enable = true,
                    extended_mode = true, -- 支持更多括号类型
                    max_file_lines = nil, -- 不限制文件行数
                },
                -- 确保安装以下语言的语法解析器
                ensure_installed = {
                    "c",
                    "cpp",
                    "python",
                    "java",
                    "lua",
                    "bash",
                    "json",
                    "yaml",
                    "markdown",
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                },
                matchup = {
                    enable = true, -- 启用 matchup 支持
                },
            })
        end,
    },
}