local opts = { noremap = true, silent = true }
local utils = require("functions/utils")

-- Сохранить и форматировать на привычные C-s / C-ы
vim.keymap.set({ "n", "i", "v" }, "<C-s>", utils.save_and_format, { desc = "Save & Format" })
vim.keymap.set({ "n", "i", "v" }, "<C-ы>", utils.save_and_format, { desc = "Save & Format (RU)" })

-- Только форматировать на leader + f
vim.keymap.set({ 'n', 'i', 'v' }, "<leader>f", utils.format_code, { desc = "Only Format" })
vim.keymap.set({ 'n', 'i', 'v' }, "<leader>а", utils.format_code, { desc = "Only Format (RU)" })

-- Только сохранить на leader + w (иногда полезно без форматирования)
vim.keymap.set({ 'n', 'i', 'v' }, "<leader>w", utils.save_file, { desc = "Only Save" })
vim.keymap.set({ 'n', 'i', 'v' }, "<leader>ц", utils.save_file, { desc = "Only Save (RU)" })

-- Открыть/закрыть дерево nvim-tree
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>е', ':NvimTreeToggle<CR>', opts)

-- Взаимодействие с Telescope, ':Telescope find_files<CR>', opts)
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', opts)
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', opts)

-- Биндинги для комбинаций с Ctrl
-- Ctrl+в → Ctrl+d
vim.keymap.set({ 'n', 'i', 'v' }, '<C-в>', '<C-d>', opts)
-- Ctrl+г → Ctrl+u
vim.keymap.set({ 'n', 'i', 'v' }, '<C-г>', '<C-u>', opts)

-- Предложенное ChatGPT (Проверить) --

-- [HOVER] Перейти к определению [gd или F12]
vim.keymap.set('n', 'gd', utils.go_to_definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'пв', utils.go_to_definition, { desc = "Go to Definition (RU)" })
vim.keymap.set('n', '<F12>', utils.go_to_definition, { desc = "Go to Definition" })

-- [HOVER] Показать упоминания [gr]
vim.keymap.set('n', 'gr', utils.show_references, { desc = "Go to References" })
vim.keymap.set('n', 'пк', utils.show_references, { desc = "Go to References (RU)" })

-- [HOVER] Описание сущности [Leader + k или Shift + k]
vim.keymap.set('n', '<leader>k', utils.show_documentation, { desc = "LSP Documentataion", nowait = true })
vim.keymap.set('n', '<leader>л', utils.show_documentation, { desc = "LSP Documentataion (RU)", nowait = true })
vim.keymap.set('n', 'K', utils.show_documentation, { desc = "LSP Documentataion", nowait = true })

-- [HOVER] Открыть окно с ошибкой
vim.keymap.set('n', '<leader>r', utils.open_diag_float, { desc = "Open Diagnostic", nowait = true })
vim.keymap.set('n', '<leader>к', utils.open_diag_float, { desc = "Open Diagnostic (RU)", nowait = true })

-- Навигация по ошибкам [Leader + [ и Leader + [ ]
vim.keymap.set('n', '<leader>]', function() utils.jump_diagnostic(1) end, { desc = "Next Diagnostic" })
vim.keymap.set('n', '<leader>[', function() utils.jump_diagnostic(-1) end, { desc = "Prev Diagnostic" })
vim.keymap.set('n', '<leader>ъ', function() utils.jump_diagnostic(1) end, { desc = "Next Diagnostic (RU)" })
vim.keymap.set('n', '<leader>х', function() utils.jump_diagnostic(-1) end, { desc = "Prev Diagnostic (RU)" })

-- Управление вкладками bufferline
-- Переместиться влево
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', 'Р', ':BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })

-- Переместиться вправо
vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', 'Д', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })

-- Закрыть вкладку
vim.keymap.set('n', '<Leader>o', utils.close_buffer_safely, { desc = 'Close buffer' })
vim.keymap.set('n', '<Leader>щ', utils.close_buffer_safely, { desc = 'Close buffer' })


-- Глобальный костыль для закрытия любых плавающих окон на 'й'
vim.keymap.set('n', 'й', function()
    -- Проверяем, является ли текущее окно плавающим
    local win_config = vim.api.nvim_win_get_config(0)
    if win_config.relative ~= "" then
        vim.cmd("close")
    else
        -- Если окно обычное, просто вводим 'q' (макрос), чтобы не ломать логику Vim
        vim.api.nvim_feedkeys('q', 'n', false)
    end
end, { desc = "Закрыть плавающее окно на русскую й" })


-- Обновить конфигурацию без перезапуска
vim.keymap.set("n", "<leader>u", function()
    -- Сбрасываем кэш твоих модулей
    for name, _ in pairs(package.loaded) do
        if name:match("^plugins") or name:match("^functions") or name == "config" or name == "keymaps" then
            package.loaded[name] = nil
        end
    end
    -- Перезагружаем основной файл
    vim.cmd("source " .. vim.env.MYVIMRC)
    vim.notify("Конфигурация обновлена!", vim.log.levels.INFO)
end, { desc = "Reload config" })
vim.keymap.set("n", "<leader>г", "<leader>u", { remap = true })
