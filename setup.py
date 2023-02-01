import os
from pathlib import Path
import sys
from typing import Optional, Callable, List
import subprocess

"""
Install list

ocaml: opam dune merlin ocamlformat
"""

"""
Setup List

export EDITOR=vim
export CLICOLOR=1
HISTSIZE=130000 SAVEHIST=130000
"""


class StepResult:
    name: str
    is_success: bool
    messages: List[str]
    fail_error: Optional[str]

    def __init__(
        self,
        name: str,
    ) -> None:
        self.name = name
        self.is_success = True
        self.messages = []

    def add_result(self, is_success: bool, message: str) -> "StepResult":
        self.is_success = is_success
        self.messages.append(message)
        return self


def setup_vim(home: Path, dotfile: Path) -> StepResult:
    #TODO: note, this should install fzf, but I'm not 100% sure

    vim_dir = home / ".vim"
    step = StepResult("vim")

    if vim_dir.exists():
        if not vim_dir.is_symlink():
            return 
                step.add_result(
                    False,
                    f"Vim directory already exists but is not symlinked. \
                Move directory to set up vim: {vim_dir}",
                )
        else:
            step.add_result(True, "Vim directory already set up")
    else:
        vim_dir.symlink_to("vim")
        step.add_result(True, "Vim symlink created")

    bundle_dir = dotfile / "vim" / "bundle"

    if not bundle_dir.exists():
        bundle_dir.mkdir()
        step.add_result(True, "Vundle dir created")
    else:
        step.add_result(True, "Vundle dir exists")

    if (bundle_dir / "Vundle.vim").exists():
        step.add_result(True, "Vundle installed")
    else:
        git_clone = subprocess.run(
            [
                "git",
                "clone",
                "https://github.com/VundleVim/Vundle.vim.git",
                "~/.vim/bundle/Vundle.vim",
            ],
            text=True,
        )
        if git_clone.returncode != 0:
            return step.add_result(False, f"Error cloning vundle: {git_clone.stderr}")
        else:
            step.add_result(True, "Cloned vundle")

    plugin_install = subprocess.run(["vim", "+PluginInstall", "+qall"], text=True)
    if plugin_install.retruncode != 0:
        step.add_result(False, f"Error installing vundle plugins: {plugin_install.stderr}")

    return step


def homebrew_setup() -> StepResult:
    step = StepResult("homebrew")
    if "homebrew" not in os.getenv("PATH"):
        brew_install = subprocess.run(
            [
                "/bin/bash",
                "-c",
                "\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            ],
            text=True,
        )
        if brew_install.returncode != 0:
            return step.add_result(False, f"Failed to install Homebrew: {brew_install.stderr}")
        else:
            step.add_result(True, "Installed Homebrew")
    else:
        step.add_result(True, "Homebrew already installed")

    package_install = subprocess.run(
        [
            "brew",
            "install",
            "htop",
            "opam",
            "ripgrep",
        ],
        text=True
    )

    if package_install.returncode != 0:
        return step.add_result(False, f"Failed to install Homebrew packages: {package_install.returncode}")
    else:
        step.add_result(True, "Installed Homebrew packages")

    return step


def setup_python() -> StepResult:
    step = StepResult("python")
    pip_install = subprocess.run(
        ["pip3",
        "install",
        "autoimport",
        "pyre",
        "black"],
        text=True
    )

    if pip_install.returncode != 0:
        return step.add_result(False, f"Error pip installing packages: {pip_install.stderr}")
    else:
        return step.add_result(True, "Packages installed")


def main() -> None:
    home = Path(os.getenv("HOME"))
    dotfile = Path(os.getcwd())

    if not home.exists():
        raise FileNotFoundError(f"Home directory does not exist: {home}")
    if not home.is_dir():
        raise NotADirectoryError(f"Home directory is not a directory: {home}")

    results = []

    vim_result = setup_vim(home, dotfile)
    results.append(vim_result)

    python_result = setup_python(home)
    results.append(python_result)


if __name__ == "__main__":
    main()
