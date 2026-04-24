set notermguicolors
set relativenumber
set number

syntax enable

" Устанавливаем vim-plug
call plug#begin('~/.config/vim/plugged')

" Здесь ты будешь добавлять свои плагины
" Пример плагина:
"
Plug 'preservim/nerdtree'
Plug 'tpope/vim-sensible'
"Plug 'lyokha/vim-xkbswitch'

" Настройки vim-xkbswitch
" let g:XkbSwitchEnabled       = 1
" let g:XkbSwitchLib           = '/usr/local/sway-vim-kbdswitch/libswaykbswitch.so'
" let g:XkbSwitchAssistNKeymap = 1    
" let g:XkbSwitchIMappings = ['ru']
" let g:XkbSwitchKeymapNames = {'Russian' : 'ru'}
" set keymap=russian-jcukenwin

call plug#end()

