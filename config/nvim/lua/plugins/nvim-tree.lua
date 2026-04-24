local api = require('nvim-tree.api')
-- Функция для переключения фокуса между окном кода и деревом файлов
local function toggle_tree_focus()
    if vim.bo.filetype == "NvimTree" then
        vim.cmd("wincmd p")
    else
        api.tree.focus()
    end
end

-- Кастомная функция которая в начале
local function custom_on_attach(bufnr)
    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.opt_local.guicursor = "n-v-c:block-NvimTreeCursor,i-ci-ve:ver25"
    vim.cmd('highlight NvimTreeCursor ctermbg=8 ctermfg=8')

    -- Обязательные дефолтные маппинги
    api.config.mappings.default_on_attach(bufnr)

    -- Ваши текущие маппинги
    vim.keymap.set('n', '<Tab>', toggle_tree_focus, opts('Toggle Focus Back'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'р', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'д', api.node.open.edit, opts('Open'))

    -- --- ДОПОЛНЕНИЯ: Блокировка горизонтального движения ---

    -- Блокируем стрелки
    vim.keymap.set('n', '<Left>', '<Nop>', opts('Do Nothing'))
    vim.keymap.set('n', '<Right>', '<Nop>', opts('Do Nothing'))

    -- Блокируем w и e
    vim.keymap.set('n', 'w', '<Nop>', opts('Do Nothing'))
    vim.keymap.set('n', 'ц', '<Nop>', opts('Do Nothing'))
    vim.keymap.set('n', 'у', '<Nop>', opts('Do Nothing'))

    -- Блокируем пробел и backspace
    vim.keymap.set('n', '<BS>', '<Nop>', opts('Do Nothing'))
end

-- Файлы и папки которые по умолчанию не отображаются в nvim-tree
local filtered_files_and_folders = { ".git", ".vscode", ".expo" }

require("nvim-tree").setup({

    -- Функция которая выполняется при запуске. В ней можно определять хоткеи и другие настройки
    on_attach = custom_on_attach,

    -- Фильтрация отображаемых папок и файлов
    filters = {
        custom = filtered_files_and_folders
    },

    -- Отображение файлов в .gitignore
    git = {
        ignore = true,
    },

    -- Настройки вида
    view = {
        width = 45,
        cursorline = true,
        relativenumber = true,
        signcolumn = "yes",
    },

    -- Настройки рендера
    renderer = {
        highlight_git = true,

        -- Отрисовка иконок у файлов
        icons = {
            show = {
                git = false,
            },
        },
        -- Отрисовка уровней вложенности
        indent_markers = {
            enable = true,
            inline_arrows = false,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
    },

    --  Отображение иконок в дереве рядом с проблемными файлами
    diagnostics = {
        enable = true,       -- Включает иконки ошибок в дереве
        show_on_dirs = true, -- Показывать ошибку на папке, если она внутри
        icons = {
            hint = "󰠠",
            info = "",
            warning = "",
            error = "",
        }
    }
})

return toggle_tree_focus
