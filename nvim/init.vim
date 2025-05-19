let &packpath = &runtimepath

let confdir=$HOME.'/dotfiles/nvim/'

set nocompatible " don't use vi compatibility
filetype plugin indent on " turn on indentation and plugins for recognized file types

let mapleader=' ' " sets <leader> to ' '
" don't auto jump when highlighting
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <BAR> set hls <CR>
" highlight visual selection after hitting enter
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" tab settings
set shiftwidth=4 " number of spaces used in an auto indent step
set shiftround " << and >> round to shiftwidth
aug filetypes
    " clear all commands in this aug and recreate (otherwise they will be
    " duplicated)
    au!
aug END
set expandtab tabstop=4
" NOTE: flip tabs/spaces with :retab


" visual settings
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set number " show line numbers
aug file_settings
  au!
  " show absolute line number and relative line numbers for currently active window
  au BufWinEnter,FocusGained,InsertLeave,WinEnter,WinScrolled *
        \ if &number && mode() != 'i'
        \ | set rnu
        \ | endif
  " show absolute line number for inactive windows
  au BufWinLeave,FocusLost,InsertEnter,WinLeave *
        \ if &number
        \ | set nornu
        \ | endif
  " set color scheme and indent guides
  au VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=DarkGrey
  au BufWinEnter,WinEnter * let b:indent_guides_size=&shiftwidth
  au BufEnter * set foldmethod=expr
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
" set spell " highlight spelling mistakes
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
let g:workspace_session_directory=sdir " create a new workspace with :ToggleWorkspace
set completeopt=menu,preview,noinsert " when completing with Ctrl + N in insert mode, don't insert values
set nojs " don't use two spaces after joining a line ending with .
syntax on " enable syntax highlighting
set splitbelow " split new windows on bottom
set splitright " split new windows to the right
set backspace=2 " backspace twice when editing eol/sol
set foldlevel=99 " open all folds when entering file
set colorcolumn=88 " set line length marker

" set clipboard settings (might need xclip)
if system('uname -s') == 'Darwin\n'
  set clipboard=unnamed "OSX
  set clipboard+=unnamedplus
elseif !empty($WSL_DISTRO_NAME)
  let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': 'clip.exe',
    \      '*': 'clip.exe',
    \    },
    \   'paste': {
    \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }
else
  set clipboard+=unnamedplus
  set clipboard=unnamedplus "Linux
endif
set mouse=  " clicking won't move the cursor, and you can copy directly off the screen

if $OVERRIDE_PYBINARY != ''
  let g:python3_host_prog = $OVERRIDE_PYBINARY
endif

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

" define large file as 10mb
let g:LargeFile = 10

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/bundle')

" Plugin list begin

" Plug 'dracula/vim',{'name':'dracula'}  " theme
Plug 'vim-scripts/LargeFile'           " disable functionality on large files
Plug 'navarasu/onedark.nvim'           " theme
Plug 'itchyny/lightline.vim'           " meta info at bottom of screen
Plug 'thaerkh/vim-workspace'           " handle auto-resuming sessions when calling 'vim' in a dir after \s
Plug 'tpope/vim-commentary'            " make comments using gcc or <motion>gc
Plug 'preservim/vim-indent-guides'     " show indentation guides
Plug 'sheerun/vim-polyglot'            " language helpers
Plug 'psliwka/vim-smoothie'            " smooth scroll up/down/page/back
Plug 'godlygeek/tabular', {'on': 'Tabularize'} " align text (:Tabularize /<regex>/[lcr]<spacing>...)
if has('python3')
  Plug 'TaDaa/vimade'                  " dim inactive windows (config in after/plugin)
