return {
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                -- 核心视觉配置
                style = "dark", -- 支持 dark/darker/cool/deep/warm/warmer/light
                transparent = false,
                term_colors = true,
                ending_tildes = false,

                -- 高级高亮配置
                diagnostics = {
                    darker = true, -- 诊断使用深色背景
                    undercurl = true, -- 启用下划线样式
                },

                -- 组件集成定制
                code_style = {
                    comments = "italic",
                    keywords = "bold",
                    functions = "none",
                    strings = "none",
                    variables = "none",
                },

                -- 自定义扩展高亮组
                highlights = {
                    -- 增强 bufferline 集成
                    BufferLineBufferSelected = { bg = "#31353f", fg = "#abb2bf", sp = "#61afef", bold = true },
                    BufferLineSeparatorSelected = { fg = "#31353f", bg = "#31353f" },
                    BufferLineIndicatorSelected = { fg = "#61afef", bg = "#31353f" },

                    -- 优化标签关闭按钮视觉效果
                    BufferLineCloseButtonSelected = { bg = "#31353f", fg = "#e06c75" },
                    BufferLineCloseButtonVisible = { bg = "#282c34", fg = "#666d80" },
                },

                -- Lualine 集成优化
                lualine = {
                    transparent = false, -- 保持状态栏背景色统一
                },
            })

            vim.cmd.colorscheme("onedark")
        end,
    },
}
