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


-- Время задержки времени для того чтобы понять будет ли
-- нажата еще какая нибудь кнопка после Пробела так как он Leader
vim.o.timeoutlen = 500 -- Время ожидания команды в миллисекундах

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
-- Предложенное ChatGPT (Проверить) --

-- Использование плагина vim-css-color для всех файлов
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*",
    callback = function()
        local name = vim.fn.expand("%:t")
        local ignore = { dunstrc = true, config = true, auth = true }

        if vim.fn.expand("%:e") == "" and vim.bo.filetype == "" and not ignore[name] then
            vim.bo.filetype = "xdefaults"
            vim.cmd("runtime! after/syntax/css.vim")
            pcall(vim.fn["css_color#init"])
        end
    end,
})
