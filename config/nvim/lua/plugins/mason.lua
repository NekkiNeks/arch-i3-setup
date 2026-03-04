require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",        -- lua (ранее sumneko_lua)
    "ts_ls",         -- js и ts
    "clangd",        -- c, c++
    "pyright",       -- python
    "bashls",        -- bash
    "gopls",         -- go
    "rust_analyzer", -- rust
  },
  automatic_installation = true,
})
