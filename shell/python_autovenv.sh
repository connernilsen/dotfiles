#!/usr/bin/bash

# if 'venv' is found in the current directory, activate venv
# on leaving directory with venv (if it's not a subdir), deactivate venv

function handle_venv () {
  if [[ -z "$VIRTUAL_ENV" && -d "./venv" ]]; then
      echo "Activating venv"
      ## If env folder is found then activate the vitualenv
      source ./venv/bin/activate
  elif [[ -n "$VIRTUAL_ENV" ]]; then
      ## check the current folder belong to earlier VIRTUAL_ENV folder
      # if yes then do nothing
      # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]]; then
        echo "Deactivating venv"
        deactivate
      fi
  fi
}

function cd () {
  builtin cd "$@"

  handle_venv
}

function z () {
  # use zoxide underlying function
  __zoxide_z "$@"

  handle_venv
}
