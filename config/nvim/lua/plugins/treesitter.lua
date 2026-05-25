-- [TREESITTER]
-- Подсветка синтаксиса

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "bash", "typescript", "css", "rust", "go", "html", "json", "json5", "jsonc", "vim" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

