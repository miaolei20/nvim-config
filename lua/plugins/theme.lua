return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    bufferline = true, -- 启用 bufferline 集成
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha") -- 选择主题风格：latte, frappe, macchiato, mocha
        end,
    },
}
