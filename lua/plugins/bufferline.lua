return {
    event = "VeryLazy",
    "akinsho/bufferline.nvim",
    config = function()
        require("bufferline").setup({
            options = {
                offsets = {
                    {
                        filetype = "NvimTree", -- 如果你想调整 NvimTree 的偏移
                        text = "Explorer", -- 偏移的文本
                        highlight = "Directory", -- 高亮样式
                        text_align = "left", -- 文本对齐方式
                    },
                },
                show_buffer_icons = true, -- 显示 buffer 图标
                show_buffer_close_icons = true, -- 显示关闭按钮
                show_tab_indicators = true, -- 显示标签指示器
                separator_style = "slant", -- 标签之间的分隔线样式（可以是 "slant", "thick", "thin"）
            },
        })
    end,
}
