" Plugin list begin

Plug 'dracula/vim',{'name':'dracula'}  " theme
Plug 'itchyny/lightline.vim'           " meta info at bottom of screen
Plug 'thaerkh/vim-workspace'           " handle auto-resuming sessions when calling 'vim' in a dir after \s
Plug 'tpope/vim-commentary'            " make comments using gcc or <motion>gc
Plug 'nathanaelkane/vim-indent-guides' " show indentation guides
Plug 'sheerun/vim-polyglot'            " language helpers
Plug 'jiangmiao/auto-pairs'            " helpers for parentheses
if v:version > 802 || has('nvim')      " plugin only works on vim 8.2.1978+
    Plug 'psliwka/vim-smoothie'        " smooth scroll up/down/page/back
endif
Plug 'breuckelen/vim-resize'           " easy resize with arrow keys
Plug 'godlygeek/tabular'               " align text (:Tabularize /<regex>/[lcr]<spacing>...)
Plug 'blueyed/vim-diminactive'         " dim inactive windows
Plug 'ervandew/supertab'               " tab completion
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
if has('nvim') || has('patch-8.0.902')   " show changes in gutter
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif
" Plug 'puremourning/vimspector'         " debugger built into vim

