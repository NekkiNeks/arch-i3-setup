local function set_colors()
    -- Помощник для установки цветов
    local hl = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- --- 1. РАМКИ (Строго серые) ---
    local borders = {
        "FloatBorder",
        "LspInfoBorder",
        "LspFloatingHover"
    }
    for _, group in ipairs(borders) do
        hl(group, { ctermfg = 8, ctermbg = "NONE" })
    end

    -- --- 2. ТЕКСТ ВНУТРИ ОКОН (Диагностика) ---
    -- Убираем принудительный цвет для NormalFloat, чтобы работал синтаксис
    hl("NormalFloat", { ctermbg = "NONE" })

    -- Явно задаем цвета для текста ошибок и предупреждений в окнах
    hl("DiagnosticFloatingError", { ctermfg = "red" })
    hl("DiagnosticFloatingWarn", { ctermfg = "yellow" })
    hl("DiagnosticFloatingInfo", { ctermfg = "white" })
    hl("DiagnosticFloatingHint", { ctermfg = "cyan" })

    -- --- 3. ОСНОВНОЙ СИНТАКСИС (Твой терминальный стиль) ---
    hl("Normal", { ctermfg = "white", ctermbg = "NONE" })
    hl("Comment", { ctermfg = "yellow", cterm = { italic = true } })
    hl("Constant", { ctermfg = "cyan" })
    hl("Identifier", { ctermfg = "green" })
    hl("Statement", { ctermfg = "magenta" })
    hl("PreProc", { ctermfg = "blue" })
    hl("Type", { ctermfg = "cyan" })
    hl("Special", { ctermfg = "red" })
    hl("Underlined", { ctermfg = "blue", cterm = { underline = true } })
    hl("Error", { ctermfg = "white", ctermbg = "red", cterm = { bold = true } })
    hl("Todo", { ctermfg = "black", ctermbg = "yellow" })

    -- Интерфейс
    hl("CursorLine", { ctermbg = "NONE" })
    hl("Visual", { ctermbg = "cyan", ctermfg = "black" })
    hl("LineNr", { ctermfg = "blue" })
    hl("StatusLine", { ctermfg = "white", ctermbg = "black" })
    hl("Pmenu", { ctermfg = "white", ctermbg = "black" })
    hl("PmenuSel", { ctermfg = "black", ctermbg = "yellow" })
    hl("Search", { ctermfg = "black", ctermbg = "yellow" })

    -- --- 4. TREESITTER (Современные токены) ---
    local ts = {
        ["@function"] = { ctermfg = "green" },
        ["@variable"] = { ctermfg = "white" },
        ["@keyword"]  = { ctermfg = "magenta" },
        ["@string"]   = { ctermfg = "cyan" },
        ["@constant"] = { ctermfg = "cyan" },
        ["@operator"] = { ctermfg = "magenta" },
        ["@comment"]  = { ctermfg = "yellow", cterm = { italic = true } },
    }
    for group, opts in pairs(ts) do hl(group, opts) end
end

-- Включаем синтаксис и применяем цвета
vim.cmd("syntax enable")
set_colors()

-- Автокоманда, чтобы настройки не слетали при смене темы
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_colors
})
