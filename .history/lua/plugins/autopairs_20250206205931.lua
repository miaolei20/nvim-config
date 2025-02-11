return {
    {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- 使用 Treesitter 检查上下文
        ts_config = {
          lua = { "string" }, -- 在 Lua 的字符串中不启用
          javascript = { "template_string" },
        },
      })
    end,
  },
}

