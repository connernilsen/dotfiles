let &packpath = &runtimepath

let confdir=$HOME.'/dotfiles/nvim/'

set nocompatible " don't use vi compatibility
filetype plugin indent on " turn on indentation and plugins for recognized file types

let mapleader=' ' " sets <leader> to ' '

" tab settings
set shiftwidth=4 " number of spaces used in an auto indent step
set shiftround " << and >> round to shiftwidth
aug filetypes
    " clear all commands in this aug and recreate (otherwise they will be
    " duplicated)
    au!
    " files with the pattern TARGETS are python files
    " au BufNewFile,BufRead TARGETS set filetype=python
aug END
set expandtab tabstop=4
" NOTE: flip tabs/spaces with :retab


" visual settings
set number " show line numbers
aug numbertoggle
  au!
  " show absolute line number and relative line numbers for currently active window
  au BufWinEnter,FocusGained,InsertLeave,WinEnter * 
        \ if &number && mode() != 'i' 
        \ | set rnu 
        \ | endif
  " show absolute line number for inactive windows
  au BufWinLeave,FocusLost,InsertEnter,WinLeave * 
        \ if &number 
        \ | set nornu 
        \ | endif
aug END
set t_Co=256
set cursorline " light highlight for line showing cursor position
set incsearch " show current typed in stuff
set showmatch " jump to matching bracket
set hlsearch " set highlight for last search until :noh
if winheight(0) <= 32
  " when <= 32 lines in terminal, keep 5 lines between cursor and top or bottom
  set scrolloff=5
else
  " otherwise, dynamically scale number of lines between cursor and top or bottom
  let &scrolloff=float2nr(ceil(winheight(0)/4.5))
endif
set sidescrolloff=10 " number of cols to keep between cursor and left or right of buff
set sidescroll=1 " scroll one character at a time
set noshowmode " handled by lightline
set list  " show hidden characters
set lcs=tab:>-,trail:·,extends:>,precedes:< " markings to show for hidden characters

" behavior settings
set autoindent " automatically set indent of new line
set smartindent " clever autoindenting
set smartcase " ignore case when a capital letter appears
set ignorecase " mostly ignore case when searching (see smartcase)
set spell " highlight spelling mistakes
set laststatus=2 " always show status line
set visualbell " use visual bell instead of beeping
" create undo directory
let udir=confdir.'undo-dir'
if !isdirectory(udir)
  call mkdir(udir, '', 0700)
endif
set undofile " save and restore undo history when editing files
" set directory for storing and loading undofiles
set undodir=~/.config/nvim/undo-dir 
" create session directory (NOTE: this doesn't populate anything there)
let sdir=confdir.'session-dir/'
if !isdirectory(sdir)
  call mkdir(sdir, '', 0700)
endif
let g:workspace_session_directory=sdir " create a new workspace with \s
set completeopt=menu,preview,noinsert " when completing with Ctrl + N in insert mode, don't insert values
set nojs " don't use two spaces after joining a line ending with .
syntax enable " enable syntax highlighting
set splitbelow " split new windows on bottom
set splitright " split new windows to the right
set backspace=2 " backspace twice when editing eol/sol
set foldlevel=99 " open all folds when entering file
set colorcolumn=80 " set line length marker

" set clipboard settings (might need xclip)
if system('uname -s') == 'Darwin\n'
  set clipboard=unnamed "OSX
  set clipboard+=unnamedplus
else
  set clipboard+=unnamedplus
  set clipboard=unnamedplus "Linux
endif
set mouse=  " clicking won't move the cursor, and you can copy directly off the screen

" download and install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  echo "*********Installing vim-plug*********"
  " convert back to one line if this fails
  execute 
        \ '!curl -fLo '
        \ .data_dir
        \ .'/autoload/plug.vim --create-dirs 
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/bundle')

" Plugin list begin

