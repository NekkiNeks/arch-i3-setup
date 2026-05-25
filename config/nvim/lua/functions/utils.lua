local M = {}
-- Только форматирование
M.format_code = function()
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.format({ bufnr = 0, async = false, lsp_fallback = true })
    else
        -- Если conform нет, пробуем встроенный LSP
        vim.lsp.buf.format({ async = false })
    end
end

-- Только сохранение (с выходом из Insert)
M.save_file = function()
    if vim.api.nvim_get_mode().mode == 'i' then
        vim.cmd("stopinsert")
    end
    -- silent! чтобы не ругался в лог, если сохранять нельзя (например, в дереве)
    vim.cmd("silent! write")
    vim.notify("[S]", vim.log.levels.INFO)
end

-- Сохранить и Форматировать (использует функции выше)
M.save_and_format = function()
    M.format_code() -- Сначала причесываем
    M.save_file()   -- Затем сохраняем
    vim.notify("[S&F]", vim.log.levels.INFO)
end

-- Показ документации
M.show_documentation = function()
    local ft = vim.bo.filetype
    if ft == "NvimTree" or ft == "" then return end
    vim.lsp.buf.hover({ border = "single" })
end

-- Перейти к определению
M.go_to_definition = function()
    local ok, telescope = pcall(require, "telescope.builtin")
    if ok then
        -- Используем Telescope: он откроет список, если определений много,
        -- и закроется сразу после того, как ты нажмешь Enter на нужном.
        telescope.lsp_definitions({
            initial_mode = "normal", -- Чтобы сразу можно было выбирать стрелками/jk
            layout_strategy = "vertical",
            layout_config = { width = 0.8, height = 0.7 },
            -- Принудительно ставим рамку для окна Telescope
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        })
    else
        -- Если Telescope не установлен, используем стандартный метод
        vim.lsp.buf.definition()
    end
end

--  Показать упоминания (Везде где используется функция или переменная)
M.go_to_references = function()
    local ok, telescope = pcall(require, "telescope.builtin")
    if ok then
        telescope.lsp_references({
            initial_mode = "normal",
            include_declaration = false, -- не показывать само объявление, если не нужно
        })
    else
        vim.lsp.buf.references()
    end
end

-- Красивое открытие диагностики (ошибок)
M.open_diag_float = function()
    vim.diagnostic.open_float({
        focusable = true,
        border = "single",
        -- Принудительно задаем группу для рамки прямо здесь
        winhighlight = "FloatBorder:DiagnosticFloatingError,Normal:NormalFloat"
    })
end

M.jump_diagnostic = function(direction)
    vim.diagnostic.jump({ count = direction, float = true })
end

--- Умное закрытие буфера без закрытия окна
M.close_buffer_safely = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo.filetype

    -- 1. Не закрываем nvim-tree этой командой
    if ft == "NvimTree" then
        return
    end

    -- 2. Если буфер изменен (есть несохраненные правки)
    if vim.bo.modified then
        local choice = vim.fn.confirm("Файл не сохранен. Закрыть?", "&Да\n&Нет", 2)
        if choice ~= 1 then return end
    end

    -- 3. Логика переключения
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

    if #listed_buffers > 1 then
        -- Если есть другие буферы, переключаемся на соседний (предыдущий)
        vim.cmd("bp")
        -- Удаляем целевой буфер по ID
        vim.cmd("bd! " .. bufnr)
    else
        -- Если это последний буфер, просто удаляем его
        -- (Окно не закроется, если открыто nvim-tree или останется пустой буфер)
        vim.cmd("bd!")
    end
end

-- Запуск в отдельном "потоке"
M.run_async = function(cb)
    vim.schedule(function()
        cb()
    end)
end

-- Проверка на гласную
M.is_vowel = function(c)
    return c:lower():match("[aeiou]") ~= nil
end

-- Проверка на согласную
M.is_consonant = function(c)
    return c:lower():match("%a") and not M.is_vowel(c)
end

-- Убрать все гласные из слова и сократить его
M.remove_vowels = function(word)
    if type(word) ~= "string" then
        return "***"
    end

    local res = ""

    for i = 1, #word do
        local symbol = word:sub(i, i)

        -- Если символ согласный, то добавить его в результат
        if M.is_consonant(symbol) then
            res = res .. symbol
        end
    end

    return res
end

-- Вывод дебага в лог файл
M.debug_log = function(data, raw)
    local path = "/home/nekzie/.config/nvim/debug.log"

    local log = io.open(path, "a")

    if not log then
        -- попытка создать файл вручную и открыть снова
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
        log = io.open(path, "a")

        if not log then
            return
        end
    end

    -- Если передан второй аргумент, то печатается то что передано
    local data_to_print
    if raw then
        data_to_print = tostring(data)
    else
        data_to_print = vim.inspect(data)
    end

    log:write(data_to_print .. "\n")
    log:flush()
    log:close()
end


return M
