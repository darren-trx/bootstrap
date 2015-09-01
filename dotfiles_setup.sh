#!/bin/bash

# https://pypi.python.org/pypi/dotfiles

DOTFILES_REPO=~/bootstrap/dotfiles

# install pip if necessary
pip --version > /dev/null
[ $? -eq 0 ] || sudo ./pip_install.sh

# install dotfiles if necessary
dotfiles --version > /dev/null
[ $? -eq 0 ] || sudo pip install dotfiles

ln -s "${DOTFILES_REPO}/.dotfilesrc" ~/.dotfilesrc

# sync, list, and check dotfiles symlinks
echo "Syncing dotfiles..."
dotfiles --sync
echo
echo "Currently managed dotfiles:"
dotfiles --list
echo
echo "Checking for broken/unsynced symlinks..."
dotfiles --check
