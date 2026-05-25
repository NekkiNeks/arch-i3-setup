-- [NEOSCROLL]
-- Плавное перематывание при перемещении

require('neoscroll').setup({
    mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        -- '<C-u>', '<C-d>',
        -- 'zt', 'zz', 'zb',
    },
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    duration_multiplier = 0.7,   -- Global duration multiplier
    easing = 'linear',           -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
    ignored_events = {           -- Events ignored while scrolling
        'WinScrolled', 'CursorMoved'
    },
})

local neoscroll = require('neoscroll')


-- [ВРЕМЕННЫЙ КОСТЫЛЬ, ПОСЛЕ ОБНОВЛЕНИЯ УДАЛИТЬ ПРОВЕРИВ ФУНКЦИОНАЛ zz (Раньше выкидывал warning)]
-- Раскомментировать код снизу и проверить!
local original_notify = vim.notify
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opts)
    if msg and type(msg) == "string" and msg:find("neoscroll") then
        return
    end
    original_notify(msg, level, opts)
end


local scroll_maps = {
    -- Команда      -- Функция плагина
    ['<C-u>'] = function() neoscroll.ctrl_u({ duration = 250 }) end,
    ['<C-г>'] = function() neoscroll.ctrl_u({ duration = 250 }) end,

    ['<C-d>'] = function() neoscroll.ctrl_d({ duration = 250 }) end,
    ['<C-в>'] = function() neoscroll.ctrl_d({ duration = 250 }) end,

    ['яя'] = function() neoscroll.zz(250) end,
    ['zz'] = function() neoscroll.zz(250) end,

    -- раскомментировать тут
    -- ['яя'] = function() neoscroll.zz({ duration = 250 }) end,
    -- ['zz'] = function() neoscroll.zz({ duration = 250 }) end,
}

for key, func in pairs(scroll_maps) do
    vim.keymap.set({ 'n', 'v', 'x' }, key, func, { silent = true })
end
