#!/bin/bash

# https://github.com/jbernard/dotfiles/
# https://pypi.python.org/pypi/dotfiles

DOTFILES_REPO="${HOME}/bootstrap/dotfiles"
DOTFILES_LINK="${HOME}/.dotfilesrc"

DOTFILES_OPTS="$@"

if [ "$(pwd)" != "${HOME}/bootstrap" ]; then
  echo "dotfiles must be from ${HOME}/bootstrap"
  exit 1
fi

# install pip if necessary
[ "$(type -P pip)" ] || sudo ./pip_install.sh

# install dotfiles if necessary
[ "$(type -P dotfiles)" ] || sudo pip install dotfiles

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

# Reload bash env files
. ~/.bashrc
. ~/.bash_aliases

# Run mygpg script (will install itself to /usr/local/bin)
./mygpg.sh
type mygpg

# TODO: read prompt to install ansible
# TODO: read prompt to install vim plugins
