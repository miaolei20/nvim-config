return {
    {
        cmd = "Telescope",
        keys = {
            { "<leader>f",  ":Telescope find_files<CR>", desc = "find files" },
            { "<leader>g",  ":Telescope live_grep<CR>",  desc = "grep files" },
            { "<leader>h",  ":Telescope help_tags<CR>",   desc = "help tags" },
            { "<leader>o",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
        },
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        -- or                              , branch = '0.1.x',
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}

