# connernilsen's dotfiles

This repository contains the set of dotfiles and configurations I would like shared between the computers and environments I commonly work in.

## Setup

1. Install vim/neovim
2. Install [Vim-Plug](https://github.com/junegunn/vim-plug)
3. Symlink files:
  - `ln -s dotfiles/tmux.conf .tmux.conf`
  - `ln -s dotfiles/vim .vim`
  - `ln -s dotfiles/nvim .config/nvim`
4. Run `:PlugInstall` in vim/nvim
5. Install the following packages:
  - `htop`
  - `ripgrep`
  - `tmux`
6. Install [TPM](https://github.com/tmux-plugins/tpm)
7. Set the following options in .bashrc/.zshrc/...
```
export EDITOR=vim # or nvim
export CLICOLOR=1
export TERM="xterm-256color"
```
8. Install language helpers:
  - python
    - `autoimport`
    - `pyre-check`
    - `black`
  - OCaml
    - `opam`
    - `dune`
    - `merlin`
    - `ocamlformat`
    - `ocaml-lsp-server`
    - `utop`
