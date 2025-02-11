return {
    {
        event = "BufRead",
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
}

