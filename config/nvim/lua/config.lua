local utils = require("functions/utils")

-- Включить нумерацию строк
vim.o.number = true
vim.o.relativenumber = true

-- Настройки табуляции
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Используем только цвета терминала (16 цветов)
vim.o.termguicolors = false

-- Использование системного буфера
vim.opt.clipboard = "unnamedplus"

-- Кнопка leader теперь Space
vim.g.mapleader = ' '

-- Кеймаппинг на русскую раскладку
vim.opt.langmap =
"йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ.\\,;qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM\\,<.>/?"

-- Сохранение при выходе из INSERT MODE

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
    group = vim.api.nvim_create_augroup("IdeActions", { clear = true }),
    pattern = "*",
    callback = function()
        -- Сохраняем ТОЛЬКО если:
        -- 1. Файл изменен (modified)
        -- 2. Это обычный файл (не дерево, не терминал)
        -- 3. Файл можно редактировать (modifiable)
        if vim.bo.modified and vim.bo.buftype == "" and vim.bo.modifiable then
            utils.save_and_format()
        end
    end,
})

-- Предложенное ChatGPT (Проверить) --


--  Отображение ошибок на строке (Virtual Text)
vim.diagnostic.config({
    -- virtual_text = {
    --     prefix = '●', -- Символ перед текстом ошибки
    --     source = "always", -- Показывать, какой именно LSP выдал ошибку
    -- },
    virtual_text = true, -- Подскахки на строке
    signs = true,        -- Значки на полях
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    -- А вот здесь мы зададим рамку для окон с описанием ошибок
    float = {
        border = "single",
        source = "if_many",
        severity_sort = true,
    },
})

-- -- Включение и выключение курсорной строки
-- local nvim_tree_group = vim.api.nvim_create_augroup("NvimTreeCursorLine", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--     group = nvim_tree_group,
--     pattern = "NvimTree",
--     callback = function()
--         vim.opt_local.cursorline = true
--     end,
-- })
--
-- -- Опционально: если хотите, чтобы в обычных файлах её точно НЕ БЫЛО
-- vim.api.nvim_create_autocmd("BufEnter", {
--     group = nvim_tree_group,
--     callback = function()
--         if vim.bo.filetype ~= "NvimTree" then
--             vim.opt_local.cursorline = false
--         end
--     end,
-- })
