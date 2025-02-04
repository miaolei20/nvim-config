-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    --onedark 主题
    {
        "navarasu/onedark.nvim",
    },

    --telescope
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

    --persistence
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
    },

    --which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    --lspconfig
    {
        event = "VeryLazy",
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim",
            "onsails/lspkind.nvim",
        }
    },

    --mason
    {
        event = "VeryLazy",
        "williamboman/mason.nvim",
    },

    --cmp
    {
        event = "VeryLazy",
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",    -- Snippets 补全源
            "rafamadriz/friendly-snippets" -- 预定义代码片段
        }
    },

    --neodv
    { "folke/neodev.nvim", opts = {} },

    --autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        opts = {}
    },

    --null-ls
    {
        event = "VeryLazy",
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    --fugitive.vim
    {
        event = "VeryLazy",
        "tpope/vim-fugitive",
        cmd = "Git",
    },

    --nvimtree
    {
        event = "VeryLazy",
        "nvim-tree/nvim-tree.lua",
        dependencies =
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },

    --treesitter
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies =
        { "nvim-treesitter/nvim-treesitter" }
    },

    {
        event = "VeryLazy",
        "HiPhish/nvim-ts-rainbow2",
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    }
})