Plug 'dracula/vim',{'name':'dracula'}  " theme
Plug 'itchyny/lightline.vim'           " meta info at bottom of screen
Plug 'thaerkh/vim-workspace'           " handle auto-resuming sessions when calling 'vim' in a dir after \s
Plug 'tpope/vim-commentary'            " make comments using gcc or <motion>gc
Plug 'preservim/vim-indent-guides'     " show indentation guides
Plug 'sheerun/vim-polyglot'            " language helpers
Plug 'psliwka/vim-smoothie'            " smooth scroll up/down/page/back
Plug 'godlygeek/tabular'               " align text (:Tabularize /<regex>/[lcr]<spacing>...)
Plug 'TaDaa/vimade'                    " dim inactive windows (config in after/plugin)
Plug 'ervandew/supertab'               " tab completion
" would like to switch to this at some point if possible (need to check FAQ to
" work with vim-visual-multi)
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " fuzzy completion
Plug 'junegunn/vim-peekaboo'           " check registers when ctrl + r
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                " fuzzy finder
Plug 'dense-analysis/ale'              " async lint engine
Plug 'maximbaz/lightline-ale'          " lightline support for ALE 
Plug 'google/vim-searchindex'          " count number of searches returned from / or ?
Plug 'chrisbra/NrrwRgn'                " narrow to selected region with :NW/NR
Plug 'pseewald/vim-anyfold'            " auto populate folds for many languages
Plug 'konfekt/fastfold'                " only update fold information on fold operations
Plug 'tpope/vim-surround'              " plugin for working with text objects
Plug 'kien/rainbow_parentheses.vim'    " match paranetheses with their rainbow colors
Plug 'will133/vim-dirdiff'             " diff a directory
Plug 'Matt-A-Bennett/vim-surround-funk' " text objects for functionsasdf
Plug 'svermeulen/vim-yoink'            " ring buffer for yanks with :Yanks
Plug 'mhinz/vim-signify'               " great source control info in gutter/with commands
" Plug 'puremourning/vimspector'         " debugger built into vim
Plug 'tpope/vim-scriptease'            " vim plugin for working with vim plugins (:PP, :Scriptnames, :Messages,...)
Plug 'jpalardy/vim-slime'              " send text to other terminal
Plug 'klafyvel/vim-slime-cells'        " interactive cells for languages (python and ocaml by default)
Plug 'sjl/gundo.vim'                   " show history tree with <F5>
" Plug 'mg979/vim-visual-multi'          " allows for Sublime/VSCode multi-cursor behavior
Plug 'easymotion/vim-easymotion'       " jump to any character anywhere with <leader>s
Plug 'ellisonleao/glow.nvim'

" Plugin list end
call plug#end()

let g:deoplete#enable_at_startup = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

let g:LargeFile = 1000000 " file is large if size greater than 1MB
aug anyfold
  au!
  au Filetype * AnyFoldActivate " activate folding for all filetypes
aug end
" disable anyfold for large files
au BufReadPre,BufRead * 
            \ let f=getfsize(expand('<afile>')) 
            \ | if f > g:LargeFile || f == -2 
            \ | call LargeFile() 
            \ | endif
function LargeFile()
  aug anyfold
    " remove AnyFoldActivate
    au! 
    au Filetype <filetype> setlocal foldmethod=indent " fall back to indent folding
  aug END
endfunction

" turn on indent guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=0
aug coloring
  au!
  " set color scheme and indent guides
  au VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=DarkGrey
  au BufWinEnter,WinEnter * let g:indent_guides_size=&shiftwidth
aug END

" format on save
let g:ale_fix_on_save = 1

" use enhanced coloring if possible
if (has('termguicolors'))
  set termguicolors
endif

" set color scheme
set background=dark
colorscheme dracula

let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \  'linter_checking': 'right',
      \  'linter_infos': 'right',
      \  'linter_warnings': 'warning',
      \  'linter_errors': 'error',
      \  'linter_ok': 'right',
      \ }

let g:lightline.active = {
      \ 'right': [ [ 'linter_checking', 'linter_errors', 
      \             'linter_warnings', 'linter_infos', 'linter_ok' ],
      \            [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'fileformat', 'filetype'], ],
      \ 'left':  [ [ 'mode', 'paste' ],
      \            [ 'readonly', 'filename', 'modified' ], ],
      \ }

