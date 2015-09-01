#!/bin/sh

mkdir -p ~/.vim/autoload ~/.vim/bundle

# time pope's download url
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/bling/vim-airline
git clone https://github.com/kien/ctrlp.vim
git clone https://github.com/nathanaelkane/vim-indent-guides
git clone https://github.com/terryma/vim-multiple-cursors

git clone https://github.com/airblade/vim-gitgutter
git clone https://github.com/tpope/vim-fugitive
vim -u NONE -c "helptags vim-fugitive/doc" -c q
