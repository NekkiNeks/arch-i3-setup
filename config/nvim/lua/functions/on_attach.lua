-- Создаем группу один раз вне функции
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup, -- 👈 передаем ID группы, а не строку
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end

return on_attach
