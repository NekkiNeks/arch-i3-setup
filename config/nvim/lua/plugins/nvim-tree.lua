local api = require('nvim-tree.api')
local view = require('nvim-tree.view')

local function toggle_tree_focus()
    -- Если текущее окно — это дерево, прыгаем назад
    if view.is_visible() and vim.api.nvim_get_current_win() == view.get_winnr() then
        vim.cmd("wincmd p")
    else
        -- Иначе фокусируем дерево
        api.tree.focus()
    end
end

local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(bufnr)

    -- 1. Получаем текущую клавишу лидера
    local leader = vim.g.mapleader or " " -- если не задан, по умолчанию пробел

    -- 2. Создаем опции с принудительным приоритетом
    local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

    -- 3. Удаляем 'e', чтобы дерево его не перехватывало
    pcall(vim.keymap.del, 'n', 'e', { buffer = bufnr })

    -- 4. Мапим ПРЯМО на клавишу (например, на пробел + e)
    -- Мы используем переменную leader, чтобы код был гибким
    vim.keymap.set('n', leader .. 'e', toggle_tree_focus, opts)
    vim.keymap.set('n', leader .. 'у', toggle_tree_focus, opts)

    -- Для надежности замапим и саму клавишу 'e' на действие 'ничего'
    -- чтобы она точно не срабатывала сама по себе
    vim.keymap.set('n', 'e', '<Nop>', { buffer = bufnr })
end

-- Глобальный маппинг (когда мы в файле)
vim.keymap.set("n", "<Leader>e", toggle_tree_focus, { noremap = true, silent = true, desc = "Toggle Tree Focus" })
vim.keymap.set("n", "<Leader>у", toggle_tree_focus,
    { noremap = true, silent = true, desc = "Toggle Tree Focus (RU)" })

require("nvim-tree").setup({
    on_attach = my_on_attach,
    view = {
        width = 35,
        relativenumber = true, -- В 0.11 удобно видеть относительные номера в дереве
    },
    -- ... остальные ваши настройки (diagnostics и т.д.)
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = "NvimTree",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local leader = vim.g.mapleader or " " -- берем ваш лидер (по умолчанию пробел)

        -- Опции: теперь добавляем 'nowait', чтобы не было задержки
        local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

        -- ПРИНУДИТЕЛЬНО ПЕРЕБИВАЕМ 'e'
        -- Сначала удаляем старый маппинг 'e', если он есть
        pcall(vim.keymap.del, 'n', 'e', { buffer = bufnr })
        -- Ставим заглушку на чистую 'e', чтобы она не вызывала Rename
        vim.keymap.set('n', 'e', '<Nop>', { buffer = bufnr })

        -- НАЗНАЧАЕМ ЛИДЕР ВРУЧНУЮ ДЛЯ ЭТОГО БУФЕРА
        -- Используем конкатенацию, чтобы Vim увидел физическую клавишу
        vim.keymap.set('n', leader .. 'e', toggle_tree_focus, opts)
        vim.keymap.set('n', leader .. 'у', toggle_tree_focus, opts)

        -- Если у вас лидер — пробел, можно продублировать для верности:
        if leader == " " then
            vim.keymap.set('n', '<Space>e', toggle_tree_focus, opts)
        end
    end
})

vim.keymap.set('n', '<leader>e', toggle_tree_focus, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>у', toggle_tree_focus, { noremap = true, silent = true })
