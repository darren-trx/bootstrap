#!/bin/bash

VIM_PLUGINS_REPO="https://github.com/darren-trx/vim-plugins"

declare -A plugin
plugin["vim-pathogen"]="https://github.com/tpope/vim-pathogen"
plugin["vim-airline"]="https://github.com/bling/vim-airline"
plugin["ctrlp"]="https://github.com/kien/ctrlp.vim"
plugin["vim-indent-guides"]="https://github.com/nathanaelkane/vim-indent-guides"
plugin["vim-multiple-cursors"]="https://github.com/terryma/vim-multiple-cursors"
plugin["vim-gitgutter"]="https://github.com/airblade/vim-gitgutter"
plugin["vim-fugitive"]="https://github.com/tpope/vim-fugitive"
plugin["vim-gnupg"]="https://github.com/jamessan/vim-gnupg"
plugin["ansible-vim"]="https://github.com/pearofducks/ansible-vim"

VIM_HOME="${HOME}/.vim"
VIM_PLUGINS="${HOME}/.vim-plugins"

# create ~/.vim if nothing at all exists
[ -e "${VIM_HOME}" ] || mkdir -v "${VIM_HOME}"

# clone vim plugin repo into ~/.vim-plugins
[ -d "${VIM_PLUGINS}" ] || git clone "${VIM_PLUGINS_REPO}" "${VIM_PLUGINS}"

# refresh the vim plugin subtrees from their original repos
if [ "$1" == "--refresh" ]; then
  cd "${VIM_PLUGINS}"

  for p in "${!plugin[@]}"
  do
    if [ ! -d "bundle/${p}" ]; then
      git subtree add --prefix "bundle/${p}" "${plugin[$p]}" master --squash
    else
      git subtree pull --prefix "bundle/${p}" "${plugin[$p]}" master --squash
    fi
  done
fi

# delete existing autoload/bundle with extreme prejudice
[ ! -e "${VIM_HOME}/autoload" ] || rm -rf "${VIM_HOME}/autoload" 
[ ! -e "${VIM_HOME}/bundle" ] || rm -rf "${VIM_HOME}/bundle"

ln -v -s "${VIM_PLUGINS}/bundle/vim-pathogen/autoload" "${VIM_HOME}/autoload"
ln -v -s "${VIM_PLUGINS}/bundle" "${VIM_HOME}/bundle"

