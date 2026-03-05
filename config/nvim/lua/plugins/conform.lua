local status_ok, conform = pcall(require, "conform")
if not status_ok then return end

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        c = { "clang-format" },
        cpp = { "clang-format" },
    },
    format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    },
})

-- Если автоматика не срабатывает, давай добавим команду принудительно
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        -- Пробуем сначала сохранить
        vim.cmd("silent! update")
        -- Затем форматируем (если update что-то изменил)
        conform.format({ bufnr = 0, async = true })
    end,
})
