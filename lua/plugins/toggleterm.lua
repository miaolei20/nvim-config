-- lazy.nvim插件配置
return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<leader>tt", desc = "Toggle基础终端" },
            { "<leader>tf", desc = "Toggle浮动终端" },
        },
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    return (term.direction == "horizontal") and 15
                        or (term.direction == "vertical") and vim.o.columns * 0.4
                        or 20
                end,
                persist_size = false,
                direction = "float", -- 默认使用悬浮终端
                close_on_exit = true,
                highlights = {
                    FloatBorder = { link = "ToggleTermBorder" },
                },
                float_opts = {
                    border = "rounded", -- 圆角边框
                    winblend = 10, -- 透明度混合
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                },
            })
            -- 按键映射
            local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
            end
            map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", "水平终端")
            map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", "浮动终端")
        end,
    },
}
