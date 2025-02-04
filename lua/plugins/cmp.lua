-- Set up nvim-cmp.
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require 'cmp'
local lspkind = require("lspkind") -- 加载图标插件
lspkind.init({
    symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    },
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- 配置自动补全（nvim-cmp）
local luasnip = require("luasnip")

-- 加载预定义代码片段
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                -- 如果补全菜单可见，用 Tab 选择下一个项
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                -- 如果代码片段可扩展，用 Tab 触发
                luasnip.expand_or_jump()
            else
                -- 否则执行普通 Tab 缩进
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true, -- 回车确认补全
        }),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP 补全
        { name = "luasnip" },  -- 代码片段
        { name = "buffer" },   -- 当前缓冲区文本
        { name = "path" },     -- 路径补全
    }),
    -- 新增视觉优化配置
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",  -- 显示图标和文字
            maxwidth = 50,         -- 限制补全项宽度
            ellipsis_char = "...", -- 过长内容显示为...

            -- 自定义图标标签显示格式
            before = function(entry, vim_item)
                -- 显示补全来源的名称（如 LSP、Snippet 等）
                vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                return vim_item
            end
        })
    },

    -- 配置补全窗口样式
    window = {
        completion = {
            border = "rounded", -- 圆角边框
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            scrollbar = false,  -- 隐藏滚动条
            col_offset = -3,    -- 对齐图标和文本
            side_padding = 0,   -- 两侧无额外填充
        },
        documentation = {
            border = "rounded", -- 文档窗口同样圆角
        },
    },

    -- 调整补全菜单排序优先级（可选）
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    },
    experimental = {
        ghost_text = true, -- 输入时显示虚拟提示（如函数参数）
    }
})
-- 自定义补全菜单高亮颜色（可选）
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#6c71c4", italic = true }) -- 来源标签颜色
-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]] --

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
