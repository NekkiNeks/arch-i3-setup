local on_attach = require("functions/on_attach")

-- Список серверов
local servers = {
    "lua_ls",
    "ts_ls",
    "clangd",
    "pyright",
    "bashls",
    "gopls",
    "rust_analyzer"
}

for _, lsp in ipairs(servers) do
    -- Получаем объект конфигурации
    local config = vim.lsp.config[lsp]
    
    if config then
        -- Настраиваем параметры
        local server_opts = {
            on_attach = on_attach,
        }

        -- Специфические настройки для Lua
        if lsp == "lua_ls" then
            server_opts.settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            }
        end

        -- В версиях 0.11+ используется функция vim.lsp.enable
        -- вместо старого lspconfig[lsp].setup()
        vim.lsp.enable(lsp, server_opts)
    else
        print("LSP: Конфигурация для " .. lsp .. " не найдена")
    end
end
