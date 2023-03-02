import os
from pathlib import Path
import sys
from typing import Optional, Callable, List
import subprocess

"""
Install list

ocaml: opam dune merlin ocamlformat ocaml-lsp-server
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
            return step.add_result(
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
    if plugin_install.returncode != 0:
        step.add_result(False, f"Error installing vundle plugins: {plugin_install.stderr}")

    return step


def setup_homebrew() -> StepResult:
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
            "tmux",
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
        [
            "pip3",
            "install",
            "autoimport",
            "pyre-check",
            "black"
        ],
        text=True
    )

    if pip_install.returncode != 0:
        return step.add_result(False, f"Error pip installing packages: {pip_install.stderr}")
    else:
        return step.add_result(True, "Packages installed")


def setup_tmux(home: Path) -> StepResult:
    step = StepResult("tmux")
    tmux_config = home / ".tmux.conf"

    if tmux_config.exists():
        if not tmux_config.is_symlink():
            return step.add_result(False, f"Tmux conf already exists but is not symlinked: {tmux_config}")
        else:
            step.add_result(True, "Tmux conf already set up and linked")
    else:
        tmux_config.symlink_to("tmux.conf")
        step.add_result(True, "Tmux conf linked to dotfile dir")

    tmux_dir = home / ".tmux"

    if not tmux_dir.exists():
        tmux_dir.mkdir()
        step.add_result(True, "Tmux dir created")
    else:
        step.add_result(True, "Tmux dir already exists")

    plugins_dir = tmux_dir / "plugins"
    if not plugins.exists():
        plugins_dir.mkdir()
        step.padd_result(True, "Tmux plugins dir created")
    else:
        step.add_result(True, "Tmux plugins dir already exists")

    if (plugins_dir / "tpm").exists():
        step.add_result(True, "TPM already installed")
    else:
        tpm_install = subprocess.run(
            [
                "git"
                "clone"
                "https://github.com/tmux-plugins/tpm"
                "~/.tmux/plugins/tpm"
            ]
        )

        if tpm_install.returncode != 0:
            return step.add_result(False, f"TPM install failed: {tpm_install.stderr}")
        else:
            step.add_result(True, "TPM installl succeeded")

    plugin_install = subproces.run(
        [
            str(plugins_dir / "tpm" / "bin" / "install_plugins")
        ]
    )
    if plugin_install.returncode != 0:
        return step.add_result(False, f"Plugin install failed: {plugin_install.stderr}")
    else:
        step.add_result(True, "Tmux plugins installed")

    return step


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

    homebrew_result = setup_homebrew()
    results.append(homebrew_result)

    tmux_result = setup_tmux(home)
    results.append(tmux_result)


if __name__ == "__main__":
    main()
