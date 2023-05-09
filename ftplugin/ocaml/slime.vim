function! _EscapeText_ocaml(text)
  let trimmed = substitute(a:text, '\_s*$', '', '')
  if match(trimmed,';;\n*$') > -1
    return [trimmed,"\n"]
  else
    return [trimmed . ";;","\n"]
  endif
endfunction

let b:slime_cell_delimiter = "^\\s*(\\*\\*"

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