endif
" Plug 'ervandew/supertab'               " tab completion
" would like to switch to this at some point if possible (need to check FAQ to
" work with vim-visual-multi)
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " fuzzy completion
Plug 'junegunn/vim-peekaboo'           " check registers when ctrl + r
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                " fuzzy finder
" Plug 'dense-analysis/ale'              " async lint engine
" Plug 'maximbaz/lightline-ale'          " lightline support for ALE
Plug 'google/vim-searchindex'          " count number of searches returned from / or ?
Plug 'chrisbra/NrrwRgn', {'on': ['NW', 'NR']} " narrow to selected region with :NW/NR
Plug 'konfekt/fastfold'                " only update fold information on fold operations
Plug 'tpope/vim-surround'              " plugin for working with text objects
" Plug 'will133/vim-dirdiff'             " diff a directory
Plug 'Matt-A-Bennett/vim-surround-funk' " text objects for functions
Plug 'svermeulen/vim-yoink'            " ring buffer for yanks with :Yanks
Plug 'mhinz/vim-signify'               " great source control info in gutter/with commands
" Plug 'puremourning/vimspector'         " debugger built into vim
Plug 'tpope/vim-scriptease'            " vim plugin for working with vim plugins (:PP, :Scriptnames, :Messages,...)
Plug 'jpalardy/vim-slime'              " send text to other terminal
Plug 'klafyvel/vim-slime-cells'        " interactive cells for languages (python and ocaml by default)
Plug 'mbbill/undotree'                 " <F5> for edit history, ? for help
" Plug 'mg979/vim-visual-multi'          " allows for Sublime/VSCode multi-cursor behavior
Plug 'easymotion/vim-easymotion'       " jump to any character anywhere with <leader>s
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " plugin  for syntax everything (:TSInstall <lang> to setup)
Plug 'nvim-treesitter/playground'      " visualizer for AST
Plug 'nvim-treesitter/nvim-treesitter-context' " show current context within module/function/...
" Plug 'HiPhish/nvim-ts-rainbow2'        " rainbow parentheses
Plug 'JoosepAlviste/nvim-ts-context-commentstring' " better commentstrings/language nested comments
Plug 'drybalka/tree-climber.nvim'      " functionality for navigating around the syntax tree
Plug 'christoomey/vim-tmux-navigator'  " navigate between tmux and vim seamlessly
Plug 'kevinhwang91/nvim-bqf'           " quickfix help, run with :copen/cfile/cexpr

Plug 'mason-org/mason.nvim'
Plug 'neovim/nvim-lspconfig'

" Plugin list end
call plug#end()

let g:deoplete#enable_at_startup = 1

" let g:ale_fix_on_save = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0
" let g:ale_fixers = {
"       \ '*': ['remove_trailing_lines', 'trim_whitespace'],
"       \ }

" turn on indent guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=0

" use enhanced coloring if possible
if (has('termguicolors'))
  set termguicolors
endif

" set color scheme
set background=dark
let g:onedark_config = {
    \ 'style': 'deep'
    \ }
colorscheme onedark

let g:lightline = {
      \ 'colorscheme': 'selenized_black',
      \ }

" let g:lightline.component_expand = {
"       \  'linter_checking': 'lightline#ale#checking',
"       \  'linter_infos': 'lightline#ale#infos',
"       \  'linter_warnings': 'lightline#ale#warnings',
"       \  'linter_errors': 'lightline#ale#errors',
"       \  'linter_ok': 'lightline#ale#ok',
"       \ }

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

" " completion engine with ALE
" set omnifunc=ale#completion#OmniFunc
" " go to next errors
" nmap <silent> <Leader>k <Plug>(ale_previous_wrap)
" nmap <silent> <Leader>j <Plug>(ale_next_wrap)

" yoink settings
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap <C-n> <plug>(YoinkPostPasteSwapBack)
nmap <C-p> <plug>(YoinkPostPasteSwapForward)

" setup easymotion
let g:EasyMotion_do_mapping = 0 " disable defaults
nnoremap <leader>s <Plug>(easymotion-bd-W)

