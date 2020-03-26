" VIM Configuration

" General
set mouse=a      " allow mouse controls for all modes
set backspace=2  " allow backspacing over end of lines
set number       " show line numbers
set cursorline   " highlight current line
set ignorecase   " case insensitive searches
set smartcase    " case sensitive if upper case letters are included
set lazyredraw   " redraw the screen less

" Install Plugins
call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'  " library of colorschemes that match DDev shell themes
Plug 'itchyny/lightline.vim'    " lightweight Powerline for Vim
Plug 'tpope/vim-fugitive'       " Git integration
Plug 'tpope/vim-eunuch'         " common Unix commands
Plug 'tpope/vim-surround'       " interact with 'surroundings' like quotes or parentheses
Plug 'tpope/vim-repeat'         " add repeat (.) compatibility for many plugins

call plug#end()

" itchyny/lightline.vim
set noshowmode  " disable default mode label since lightline has it's own
function! LightlineFullPath()  " full file path with trunctation logic
    return winwidth(0) > 70 ? expand('%') : ''
endfunction

let g:lightline = {
  \   	'colorscheme': 'ddev',
  \     'active': {
  \         'left': [['mode', 'paste' ], ['filename', 'modified'], ['git']],
  \         'right': [['lineinfo'], ['percent'], ['filepath']]
  \     },
  \     'component_function': {
  \         'git': 'fugitive#head',
  \         'filepath': 'LightlineFullPath',
  \         'lineinfo': 'LightlineLineInfo',
  \     },
  \     'separator': { 'left': $DDEV_POWERLINE_RIGHT_ARROW, 'right': $DDEV_POWERLINE_LEFT_ARROW },
  \     'subseparator': { 'left': $DDEV_POWERLINE_RIGHT_ARROW_THIN, 'right': $DDEV_POWERLINE_LEFT_ARROW_THIN },
  \ }

command! LightlineReload call LightlineReload()  " Reload lightline, for use with ddev sync
function! LightlineReload()
  execute 'source' globpath(&rtp, 'autoload/lightline/colorscheme/ddev.vim')
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

" Color Scheme
set background = "dark"  " dark mode
set termguicolors        " use 24 bit colors
syntax enable            " enable syntax highlighting

augroup CustomColors
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=none  " sync background with TMUX window-active-style
augroup END
colorscheme base16-$PROFILE_NAME  " sync colorscheme with DDev theme

" Key Bindings
let mapleader = ","  " use comma as leader key 
