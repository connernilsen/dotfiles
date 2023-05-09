let b:ale_fixers = ['ocamlformat']
setlocal shiftwidth=2
setlocal tabstop=2

" ocaml settings (if opam and merlin installed)
if system('opam --version') &&
            \ system('opam list --installed --short --safe --color=never --check merlin')
  let g:opam_share_dir =
              \ substitute(system('opam var share'),'[\r\n]*$','','''') .
              \ '/merlin/vim'
  set rtp+=g:opam_share_dir
  set rtp^=g:opam_share_dir.'/ocp-indent/vim'
endif
