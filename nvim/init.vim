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
set shiftwidth=2 " number of spaces used in an auto indent step
set shiftround " << and >> round to shiftwidth
aug filetypes
    " clear all commands in this aug and recreate (otherwise they will be
    " duplicated)
    au!
aug END
set expandtab tabstop=2
" NOTE: flip tabs/spaces with :retab


" visual settings
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)' " tmux settings
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
aug END
set t_Co=256 " full colors
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
set list " show hidden characters denoted by lcs
set lcs=tab:>-,trail:·,extends:>,precedes:< " markings to show for hidden characters

" behavior settings
set autoindent " automatically set indent of new line
set smartindent " clever autoindenting
set smartcase " ignore case in search unless a capital letter appears
set ignorecase " mostly ignore case when searching (see smartcase)
" set spell " highlight spelling mistakes
set laststatus=2 " always show status line
set visualbell " use visual indicator of instead of beeping
" create undo directory in shared dir
let udir=confdir.'undo-dir'
if !isdirectory(udir)
  call mkdir(udir, '', 0700)
endif
set undofile " save and restore undo history when editing files
set undodir=~/.config/nvim/undo-dir " set directory for storing and loading undofiles
" create session directory (NOTE: this doesn't populate anything there)
let sdir=confdir.'session-dir/'
if !isdirectory(sdir)
  call mkdir(sdir, '', 0700)
endif
let g:workspace_session_directory=sdir " create a new workspace with :ToggleWorkspace
set completeopt=menuone,preview,fuzzy,noinsert " when completing with Ctrl + N in insert mode, don't insert values
set nojs " don't use two spaces after joining a line ending with .
syntax on " enable syntax highlighting
set splitbelow " split new windows on bottom
set splitright " split new windows to the right
set backspace=2 " backspace twice when editing eol/sol
set foldlevel=99 " open all folds when entering file
set colorcolumn=88 " set line length marker

" set clipboard settings (might need xclip)
if system('uname -s') == 'Darwin\n'
  set clipboard=unnamed " OSX
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
  set clipboard=unnamedplus " Linux
endif
set mouse= " clicking won't move the cursor, you can copy directly off the screen in iterm

" set `export OVERRIDE_PYBINARY` in bashrc to override the interpreter nvim uses
if $OVERRIDE_PYBINARY != ''
  let g:python3_host_prog = $OVERRIDE_PYBINARY
endif

" download and install vim-plug
if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
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

" enable only simple functionality on large files
Plug 'vim-scripts/LargeFile'
" nvim color theme
Plug 'navarasu/onedark.nvim'
" plugin for handling meta-info at bottom of nvim
Plug 'itchyny/lightline.vim'
" automatically reopen files like vscode workspace when started.
" :ToggleWorkspace will start/stop tracking a workspace
Plug 'thaerkh/vim-workspace'
" `gcc` to (un)comment current line or `<motion|visual>gc` to comment selection
Plug 'tpope/vim-commentary'
" comment functionality when nested in languages
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" show indentation guides, every indent level will have a highlight
Plug 'preservim/vim-indent-guides'
" language syntax highlighting
Plug 'sheerun/vim-polyglot'
" smooth scrolling
Plug 'psliwka/vim-smoothie'
" automatically align text in selection (e.g. if you want a bunch of comments
" across lines to be automatically aligned with each other).
" :Tabularize /<regex>[/[l<spacing>] will left-align everything by <regex>,
" with at minimum <spacing> space between the selections (read docs for more
" complex stuff)
Plug 'godlygeek/tabular', {'on': 'Tabularize'}
" dim inactive windows (config in after/plugin)
if has('python3')
  Plug 'TaDaa/vimade'
