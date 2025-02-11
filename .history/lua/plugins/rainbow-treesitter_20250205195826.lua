return {
    event = "VeryLazy",
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
        local rainbow_delimiters = require("rainbow-delimiters")

        -- 配置 rainbow-delimiters
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy["global"], -- 默认策略
                vim = rainbow_delimiters.strategy["local"], -- 在 Vim 模式下使用局部策略
            },
            query = {
                [""] = "rainbow-delimiters", -- 默认查询
                lua = "rainbow-blocks", -- Lua 使用特定查询
            },
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterBlue",
                "RainbowDelimiterOrange",
                "RainbowDelimiterGreen",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            },
        }
    end,
}
