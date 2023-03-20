" Brief help
" :PluginList - list plugins
" :PluginInstall - installs plugins
" :PluginUpdate - update plugin
" :PluginSearch foo - searches for foo
" :PluginClean - confirms removal of unused plugins
" see :h vundle for help

" only lint on save TODO: is this fixing the segfault issue?
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

let g:LargeFile = 1000000 " file is large if size greater than 1MB
aug anyfold
    au!
    au Filetype * AnyFoldActivate " activate folding for all filetypes
aug end
" disable anyfold for large files
au BufReadPre,BufRead * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
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
let g:indent_guides_guide_size=4
aug coloring
    au!
    " set color scheme and indent guides
    au VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=DarkGrey
aug END

" format on save
let g:ale_fix_on_save = 1

" use enhanced coloring if possible
if (has("termguicolors"))
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
  \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
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
    let g:peekaboo_window="vert bo 30new"
else
    let g:peekaboo_window="vert bo ".float2nr(ceil(winwidth(0)/3))."new"
endif

" yoink settings
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

" workspace settings
nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_disable_on_args=1 " when starting with a specific file, don't open workspace
let g:workspace_autosave=0 " don't autosave automatically
let g:workspace_persist_undo_history=0 " use vim default undo history

" ocaml stuff

if system("opam --version")
    let g:opamshare = substitute(system('opam config var share'),'\n$','','''') . "/merlin/vim"
    set rtp+=g:opamshare
    set rtp^="/home/connernilsen/.opam/5.0.0/share/ocp-indent/vim"
endif

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["merlin"] " \"ocp-indent\", \"ocp-index\"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
