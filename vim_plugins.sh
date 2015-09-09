#!/bin/bash

VIM_PLUGINS_SRC="https://github.com/darren-trx/vim-plugins"

declare -A plugin
plugin["vim-pathogen"]="https://github.com/tpope/vim-pathogen"
plugin["vim-airline"]="https://github.com/bling/vim-airline"
plugin["ctrlp"]="https://github.com/kien/ctrlp.vim"
plugin["vim-indent-guides"]="https://github.com/nathanaelkane/vim-indent-guides"
plugin["vim-multiple-cursors"]="https://github.com/terryma/vim-multiple-cursors"
plugin["vim-gitgutter"]="https://github.com/airblade/vim-gitgutter"
plugin["vim-fugitive"]="https://github.com/tpope/vim-fugitive"
plugin["vim-gnupg"]="https://github.com/jamessan/vim-gnupg"

VIM_HOME="${HOME}/.vim"
VIM_PLUGINS="${HOME}/vim-plugins"

[ -d "${VIM_HOME}" ] || mkdir -v "${VIM_HOME}"
[ -d "${VIM_PLUGINS}" ] || git clone "${VIM_PLUGINS_SRC}" "${VIM_PLUGINS}"
[ -d "${VIM_PLUGINS}/bundle" ] || mkdir -v "${VIM_PLUGINS}/bundle"

cd "${VIM_PLUGINS}"

for p in "${!plugin[@]}"
do
  if [ ! -d "bundle/${p}" ]; then
    git subtree add --prefix "bundle/${p}" "${plugin[$p]}" master --squash
  else
    git subtree pull --prefix "bundle/${p}" "${plugin[$p]}" master --squash
  fi
done

if [ -L "${VIM_HOME}/autoload" ]; then
  rm -v "${VIM_HOME}/autoload"
else
  mv -vf "${VIM_HOME}/autoload" "${VIM_HOME}/autoload.bak"
fi

if [ -L "${VIM_HOME}/bundle" ]; then
  rm -v "${VIM_HOME}/bundle"
else
  mv -vf "${VIM_HOME}/bundle" "${VIM_HOME}/bundle.bak"
fi

ln -v -s "${VIM_PLUGINS}/bundle/vim-pathogen/autoload" "${VIM_HOME}/autoload"
ln -v -s "${VIM_PLUGINS}/bundle" "${VIM_HOME}/bundle"

