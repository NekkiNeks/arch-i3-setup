require("nvim-tree").setup({
    -- ... твои настройки (sort_by, renderer и т.д.) ...
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Это ОБЯЗАТЕЛЬНО должно быть тут
        api.config.mappings.default_on_attach(bufnr)

        -- Кастомные клавиши (h/l для папок)
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        -- Поддержка русской раскладки
        vim.keymap.set('n', 'р', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'д', api.node.open.edit, opts('Open'))
    end,

    --  Отображение иконок в дереве рядом с проблемными файлами
    diagnostics = {
        enable = true,       -- Включает иконки ошибок в дереве
        show_on_dirs = true, -- Показывать ошибку на папке, если она внутри
        icons = {
            hint = "󰠠",
            info = "",
            warning = "",
            error = "",
        }
    }
})


-- Функционал для переключения фокуса с файла в дерево и обратно
local api = require("nvim-tree.api")
local last_win = nil

-- Непосредственно функция для переклчения фокуса
local function toggle_tree_focus()
    local curr_win = vim.api.nvim_get_current_win()
    local curr_buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(curr_buf, "filetype")

    if ft == "NvimTree" then
        if last_win and vim.api.nvim_win_is_valid(last_win) then
            vim.api.nvim_set_current_win(last_win)
            last_win = nil
        else
            vim.notify("Нет предыдущего окна", vim.log.levels.WARN)
        end
    else
        if ft ~= "NvimTree" then
            last_win = curr_win
        end
        api.tree.focus()
    end
end

-- Назначение клавиш на выполнение функции смены фокуса
vim.keymap.set('n', '<leader>e', toggle_tree_focus, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>у', toggle_tree_focus, { noremap = true, silent = true })
