" VIM Configuration

" General

" Install Plugins
call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'

call plug#end()

" Color Scheme
set background = "dark" " dark mode
set termguicolors " use 24 bit colors
syntax enable " enable syntax highlighting
colorscheme base16-$PROFILE_NAME " sync colorscheme with DDev theme


" Key Bindings
let mapleader = "," " use comma as leader key 
