set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" download and install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/bundle')

source ~/dotfiles/vim_plugins_list.vim

" Plugin list end
call plug#end()

source ~/dotfiles/vim_plugins_conf.vim
