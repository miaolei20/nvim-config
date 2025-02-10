return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.x", -- 推荐使用 0.1.x 分支
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- 更快性能
    "nvim-telescope/telescope-ui-select.nvim", -- 输入选择器
  },
  keys = {
    -- 基础快捷键
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (cwd)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Recent Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",   desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
  },
  config = function()
    local telescope = require("telescope")
    
    -- 基础配置（按需调整）
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        layout_strategy = "horizontal",
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true, -- 包含隐藏文件
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }, -- 依赖 fd 命令
        }
      },
      -- extensions = { ... }  -- 给拓展模块的配置
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end
}

