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

" ocaml settings (if opam and merlin installed)
if system("opam --version") && system("opam list --installed --short --safe --color=never --check merlin")
    let g:opam_share_dir = substitute(system('opam var share'),'[\r\n]*$','','''') . "/merlin/vim"
    set rtp+=g:opam_share_dir
    set rtp^=g:opam_share_dir."/ocp-indent/vim"
endif

