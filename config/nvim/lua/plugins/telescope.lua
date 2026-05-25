-- [TELESCOPE]
-- Переключение файлов в стиле "Строки команд"

local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "➤ ",
        path_display = { "smart" },

        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
                ["q"] = actions.close,
            },
        },
    },
    pickers = {
        find_files = {
            theme = "dropdown",
        },
        live_grep = {},
        buffers = {},
        help_tags = {},
    },
    extensions = {
        -- Тут можно подключать расширения
    },
}

