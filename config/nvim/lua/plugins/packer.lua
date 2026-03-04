-- Обьявление переменных
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- Если плагина нет, то установить
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.cmd("packadd packer.nvim")
end

-- Включение плагина ПОСЛЕ того как он загрузится
local packer = require("packer")

-- Подключение плагинов
packer.startup(function(use)
    -- [PACKER]
    -- старт самого менеджера плагинов
    use("wbthomason/packer.nvim")

    -- [TREESITTER]
    -- Подсветка синтаксиса
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function() require("plugins.treesitter") end,
    })

    -- [NVIM-TREE]
    -- Дерево файлов
    use {
        'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' }, -- иконки
        config = function() require('plugins.nvim-tree') end,
    }

    -- [TELESCOPE]
    -- Переключение файлов в стиле "Строки команд"
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function() require('plugins.telescope') end,
    }

    -- [NEOSCROLL]
    -- Плавное перематывание при перемещении
    use {
        'karb94/neoscroll.nvim',
        config = function() require('plugins.neoscroll') end,
    }

    -- [LSP CONFIG]
    -- настройка LSP серверов
    use {
        'neovim/nvim-lspconfig',
        config = function() require('plugins.lspconfig') end,
    }

    -- [CMP]
    -- основной движок автодополнения
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',     -- LSP источник для nvim-cmp
            'hrsh7th/cmp-buffer',       -- автодополнение из буфера
            'hrsh7th/cmp-path',         -- автодополнение путей
            'hrsh7th/cmp-cmdline',      -- автодополнение командной строки
            'saadparwaiz1/cmp_luasnip', -- автодополнение сниппетов
        },
        config = function() require('plugins.cmp') end,
    }

    -- [LUASNIP]
    -- сниппеты
    use {
        'L3MON4D3/LuaSnip',
    }

    -- [MASON]
    -- менеджер LSP-серверов
    use {
        'williamboman/mason.nvim',
        config = function() require('plugins.mason') end,
    }

    use 'williamboman/mason-lspconfig.nvim' -- интеграция mason + lspconfig

    -- [COMMENT]
    -- быстрые комментарии
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end,
    }

    -- [INDENT BLANKLINE]
    -- Вертикальные линии для областей видимости
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function() require('plugins.ibl') end,
    }

    -- [AUTOPAIRS]
    -- Автоматические скобки и ковычки
    use {
        "windwp/nvim-autopairs",
        config = function() require('plugins.autopairs') end,
    }


    -- [AUTOPAIRS]
    -- Автоматические скобки и ковычки
    use {
        "ap/vim-css-color",
    }

    -- [HEXOKINASE]
    -- Подсветка HEX строчек с цветами на основе 256 цветной палитры
    -- use {
    --     "RRethy/vim-hexokinase",
    --     config = function() require('plugins.hexokinase') end,
    -- }

    -- Можно добавить сюда другие плагины
end)
