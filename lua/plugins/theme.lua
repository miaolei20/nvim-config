return {
    --onedark 主题
    {
        "navarasu/onedark.nvim",
        config = function()
            --vim.cmd([[colorscheme onedark]])
            require("onedark").setup({
                style = "darker", ---可以选“dark，darker，cool,deep,warm,warmer
            })
            require("onedark").load()
        end,
    },
}
