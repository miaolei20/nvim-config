return{
    {
        cmd = "Telescope",
        keys = {
            { "<leader>f",  ":Telescope find_files<CR>", desc = "find files" },
            { "<leader>g",  ":Telescope live_grep<CR>",  desc = "grep files" },
            { "<leader>rs", ":Telescope resume<CR>",     desc = "resume" },
            { "<leader>o",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
        },
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
}