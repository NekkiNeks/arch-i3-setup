-- [CMP]
-- основной движок автодополнения
-- Отвечает именно за отрисовку интерфейса автодополнения.
-- Использует LSP скачанные Mason и настроенные через Lspconfig.

local cmp = require('cmp')
local utils = require('functions.utils')

-- Настройка цветов для выпадающего окна подсказок
vim.api.nvim_set_hl(0, "Pmenu", { ctermfg = 15, ctermbg = 8 })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermfg = 9, ctermbg = 8 })

-- Создание лейбла на основе типа
-- Принимает "String" и возвращает "[str]"
local function get_kind_label(kind)
    local shortened = utils.remove_vowels(kind)
    local letters = shortened:sub(1, 3):upper()
    return "[" .. letters .. "]"
end

-- Функция обработчик элементов списка подсказок
local function handleEntryName(_, item)
    local label = item.abbr
    -- Проверка на длину
    if #label > 40 then
        item.abbr = label:sub(1, 38) .. ".."
    end

    -- Добавление "метки"
    item.abbr = get_kind_label(item.kind) .. " " .. item.abbr

    return item
end

cmp.setup({
    mapping = {
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
    },

    completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 1, -- Показ после 1 символа
    },
    sorting = {
        priority_weight = 1.0,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score, -- не убирает частичные совпадения
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    experimental = {
        ghost_text = false,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'luasnip' }, -- если используешь
    },

    view = {
        entries = {
            name = "custom",
            selection_order = "top_down"
        }
    },
    -- Окошко подсказок при вводе
    window = {
        -- Окно самих подсказок
        completion = cmp.config.window.bordered({
            border = "single", -- Та самая тонкая рамка 1 пиксель
            max_width = 15,
            max_height = 10,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
        -- Окно документации (которое справа от подсказки)
        documentation = cmp.config.window.bordered({
            border = "single",
            max_width = 15,
            max_height = 10,
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }),
    },
    formatting = {
        format = handleEntryName,
        fields = { "abbr" }
    }
})
