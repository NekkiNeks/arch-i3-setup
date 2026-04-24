-- Список серверов
local servers = {
    "lua_ls",
    "ts_ls",
    "clangd",
    "pyright",
    "bashls",
    "gopls",
    "rust_analyzer",
    "html",
    "cssls",
}

for _, name in ipairs(servers) do
    -- Получаем доступ к объекту конфигурации
    local config = vim.lsp.config[name]

    if config then
        -- Если нужно добавить специфичные настройки (settings)
        if name == "lua_ls" then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            })
        elseif name == "cssls" then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                css = { validate = true },
                less = { validate = true },
                scss = { validate = true },
            })
        end

        -- Включаем сервер (в 0.11 передается только имя)
        vim.lsp.enable(name)
    else
        -- На всякий случай выведем предупреждение, если сервер не найден в реестре
        vim.notify("LSP: Server " .. name .. " not found in vim.lsp.config", vim.log.levels.WARN)
    end
end
