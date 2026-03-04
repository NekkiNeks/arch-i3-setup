-- Включить нумерацию строк
vim.o.number = true
vim.o.relativenumber = true

-- Настройки табуляции
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Используем только цвета терминала (16 цветов)
vim.o.termguicolors = false

-- Кнопка leader теперь Space
vim.g.mapleader = ' '

-- Кеймаппинг на русскую раскладку
vim.opt.langmap =
"йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ.\\,;qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM\\,<.>/?"
-- Включаем подсветку синтаксиса (без темы, чтобы цвета были из терминала)
vim.cmd([[syntax enable]])

-- Отключаем смену фона, чтобы фон был как у терминала
vim.cmd([[highlight Normal ctermfg=white]])


-- Настройка цветов, чтобы они подтягивались из терминала
vim.cmd([[
  hi Normal          ctermfg=white
  hi Comment         ctermfg=yellow   cterm=italic
  hi Constant        ctermfg=cyan
  hi Identifier      ctermfg=green
  hi Statement       ctermfg=magenta
  hi PreProc         ctermfg=blue
  hi Type            ctermfg=cyan
  hi Special         ctermfg=red
  hi Underlined      ctermfg=blue     cterm=underline
  hi Error           ctermfg=white    ctermbg=red        cterm=bold
  hi Todo            ctermfg=black    ctermbg=yellow

  hi CursorLine      ctermbg=black    cterm=none
  hi CursorColumn    ctermbg=black    cterm=none
  hi Visual          ctermbg=cyan     cterm=none
  hi LineNr          ctermfg=blue
  hi StatusLine      ctermfg=white    ctermbg=black
  hi VertSplit       ctermfg=white    ctermbg=black
  hi Pmenu           ctermfg=white    ctermbg=black
  hi PmenuSel        ctermfg=black    ctermbg=yellow
  hi Search          ctermfg=black    ctermbg=yellow

  hi TSFunction      ctermfg=green
  hi TSVariable      ctermfg=white
  hi TSKeyword       ctermfg=magenta
  hi TSString        ctermfg=cyan
  hi TSComment       ctermfg=yellow   cterm=italic
  hi TSConstant      ctermfg=cyan
  hi TSOperator      ctermfg=magenta

]])
