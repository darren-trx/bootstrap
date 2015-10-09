#!/bin/sh

set -x

# dotfiles/.bash_aliases "grep --color" currently screws some scripts up in Windows
cd ./dotfiles/
cp -f .bashrc "$HOME"
cp -f .bash_ssh_agent "$HOME"
cp -f .gitconfig "$HOME"
sed -i 's/#\(.* # Windows\)/\1/g' "$HOME/.gitconfig"
cp -f .gitignore "$HOME"
cp -f .vimrc "$HOME"

if [ -d "$HOME/vimfiles" ]; then rm -rf "$HOME/vimfiles"; fi
mkdir "$HOME/vimfiles"
cp -rf .vim/* "$HOME/vimfiles/"

cd ../../vim-plugins/bundle
cp -rf vim-pathogen/autoload $HOME/vimfiles/

BUNDLE_DIR="$HOME/vimfiles/bundle"
mkdir "$BUNDLE_DIR"
cp -rf ctrlp "$BUNDLE_DIR"
cp -rf undotree "$BUNDLE_DIR"
cp -rf vim-airline "$BUNDLE_DIR"
cp -rf vim-gnupg "$BUNDLE_DIR"
cp -rf vim-indent-guides "$BUNDLE_DIR"
cp -rf vim-multiple-cursors "$BUNDLE_DIR"