endif
" check registers in insert or command mode when ctrl + r
Plug 'junegunn/vim-peekaboo'
" make sure fzf is installed
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" a fuzzy finder, try `:Files`, `:Rg`, `:Buff`, ... (see docs for more)
Plug 'junegunn/fzf.vim'
" count number of searches returned from / or ?
Plug 'google/vim-searchindex'
" narrow to visual selection region in new pane with :NW/NR, which allows safe
" operations guaranteeing you won't accidentlly modify something you don't
" mean to.
" changes will write to the buffer when done.
" quit without writing to original buffer with `q!`
Plug 'chrisbra/NrrwRgn', {'on': ['NW', 'NR']}
" only update fold information on fold operations
Plug 'konfekt/fastfold'
" plugin adding more text objects and text object functionality
Plug 'tpope/vim-surround'
" plugin adding to vim-surround for working with functions and methods
Plug 'Matt-A-Bennett/vim-surround-funk' " text objects for functions
" diff directories with :DirDiff <d1> <d2>
Plug 'will133/vim-dirdiff'
" creates a ring buffer of yanks and allows you to swap what you past with 
" <c-n>/<c-p> to cycle through pastes.
" view yanks with `:Yanks`
Plug 'svermeulen/vim-yoink'
" adds source control changes in gutter (including hg).
" also provides nice source control functionality with `:Signify<tab>`
Plug 'mhinz/vim-signify'
" create persistent vim popups (:PP, :Scriptnames, :Messages, ...)
Plug 'tpope/vim-scriptease'
" send text to other tmux pane (e.g. if you have a python repl open and want
" to copy a script into it).
" also works with selections.
" use with `<c-c><c-c>`.
" on first run, keep socket as default and set pane to .<pane number from
" `<c-a>q`.
" reset cells with `:SlimeConfig`
Plug 'jpalardy/vim-slime'
" interactive cells for languages (i.e. iPython cells).
" only python enabled in settings now
Plug 'klafyvel/vim-slime-cells'
" <F5> for edit history, ? for help
Plug 'mbbill/undotree'
" allows for Sublime/VSCode multi-cursor behavior, but doesn't work on mac
" without rebinding
" Plug 'mg979/vim-visual-multi'
" jump to any character anywhere with <leader>s
Plug 'easymotion/vim-easymotion'
" plugin for syntax everything (:TSInstall <lang> to setup)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" visualizer for your language's AST
Plug 'nvim-treesitter/playground'
" show current context within module/function/... at top of buffer
Plug 'nvim-treesitter/nvim-treesitter-context'
" functionality for navigating around the syntax tree
Plug 'drybalka/tree-climber.nvim'
" rainbowify parentheses
Plug 'HiPhish/nvim-ts-rainbow2'
" navigate between tmux and vim seamlessly (with HJKL)
Plug 'christoomey/vim-tmux-navigator'
" quickfix window functionality.
" run with `:copen/cfile/cexpr`.
" can pipe commands into `:copen` or execute with
" `cexpr <cmd>` to get easy to walk list of items
Plug 'kevinhwang91/nvim-bqf'
" repository of language tools and settings repository.
" run `:Mason` to install/configure tools
Plug 'mason-org/mason.nvim'
" bridg for mason and lspconfig
Plug 'mason-org/mason-lspconfig.nvim'
" repository of LSPs that can plug into nvim
Plug 'neovim/nvim-lspconfig'
" show lsp status
Plug 'j-hui/fidget.nvim'
" linter framework for nvim
Plug 'mfussenegger/nvim-lint'

" Plugin list end
call plug#end()

" turn on vim-indent-guides
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

let g:lightline.active = {
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'fileformat', 'filetype'], ],
      \ 'left':  [ [ 'mode', 'paste' ],
      \            [ 'readonly', 'filename', 'modified' ], ],
      \ }

" yoink settings
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap <C-N> <plug>(YoinkPostPasteSwapBack)
nmap <C-P> <plug>(YoinkPostPasteSwapForward)

" setup easymotion
let g:EasyMotion_do_mapping = 0 " disable defaults
nnoremap <leader>s <Plug>(easymotion-bd-W)

" workspace settings
let g:workspace_session_disable_on_args=1 " when starting with a specific file, don't open workspace
let g:workspace_autosave=0 " don't autosave automatically
let g:workspace_persist_undo_history=0 " use vim default undo history

" slime setup <C-c><C-c> to send over selection
" find tmux pane with <C-b>q and set with `:.<pane_num>`
" Note: can reset job id if channel number changes with <C-c>v
let g:slime_target = 'tmux'
let g:slime_python_ipython = 1
let g:slime_cell_delimiter = '^\\s*##'
let g:slime_bracketed_paste = 1
let g:slime_no_mappings = 1
nmap <C-c><C-c> <Plug>SlimeCellsSendAndGoToNext
" these won't work on mac
nmap <C-c><c-Down> <Plug>SlimeCellsNext
nmap <C-c><c-Up> <Plug>SlimeCellsPrev

" undotree
nnoremap <F5> :UndotreeToggle<CR>

" configure vimade darkening on lose focus
let g:vimade = {}
let g:vimade.fadelevel = 0.5
let g:vimade.rowbufsize = 0
let g:vimade.colbufsize = 1
let g:vimade.enabletreesitter = 1
let g:vimade.enablefocusfading = 1

