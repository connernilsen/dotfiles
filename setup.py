import os
from pathlib import Path
import sys
from typing import Optional, Callable

"""
Install list

vundle
python: autoimport pyre black
ocaml: opam dune merlin ocamlformat
fzf
mosh
ripgrep
htop
"""

"""
Setup List

export EDITOR=vim
export CLICOLOR=1
HISTSIZE=130000 SAVEHIST=130000
"""


class StepStatus:
    name: str
    directory: Path
    is_success: bool
    message: str

    def __init__(
        self, name: str, directory: Path, is_success: bool, message: str
    ) -> None:
        self.name = name
        self.directory = directory
        self.is_success = is_success
        self.message = message

    @staticmethod
    def create(name: str, directory: Path) -> Callable[[bool, str], "StepStatus"]:
        def finish_creation(is_success: bool, message: str) -> "StepStatus":
            return StepStatus(name, directory, is_success, message)

        return finish_creation


def setup_vim(home: Path, dotfile: Path) -> StepStatus:
    vim_dir = home / ".vim"
    step = StepStatus.create("vim", vim_dir)

    if vim_dir.exists():
        if not vim_dir.is_symlink():
            return step(
                False,
                f"Vim directory already exists but is not symlinked. \
                Move directory to set up vim: {vim_dir}",
            )
        return step(True, "Vim directory already set up")

    vim_dir.create()


def main() -> None:
    home = Path(os.getenv("HOME"))
    dotfile = Path(os.getcwd())

    if not home.exists():
        raise FileNotFoundError(f"Home directory does not exist: {home}")
    if not home.is_dir():
        raise NotADirectoryError(f"Home directory is not a directory: {home}")

    setup_vim(home, dotfile)


if __name__ == "__main__":
    main()
