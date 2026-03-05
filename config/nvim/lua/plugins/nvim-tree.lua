require("nvim-tree").setup({

    -- Функция которая выполняется при запуске. В ней можно определять хоткеи и другие настройки
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.opt_local.guicursor = "n-v-c:block-NvimTreeCursor,i-ci-ve:ver25"
        vim.cmd('highlight NvimTreeCursor ctermbg=8 ctermfg=8')

        -- Обязательные дефолтные маппинги
        api.config.mappings.default_on_attach(bufnr)

        -- Ваши текущие маппинги
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'р', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'д', api.node.open.edit, opts('Open'))

        -- --- ДОПОЛНЕНИЯ: Блокировка горизонтального движения ---

        -- Блокируем стрелки
        vim.keymap.set('n', '<Left>', '<Nop>', opts('Do Nothing'))
        vim.keymap.set('n', '<Right>', '<Nop>', opts('Do Nothing'))

        -- Блокируем пробел и backspace
        vim.keymap.set('n', '<Space>', '<Nop>', opts('Do Nothing'))
        vim.keymap.set('n', '<BS>', '<Nop>', opts('Do Nothing'))
    end,

    view = {
        cursorline = true,
    },
    renderer = {
        highlight_cursorline = true,
    },
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