" workspace settings
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
nmap <C-c>v <Plug>SlimeConfig
nmap <C-c><C-c> <Plug>SlimeCellsSendAndGoToNext
" these won't work on mac
nmap <C-c><c-Down> <Plug>SlimeCellsNext
nmap <C-c><c-Up> <Plug>SlimeCellsPrev

" map <g><d> to :ALEGoToDef

" function ALELSPMappings()
"     let l:lsp_found=0
"     for l:linter in ale#linter#Get(&filetype)
"                 \ | if !empty(l:linter.lsp)
"                 \ | let l:lsp_found=1
"                 \ | endif
"                 \ | endfor
"     if (l:lsp_found)
"         nnoremap <buffer> gd :ALEGoToDefinition<CR>
"         nnoremap <buffer> <leader>gd :ALEGoToDefinition -split<CR>
"         nnoremap <buffer> gD :ALEGoToDefinition -tab<CR>
"         nnoremap <buffer> gr :ALEFindReferences<CR>
"         nnoremap <buffer> gR :ALERepeatSelection<CR>
"     endif
" endfunction
" aug ALELSPMap
"     au!
"     au BufRead,FileType * call ALELSPMappings()
" aug END

" Undotree
nnoremap <F5> :UndotreeToggle<CR>

" vimade
let g:vimade = {}
let g:vimade.fadelevel = 0.5
let g:vimade.rowbufsize = 0
let g:vimade.colbufsize = 1
let g:vimade.enabletreesitter = 1
let g:vimade.enablefocusfading = 1

" rebind join lines to alt-j and join comments properly
vnoremap <silent> <buffer> <M-j> gfJ
nnoremap <silent> <buffer> <M-j> J

" lua setup
lua << EOF
-- treesitter setup
require'nvim-treesitter.configs'.setup {
  -- languages that should be auto-installed
  ensure_installed = {
    'css', 'html', 'javascript', 'lua', 'python', 'typescript', 'vim', 'vimdoc',
    'ocaml', 'c', 'ocaml_interface', 'bash', 'diff', 'json', 'markdown',
    'markdown_inline', 'yaml', 'query', 'starlark', 'rust', 'toml'
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- rainbow = {
  --   enable = true,
  --   query = 'rainbow-parens',
  --   strategy = require('ts-rainbow').strategy.global,
  -- },
}
vim.g.skip_ts_context_commentstring_module = true
require'ts_context_commentstring'.setup{}
require'treesitter-context'.setup{
  enable = true,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = '#',
  zindex = 20,
}
-- tree climber setup
local keyopts = { noremap = true, silent = true }
local movement_options = { highlight = true, skip_comments = true, timeout = 250 }
vim.keymap.set({'n', 'v', 'o'}, 'K', function()
    require('tree-climber').goto_parent(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, 'J', function()
    require('tree-climber').goto_child(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, 'L', function()
    require('tree-climber').goto_next(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, 'H', function()
    require('tree-climber').goto_prev(movement_options)
  end, keyopts)
vim.keymap.set({'v', 'o'}, 'in', require('tree-climber').select_node, keyopts)
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" language autodetection
aug language_autodetection
  au!
  " set filetype if not already set
  au BufNewFile,BufRead *.bxl setfiletype starlark
  " files with the pattern TARGETS are starlark files
  au BufNewFile,BufRead TARGETS setfiletype starlark
aug END

lua << EOF
require("mason").setup()

vim.lsp.config['pyrefly'] = {
  cmd = { 'pyrefly', 'lsp' },
  filetypes = { 'python' },
  root_markers = {
    -- search for these files first
    -- {
      'pyproject.toml',
      'pyrefly.toml',
    -- },
    -- -- then fall back to these if none of the above were found
    -- {
    --   'setup.py',
    --   'setup.cfg',
    --   'requirements.txt',
    --   'Pipfile',
    --   '.git',
    -- }
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      '.git',
  },
}

vim.lsp.enable("pyrefly")
EOF


