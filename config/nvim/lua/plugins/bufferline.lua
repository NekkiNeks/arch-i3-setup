require("bufferline").setup({
    options = {
        mode = "buffers",
        middle_mouse_command = "bdelete! %d",
        -- Чтобы убрать вертикальные линии, лучше использовать 'flat'
        -- или пустые строки, если кастомный стиль не срабатывает
        separator_style = { "", "" },

        -- Убираем индикатор (ту самую белую линию/символ слева)
        indicator = {
            style = 'none',
        },

        -- Убираем иконки закрытия (крестики)
        show_buffer_close_icons = false,
        show_close_icon = false,

        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            }
        },
    },
    highlights = {
        fill = {
            ctermbg = 'NONE',
        },
        -- Принудительно убираем цвета индикатора для выбранного буфера
        indicator_selected = {
            ctermfg = 'NONE',
            ctermbg = 'NONE',
        },
        -- Выбранная вкладка (твой серый фон color0)
        buffer_selected = {
            ctermbg = 8,
            ctermfg = 15,
            bold = true,
        },
        -- Убираем разделители между вкладками
        separator = {
            ctermfg = 'NONE',
            ctermbg = 'NONE',
        },
        separator_selected = {
            ctermfg = 'NONE',
            ctermbg = 0,
        },
    }
})
