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

" :T and :VT open terminals in new buffer instead of current
command! T split | terminal
command! VT vsplit | terminal

function! s:TermEnter(_)
  if getbufvar(bufnr(), 'term_insert', 0)
    startinsert
    call setbufvar(bufnr(), 'term_insert', 0)
  endif
endfunction

function! <SID>TermExec(cmd)
  let b:term_insert = 1
  execute a:cmd
endfunction

augroup Term
  au CmdlineLeave,WinEnter,BufWinEnter * call timer_start(0, function('s:TermEnter'), {})
  au TermEnter term://* setlocal nonu nornu
  au TermLeave term://* setlocal nu rnu
augroup end

" map vim-like motions for terminal
tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-.>  <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExec('call feedkeys(":")')<CR>
tnoremap <silent> <C-W><C-W>  <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W>h      <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W>j      <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W>k      <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W>l      <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W><C-H>  <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W><C-J>  <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W><C-K>  <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W><C-L>  <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>gt     <cmd>call <SID>TermExec('tabn')<CR>
tnoremap <silent> <C-W>gT     <cmd>call <SID>TermExec('tabp')<CR
