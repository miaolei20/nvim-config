return {
  {
    event = "BufWinEnter",
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      config = true  -- 自动加载 devicons 配置
    },
    config = function()
      -- 禁用原生文件管理器
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- 启用真彩色支持
      vim.opt.termguicolors = true

      -- 核心配置
      require("nvim-tree").setup({
        -- 视图设置
        view = {
          adaptive_size = false,
          width = 32,
          side = "left",
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },
        -- 渲染设置
        renderer = {
          group_empty = true,
          highlight_git = true,
          indent_markers = {
            enable = true,
          },
          icons = {
            webdev_colors = true,
            git_placement = "after",
            show = {
              file = true,
              folder = true,
              folder_arrow = false,
            },
          },
        },
        -- 文件排序
        sort = {
          sorter = "case_sensitive",
        },
        -- 过滤设置
        filters = {
          dotfiles = false,  -- 显示隐藏文件
          custom = { ".DS_Store" },  -- 过滤系统文件
        },
        -- 高级功能
        actions = {
          change_dir = {
            enable = true,
            global = false,  -- 仅改变当前窗口的工作目录
          },
          open_file = {
            quit_on_open = true,  -- 打开文件后自动关闭树
          },
        },
        -- Git 集成
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
      })

      -- 快捷键映射
      local map = vim.keymap.set
      map("n", "<F3>", "<cmd>NvimTreeToggle<CR>", {
        noremap = true,
        silent = true,
        desc = "切换文件树"
      })
      map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", {
        noremap = true,
        silent = true,
        desc = "聚焦文件树"
      })
    end
  }
}