#!/bin/bash

# YADSWS
# Yet Another Dotfiles Symlinker, With Color!

DOTFILES_BKP_DIR="${HOME}/dotfiles_backup"
DOTFILES_GIT_DIR="${HOME}/bootstrap/dotfiles"

Red=`tput setaf 1`
Green=`tput setaf 2`
Yellow=`tput setaf 3`
Blue=`tput setaf 4`
Grey=`tput setaf 8`
Orange=`tput setaf 9`
BGreen=`tput setaf 10`
BYellow=`tput setaf 11`
BBlue=`tput setaf 12`
Reset=`tput sgr0`

status_msg() {
  local RESULT=""
  if [ "$2" ]; then
    case "$2" in
      0) RESULT="${Green}OK${Reset}" ;;
      1) RESULT="${Red}FAIL${Reset}" ;;
      *) RESULT="${Orange}??${Reset}" ;;
    esac
    echo -n " ... ${1} [ ${RESULT} ]"
  else
    echo -n " ... ${1}"
  fi
}

for DF in $( ls -A "${DOTFILES_GIT_DIR}" )
do
  echo -n "${Yellow}${DF}${Reset}"
  RET=0
  # if the file already exists in ~/
    # if the existing file is a symlink, just remove it
    if [ -L "${HOME}/${DF}" ]; then
      # if the symlink does not point to the right location
      if [ "$(readlink ${HOME}/${DF})" != "${DOTFILES_GIT_DIR}/${DF}" ]; then
        rm -f "${HOME}/${DF}"
        RET=$?
        status_msg "Deleting existing symlink" "$RET"
      else
        # file is a sym link pointing to the right location
        status_msg "${Grey}Matches existing symlink, skipping${Reset}"
        RET=2
      fi
    # if the existing file is not a symlink, back it up first
    elif [ -f "${HOME}/${DF}" ] || [ -d "${HOME}/${DF}" ]; then

      # create backup dir if it does not exist already
      if [ ! -d "${DOTFILES_BKP_DIR}" ]; then mkdir -p "${DOTFILES_BKP_DIR}"; fi

      # delete any existing backup of this file/dir
      if [ -e "${DOTFILES_BKP_DIR}/${DF}" ]; then rm -rf "${DOTFILES_BKP_DIR}/${DF}"; fi

      mv -f "${HOME}/${DF}" "${DOTFILES_BKP_DIR}/${DF}"
      RET=$?
      status_msg "Backing up file/dir" "$RET"
    fi

  # if the file existed in ~/ it should have been moved or deleted
  # and sym linking should be safe to perform now
  if [ $RET -eq 0 ]; then
    ln -s "${DOTFILES_GIT_DIR}/${DF}" "${HOME}/${DF}"
    RET=$?
    status_msg "Creating symlink" "$RET"
  fi

  # line break
  echo

done

# Reload bashrc automatically
source "${HOME}/.bashrc"
