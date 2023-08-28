# connernilsen's dotfiles

This repository contains the set of dotfiles and configurations I would like shared between the computers and environments I commonly work in.

> Note: the vim config is no longer maintained (but not the nvim config). Some plugins may not behave correctly or cause vim to crash.

## Setup

1. Install/Compile neovim
2. Symlink files:
  - `ln -s dotfiles/tmux.conf .tmux.conf` (from `~`)
  - `ln -s ../dotfiles/nvim nvim` (from `.config/`)
3. Run `:PlugInstall` in nvim
4. Install the following packages:
  - `htop`
  - `ripgrep`
  - `tmux`
  - `ajeetdsouza/zoxide`
  - `reattach-to-user-namespace` (if on Mac)
  - `pynvim` (for `--user`)
  - Packages that should be auto installed by nvim
    - `fzf`
    - `vim-plug`
5. Install [TPM](https://github.com/tmux-plugins/tpm)
6. Set the following options in .bashrc/.zshrc/...
```
export EDITOR=nvim
export CLICOLOR=1
export EXTERNAL_TERM=${EXTERNAL_TERM:-TERM} # make an extra case in .tmux.conf if colors are weird in nvim
```
7. Install language helpers:
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
