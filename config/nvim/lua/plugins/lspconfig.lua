-- [LSP CONFIG]
-- Прямая настройка и запуск LSP серверов (без циклов)

--------------------------------------------
-- 1. Серверы со специфичными настройками
--------------------------------------------

-- Lua
vim.tbl_deep_extend("force", vim.lsp.config.lua_ls, {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
        },
    },
})
vim.lsp.enable("lua_ls")

-- CSS
vim.tbl_deep_extend("force", vim.lsp.config.cssls, {
    settings = {
        css = { validate = true },
        less = { validate = true },
        scss = { validate = true },
    },
})
vim.lsp.enable("cssls")

-- Clangd
vim.tbl_deep_extend("force", vim.lsp.config.clangd, {
    cmd = { "--background-index" },
})
vim.lsp.enable("clangd")

--------------------------------------------
-- 2. Серверы со стандартными настройками
--------------------------------------------
local default_servers = {
    "ts_ls",
    "pyright",
    "bashls",
    "gopls",
    "rust_analyzer",
    "html",
}

for _, name in ipairs(default_servers) do
    vim.lsp.enable(name)
end
