#!/bin/bash

# https://github.com/jbernard/dotfiles/
# https://pypi.python.org/pypi/dotfiles
# pip install dotfiles  (alternative)

DOTFILES_BIN="${HOME}/bootstrap/dotfiles_setup/bin/dotfiles"
DOTFILES_REPO="${HOME}/bootstrap/dotfiles"
DOTFILES_LINK="${HOME}/.dotfilesrc"

DOTFILES_OPTS="$@"

[ -x "${DOTFILES_BIN}" ] || ( echo "${DOTFILES_BIN} does not exist, aborting" && exit 1)
[ -d "${DOTFILES_REPO}" ] ||  ( echo "${DOTFILES_REPO} does not exist, aborting" && exit 1 )

# delete ~/.dotfilesrc if it already exists
if [ -e "${DOTFILES_LINK}" ]; then
  rm -f "${DOTFILES_LINK}"
fi

# backup .bashrc if it is not a symlink
if [ ! -L "${HOME}/.bashrc" ]; then
  mv -vf "${HOME}/.bashrc" "${HOME}/.bashrc.bak"
fi

# symlink ~/.dotfilesrc manually initially
ln -s "${DOTFILES_REPO}/.dotfilesrc" "${DOTFILES_LINK}"

# sync, list, and check dotfiles symlinks
echo "Syncing dotfiles..."
$DOTFILES_BIN --sync $DOTFILES_OPTS
echo
echo "Currently managed dotfiles:"
$DOTFILES_BIN --list
echo
echo "Checking for broken/unsynced symlinks..."
$DOTFILES_BIN --check

# Reload bash env files
source "${HOME}/.bashrc"
source "${HOME}/.bash_aliases"

