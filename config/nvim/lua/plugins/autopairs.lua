local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

require("nvim-autopairs").setup {
    check_ts = true, -- включить поддержку treesitter
}

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
