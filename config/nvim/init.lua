require("plugins.packer")
require("config")
require("keymaps")
require("commands")
require("colors")

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = "single" -- Всегда тонкая рамка
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
