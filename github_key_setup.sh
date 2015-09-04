#!/bin/bash

IDENT_INFO="$(date +'%F %T') - $(whoami) on $(hostname -f)"
GIT_USER='Darren Q'
GIT_EMAIL='darren.q@gmail.com'
GITHUB_USER='darren-trx'
GITHUB_REPO_WEB='https://github.com/darren-trx/bootstrap.git'
GITHUB_REPO_SSH='git@github.com:darren-trx/bootstrap.git'
GITHUB_REPO_DIR="${HOME}/bootstrap"
GITHUB_PRIV_KEY="${HOME}/.ssh/github_rsa"
GITHUB_AUTH_URL='https://api.github.com/user/keys'

# this script assumes it has been downloaded using:
# git clone <GITHUB_REPO_WEB> <GITHUB_REPO_DIR>
cd "${GITHUB_REPO_DIR}"
if [ $? -ne 0 ]; then
  echo "Could not cd into ${GITHUB_REPO_DIR}"
  exit 1
fi

# generate new public/private key pair (RSA 4096)
ssh-keygen -t rsa -b 4096 -f "${GITHUB_PRIV_KEY}" -C "${IDENT_INFO}"

# use github api to authorize the public key
GITHUB_PUB_KEY=`cat "${GITHUB_PRIV_KEY}.pub"`
GITHUB_AUTH_JSON="{\"title\": \"${IDENT_INFO}\", \"key\": \"${GITHUB_PUB_KEY}\"}"

# -s silent, -u Server user, -d Data to send (POST)
curl -s -u "${GITHUB_USER}" -d "${GITHUB_AUTH_JSON}" "${GITHUB_AUTH_URL}" | grep message

# if ~/.gitconfig already exists, prompt user if it should be deleted
if [ -e "${HOME}/.gitconfig" ]; then
  read -n1 -t10 -p "${HOME}/.gitconfig already exists, delete it? (y/n): " DEL_GIT_CFG
  echo
  if [ "${DEL_GIT_CFG}" == "y" ]; then 
    rm -fv "${HOME}/.gitconfig"
  else
    echo "Existing .gitconfig left as is"
  fi
fi

# if ~/.gitconfig does not exist, either:
# (A) symlink the one from the git repo dotfiles dir, or
# (B) create a new one with only the bare necessities
if [ ! -e "${HOME}/.gitconfig" ]; then
  if [ -f "${GITHUB_REPO_DIR}/dotfiles/.gitconfig" ]; then
    ln -v -s "${GITHUB_REPO_DIR}/dotfiles/.gitconfig" "${HOME}/.gitconfig"
  else
    git config --global user.name "${GIT_USER}"
    git config --global user.email "${GIT_EMAIL}"
    git config --global push.default simple
  fi
fi

# set git push remote origin to ssh url
git remote set-url --push origin "${GITHUB_REPO_SSH}" 
# leave pull/fetch remote origin as is so it still works if the key is later revoked

# create an ssh agent env file if there isnt one already
SSH_ENV="${HOME}/.ssh/env"
if [ ! -f "${SSH_ENV}" ]; then
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
fi

# list current git repo remotes
echo
echo "Github remote repos:"
git remote -v
echo
echo 'Now run:'
echo '1) . ~/.ssh/env'
echo '2) ssh-add ~/.ssh/github_rsa'
