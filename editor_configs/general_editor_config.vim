set nocompatible " don't use vi compatibility
filetype plugin indent on " turn on indentation and plugins for recognized file types

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
    au BufEnter,FocusGained,InsertLeave,WinEnter * if &number && mode() != "i" | set rnu | endif
    " show absolute line number for inactive windows
    au BufLeave,FocusLost,InsertEnter,WinLeave * if &number | set nornu | endif
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
if !isdirectory(confdir."undo-dir")
    call mkdir(confdir."undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir " set undo directory
set undofile " save and restore undo history when editing files
" create session directory (NOTE: this doesn't populate anything there)
let sdir=confdir."session-dir/"
if !isdirectory(sdir)
    call mkdir(sdir, "", 0700)
endif
let g:workspace_session_directory=sdir " create a new workspace with \s
set completeopt=menu,preview,noinsert " when completing with Ctrl + N in insert mode, don't insert values
set nojs " don't use two spaces after joining a line ending with .
syntax enable " enable syntax highlighting
set splitbelow " split new windows on bottom
set splitright " split new windows to the right
set backspace=2 " backspace twice when editing eol/sol
set foldlevel=99 " open all folds when entering file

" set clipboard settings (might need xclip)
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
  set clipboard+=unnamedplus
else
  set clipboard+=unnamedplus
  set clipboard=unnamedplus "Linux
endif
