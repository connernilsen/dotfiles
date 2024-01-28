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
      - This can be symlinked with `ln -s ~/.config/nvim/bundle/fzf/bin/fzf` from `.local/bin/`
      - Run `.config/nvim/bundle/fzf/install` to complete installation
    - `vim-plug`
5. Install [TPM](https://github.com/tmux-plugins/tpm)
6. Set the following options in .bashrc/.zshrc/...
```
export EDITOR=nvim
export CLICOLOR=1
export EXTERNAL_TERM=${EXTERNAL_TERM:-$TERM} # make an extra case in .tmux.conf if colors are weird in nvim
```
7. Setup Pyenv
  - Install with Homebrew
  - Install [build dependencies](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
  - Setup [shell support](https://github.com/pyenv/pyenv#set-up-your-shell-environment-for-pyenv)
  - When installing a new Python version, the following will likely need to be done:
    - `brew unlink pkg-config`
    - `pyenv install ...`
    - `brew link pkg-config`
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

9. Source Bash scripts in .bashrc/.zshrc
```
if [ -f "dotfiles/shell/$file" ]; then
  source "dotfiles"/shell/$file"
fi
```
