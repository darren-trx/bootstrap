#!/bin/bash

IDENT_INFO="$(date +'%F %T') - $(whoami) on $(hostname -f)"
GIT_USER='Darren Q'
GIT_EMAIL='darren.q@gmail.com'
GITHUB_USER='darren-trx'
GITHUB_REPO_WEB='https://github.com/darren-trx/bootstrap.git'
GITHUB_REPO_SSH='git@github.com:darren-trx/bootstrap.git'
GITHUB_REPO_DIR=~/bootstrap
GITHUB_PRIV_KEY=~/.ssh/github_rsa
GITHUB_AUTH_URL='https://api.github.com/user/keys'

# this script assumes it has been downloaded using:
# git clone <GITHUB_REPO_WEB> <GITHUB_REPO_DIR>
cd "${GITHUB_REPO_DIR}"
if [ $? -ne 0 ]; then echo "Could not cd into ${GITHUB_REPO_DIR}" && exit 1; fi

# generate new public/private key pair
ssh-keygen -t rsa -b 4096 -f "${GITHUB_PRIV_KEY}" -C "${IDENT_INFO}"

# use github api to authorize the public key
GITHUB_PUB_KEY=`cat "${GITHUB_PRIV_KEY}.pub"`
GITHUB_AUTH_JSON="{\"title\": \"${IDENT_INFO}\", \"key\": \"${GITHUB_PUB_KEY}\"}"

curl -s -d "${GITHUB_AUTH_JSON}" "${GITHUB_AUTH_URL}" -u "${GITHUB_USER}" | grep message

cd "${GITHUB_REPO_DIR}"

# if ~/.gitconfig already exists, just output a message
if [ -f ~/.gitconfig ]; then
  echo '~/.gitconfig already exists'
# if ~/.gitconfig does not exist, symlink the one
# in this directory or create a very basic one
else
  if [ -f "${GITHUB_REPO_DIR}/dotfiles/.gitconfig" ]; then
    ln -s "${GITHUB_REPO_DIR}/dotfiles/.gitconfig" ~/.gitconfig
  else
    git config --global user.name "${GIT_USER}"
    git config --global user.email "${GIT_EMAIL}"
    git config --global push.default simple
  fi
fi

# replace https remote with ssh one
git remote set-url --push origin "${GITHUB_REPO_SSH}" 

# start ssh agent
SSH_ENV=~/.ssh/env
/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
chmod 600 "${SSH_ENV}"
. "${SSH_ENV}" > /dev/null

# add the private key
ssh-add "${GITHUB_PRIV_KEY}"

# list currently loaded ssh keys
echo ""
ssh-add -l

# list current git repo remotes
echo ""
git remote -v

echo 'Now run . ~/.ssh/env'
