-- Настройки для вертикальных черточек из ibl-плагина
vim.api.nvim_set_hl(0, "MyIndentLine", { ctermfg = 8 })
vim.api.nvim_set_hl(0, "MyIndentScope", { ctermfg = 8 })

require("ibl").setup {
    indent = {
        char = "▏", -- можно заменить на "┊", "▏", "¦" или что тебе больше нравится
        highlight = "MyIndentLine", -- <- твоя пользовательская группа
    },
    scope = {
        enabled = true, -- Включает линии областей видимости
        show_start = false,
        show_end = false,
        highlight = "MyIndentScope", -- <- тоже твоя группа
    }
}