" move selected text with J/K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" let treesitter handle folding
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" custom language autodetection
aug language_autodetection
  au!
  " .bxl and BUCK are starlark files
  au BufNewFile,BufRead *.bxl setfiletype starlark
  au BufNewFile,BufRead BUCK setfiletype starlark
  " .mdx is a markdown with react file
  au BufNewFile,BufRead *.mdx setfiletype markdown
aug END

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
  rainbow = {
    enable = true,
    query = 'rainbow-parens',
    strategy = require('ts-rainbow').strategy.global,
  },
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
vim.keymap.set({'n', 'v', 'o'}, '<M-K>', function()
    require('tree-climber').goto_parent(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<M-J>', function()
    require('tree-climber').goto_child(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<M-L>', function()
    require('tree-climber').goto_next(movement_options)
  end, keyopts)
vim.keymap.set({'n', 'v', 'o'}, '<M-H>', function()
    require('tree-climber').goto_prev(movement_options)
  end, keyopts)
vim.keymap.set({'v', 'o'}, 'in', require('tree-climber').select_node, keyopts)

-- lsp setup
require('mason').setup()
require('mason-lspconfig').setup{
  ensure_installed = {
    'rust_analyzer',
  }
}

vim.diagnostic.config({
  virtual_lines = true,
  severity_sort = true,
  float = false,
  text = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.HINT] = '',
    [vim.diagnostic.severity.INFO] = '',
  },

  linehl = {
    [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    [vim.diagnostic.severity.WARN] = 'None',
    [vim.diagnostic.severity.HINT] = 'None',
    [vim.diagnostic.severity.INFO] = 'None',
  },
  numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticHint',
  },
})
vim.opt['signcolumn'] = 'yes'
vim.lsp.inlay_hint.enable(true)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- `ge` motion opens qflist with all errors
    vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, keyopts)
    -- `<leader>j` goes to next error
    vim.keymap.set('n', '<leader>j', function()
    vim.diagnostic.goto_next({ count = 1, float = false })
    end, keyopts)
    -- `<leader>k` goes to prev error
    vim.keymap.set('n', '<leader>k', function()
    vim.diagnostic.goto_next({ count = -1, float = false })
    end, keyopts)
    -- open definition in current buffer
    vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition({ reuse_win = false })
    end, keyopts)
    -- open definition in new buffer
    vim.keymap.set('n', 'gD', function()
    pos = vim.fn.getpos('.')
    vim.cmd([[tabnew %]])
    vim.fn.setpos('.', pos)
    vim.lsp.buf.definition({ reuse_win = false })
    end, keyopts)
    -- open typedef in current buffer
    vim.keymap.set('n', 'gtd', function()
    vim.lsp.buf.type_definition({ reuse_win = true })
    end, keyopts)
    -- open typedef in new buffer buffer
    vim.keymap.set('n', 'gtD', function()
    pos = vim.fn.getpos('.')
    vim.cmd([[tabnew %]])
    vim.fn.setpos('.', pos)
    vim.lsp.buf.type_definition({ reuse_win = true })
    end, keyopts)
    -- other keybinds
    -- `<c-X><c-O>` in insert mode will open autocomplete
    -- `K` opens hover
    -- `grn` renames current symbol
    -- `gra` opens code action (VSCode CMD + .)
    -- `grr` finds references
    -- `gri` finds implementations
    -- `gO` opens document symbols
    -- `<c-S>` in insert mode is signature help
  end,
})

vim.lsp.config('pyrefly', {
  cmd = { 'buck2', 'run', '@fbcode//mode/opt', 'fbcode//pyrefly:pyrefly', '--', 'lsp' },
  trace = 'verbose',
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
    },
  },
})

vim.lsp.enable('pyrefly')
vim.lsp.enable('rust-analyzer')

function lsp_verbose()
  vim.lsp.set_log_level('trace')
  require('vim.lsp.log').set_format_func(vim.inspect)
end

vim.cmd([[:command! LspVerbose :lua lsp_verbose()]])

require('fidget').setup {
    -- render_limit = 3,
}

-- setup linting
require('lint').linters_by_ft = {
  yaml = { 'yamllint' }
}
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require('lint').try_lint()
  end,
})

-- TODO: learn from organization of https://github.com/rezhaTanuharja/minimalistNVIM/tree/main
-- TODO: setup error count in statusline
-- TODO: figure out how to wire formatters in
EOF

