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

for _, name in ipairs(servers) do
    local config = vim.lsp.config[name]

    if config then
        -- opts теперь пустой или содержит только settings
        local opts = {}

        if name == "lua_ls" then
            opts.settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            }
        end

        -- Включаем сервер
        vim.lsp.enable(name, opts)
    end
end