" completion engine with ALE
set omnifunc=ale#completion#OmniFunc
" go to next errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


" turn on rainbow parentheses by default
aug rainbowparens
  au!
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
  au Syntax * RainbowParenthesesLoadChevrons
aug END

" peekaboo larger window
if winwidth(0) < 60
  let g:peekaboo_window='vert bo 30new'
else
  let g:peekaboo_window='vert bo '.float2nr(ceil(winwidth(0)/3)).'new'
endif

" yoink settings
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

" workspace settings
nnoremap <leader><leader>s :ToggleWorkspace<CR> " toggle tracking workspace
let g:workspace_session_disable_on_args=1 " when starting with a specific file, don't open workspace
let g:workspace_autosave=0 " don't autosave automatically
let g:workspace_persist_undo_history=0 " use vim default undo history

" ocaml settings (if opam and merlin installed)
if system('opam --version') && 
            \ system('opam list --installed --short --safe --color=never --check merlin')
  let g:opam_share_dir = 
              \ substitute(system('opam var share'),'[\r\n]*$','','''') . 
              \ '/merlin/vim'
  set rtp+=g:opam_share_dir
  set rtp^=g:opam_share_dir.'/ocp-indent/vim'
endif

" slime setup <C-c><C-c> to send over selection
" find tmux pane with <C-b>q and set with `:.<pane_num>`
" Note: can reset job id if channel number changes with <C-c>v
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_cell_delimiter = '^\\s*##'
let g:slime_bracketed_paste = 1
let g:slime_no_mappings = 1
nmap <c-c>v <Plug>SlimeConfig
nmap <c-c><c-c> <Plug>SlimeCellsSendAndGoToNext
" these won't work on mac
nmap <c-c><c-Down> <Plug>SlimeCellsNext
nmap <c-c><c-Up> <Plug>SlimeCellsPrev

" terminal settings for vim-like operation

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
    au CmdlineLeave,WinEnter,BufWinEnter * 
                \ call timer_start(0, function('s:TermEnter'), {})
    au TermEnter term://* setlocal nonu nornu
    au TermLeave term://* setlocal nu rnu
augroup end

" map vim-like motions for terminal
tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-.>  <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExec('call feedkeys(':')')<CR>
tnoremap <silent> <C-W><C-W>  <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W>h      <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W>j      <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W>k      <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W>l      <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>=      <cmd>call <SID>TermExec('wincmd =')<CR>
tnoremap <silent> <C-W><C-H>  <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W><C-J>  <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W><C-K>  <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W><C-L>  <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>gt     <cmd>call <SID>TermExec('tabn')<CR>
tnoremap <silent> <C-W>gT     <cmd>call <SID>TermExec('tabp')<CR>
tnoremap <expr> <C-\><C-R>    '<C-\><C-N>"'.nr2char(getchar()).'pi'

" map <g><d> to :ALEGoToDef

function ALELSPMappings()
    let l:lsp_found=0
    for l:linter in ale#linter#Get(&filetype) 
                \ | if !empty(l:linter.lsp) 
                \ | let l:lsp_found=1 
                \ | endif 
                \ | endfor
    if (l:lsp_found)
        nnoremap <buffer> gd :ALEGoToDefinition<CR>
        nnoremap <buffer> <leader>gd :ALEGoToDefinition -split<CR>
        nnoremap <buffer> gD :ALEGoToDefinition -tab<CR>
        nnoremap <buffer> gr :ALEFindReferences<CR>
        nnoremap <buffer> gR :ALERepeatSelection<CR>
    endif
endfunction
aug ALELSPMap
    au BufRead,FileType * call ALELSPMappings()
aug END

" gundo
nnoremap <F5> :GundoToggle<CR> " <F5> open gundo, useful keys: j,k,p,P,q

" easymotion
let g:EasyMotion_do_mapping = 0 " disable defaults
nmap <leader>s <Plug>(easymotion-overwin-f) 

" glow setup
lua << EOF
require('glow').setup()
EOF
