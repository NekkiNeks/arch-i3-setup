-- Вроде как лишний конфиг, плагина для него нет...



-- Выключаем termguicolors, чтобы тема Xresources жила
vim.opt.termguicolors = false

-- Говорим плагину использовать встроенный механизм вместо бинарника
vim.g.Hexokinase_executable_path = '' 

-- Настраиваем способ отображения
-- В режиме 256 цветов лучше всего работает 'virtual' (квадратик рядом с кодом)
-- или 'background' (закрашивание фона текста)
vim.g.Hexokinase_highlighters = { 'background' }

-- Какие форматы искать
vim.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba'

-- Принудительно включаем для всех файлов
vim.g.Hexokinase_ftEnabled = { '*' }
