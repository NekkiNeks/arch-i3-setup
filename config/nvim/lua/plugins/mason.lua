require("mason").setup()

-- Список LSP серверов для автоустановки
local servers = {
    "lua_ls",
    "ts_ls",
    "clangd",
    "pyright",
    "bashls",
    "gopls",
    "rust_analyzer",
    "html",
    "cssls"
}

require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- ВАЖНО: После Mason мы запускаем наш цикл инициализации LSP (который мы правили ранее)
-- Если ваш код с vim.lsp.enable лежит в отдельном файле, вызовите его здесь:
require("plugins.lspconfig")
