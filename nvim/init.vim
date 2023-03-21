set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

let confdir=$HOME."/dotfiles/nvim/"

source ~/dotfiles/editor_configs/general_editor_config.vim

" download and install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/bundle')

source ~/dotfiles/editor_configs/vim_plugins_list.vim

" Plugin list end
call plug#end()

source ~/dotfiles/editor_configs/vim_plugins_conf.vim

" temrinal settings for vim-like operation
tnoremap <C-w><C-n> <C-\><C-n> 
tnoremap <C-w>h <C-\><C-n><C-w>h 
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" :T and :VT open terminals in new buffer instead of current
command! T split | terminal
command! VT vsplit | terminal

aug terminal_config
  au!
  au TermOpen * set filetype=terminal
  " leave terminal running when leaving
  au BufLeave terminal :insert 
aug END

