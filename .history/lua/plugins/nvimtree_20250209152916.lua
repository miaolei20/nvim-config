return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",                         -- 锁定主版本防止破坏性更新
    event = "UIEnter",                     -- 更早触发确保 GUI 终端颜色正常
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      opts = {                             -- 增强图标配置
        color_icons = true,                -- 启用彩色图标
        default = true,                    -- 保留默认图标
      }
    },
    keys = {                               -- 明确定义快捷键
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal Current File" }
    },
    config = function()
      -- 验证依赖项加载状态
      if not pcall(require, "nvim-web-devicons") then
        vim.notify("Missing devicons dependency!", vim.log.levels.WARN)
      end

      -- 禁用 netrw 的更加安全的写法
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- 配置核心功能（推荐结构化配置）
      require("nvim-tree").setup({
        hijack_cursor = true,             -- 保持光标停留在文件树
        update_focused_file = {
          enable = true,                  -- 自动定位当前文件
          update_root = true
        },
        diagnostics = {                   -- 集成 LSP 诊断
          enable = true,
          show_on_dirs = false,
          icons = {
            hint = "󰌵",
            info = "",
            warning = "",
            error = "",
          }
        },
        renderer = {
          indent_markers = { enable = true },
          icons = {
            git_placement = "after",      -- git 状态标识位置
            modified_placement = "after", -- 修改状态标识位置
            show = {
              file = true,
              folder = true,
              folder_arrow = false        -- 关闭旧式箭头符号
            }
          }
        },
        view = {
          adaptive_size = false,          -- 关闭自动尺寸调整
          width = { min = 30, max = 50 }, -- 弹性宽度范围
          mappings = {                    -- 禁用默认快捷键（推荐手动映射）
            list = {
              { key = "l", action = "edit", action_cb = false },
              { key = "h", action = "close_node", action_cb = false }
            }
          }
        },
        actions = {                       -- 扩展操作配置
          open_file = {
            quit_on_open = true,          -- 打开文件后自动关闭文件树
            window_picker = { enable = false } -- 禁用窗口选择器
          }
        },
        filters = {
          dotfiles = false,               -- 改为显示隐藏文件（需按 ,. 切换）
          custom = { "^.git$" }           -- 默认隐藏 .git 目录
        },
        live_filter = {
          prefix = "[FILTER]: ",          -- 实时过滤提示前缀
          always_show_folders = false     -- 过滤时隐藏空文件夹
        }
      })

      -- 自动关闭如果最后窗口是文件树
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          local api = require("nvim-tree.api")
          if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
            vim.cmd("quit")
          end
        end
      })
    end
  }
}
