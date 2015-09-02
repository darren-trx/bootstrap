#!/bin/bash

# https://pypi.python.org/pypi/dotfiles

DOTFILES_REPO="${HOME}/bootstrap/dotfiles"
DOTFILES_LINK="${HOME}/.dotfilesrc"

DOTFILES_OPTS="$@"

if [ "$(pwd)" != "${HOME}/bootstrap" ]; then
  echo "dotfiles must be from ${HOME}/bootstrap"
  exit 1
fi

# install pip if necessary
[ "$(which pip)" ] || sudo ./pip_install.sh

# install dotfiles if necessary
[ "$(which dotfiles)" ] || sudo pip install dotfiles

[ -f "${DOTFILES_LINK}" ] || ln -s "${DOTFILES_REPO}/.dotfilesrc" "${DOTFILES_LINK}"

# sync, list, and check dotfiles symlinks
echo "Syncing dotfiles..."
dotfiles --sync $DOTFILES_OPTS
echo
echo "Currently managed dotfiles:"
dotfiles --list
echo
echo "Checking for broken/unsynced symlinks..."
dotfiles --check
