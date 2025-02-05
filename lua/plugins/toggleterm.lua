-- 添加到你的插件配置文件中（如 ~/.config/nvim/lua/plugins.lua）
return {
    {
        cmd = "ToggleTerm",
        keys = {
            { "<C-t>", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
        },
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- 基础配置
                size = 15,                    -- 终端窗口高度（百分比或像素值）
                open_mapping = false,         -- 禁用默认快捷键（稍后手动绑定）
                direction = "float",          -- 悬浮模式
                float_opts = {
                    border = "rounded",       -- 圆角边框（可选：single, double, shadow, curved）
                    winblend = 10,            -- 透明度（0-100，值越大越透明）
                    width = math.floor(vim.o.columns * 0.8), -- 终端宽度占屏幕的80%
                    height = math.floor(vim.o.lines * 0.6), -- 终端高度占屏幕的60%
                },
                start_in_insert = true,       -- 打开时自动进入插入模式
                persist_mode = true,          -- 记住终端状态
                close_on_exit = true,         -- 终端退出后关闭窗口
            })
        end,
    },
}
