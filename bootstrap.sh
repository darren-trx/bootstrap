#!/bin/bash

Red=`tput setaf 1`
Green=`tput setaf 2`
Yellow=`tput setaf 3`
Blue=`tput setaf 4`
Cyan=`tput setaf 14`
Reset=`tput sgr0`

# abort if current dir is not ~/bootstrap
if [ "$(pwd)" != "${HOME}/bootstrap" ]; then
  echo "${Red}Script not being run from ${HOME}/bootstrap, aborting${Reset}"
  exit 1
fi


### DOTFILES
DOTFILES=0
# exclude . .. and directories from ls results
for DF in $(ls -Ap "${HOME}/bootstrap/dotfiles" | egrep -v "/$")
do
  [ -h "${HOME}/${DF}" ] || let DOTFILES+=1
done

if [ $DOTFILES -eq 0 ]; then
  DF_STATUS="${Green}Up to date${Reset}"
else
  DF_STATUS="${Red}$DOTFILES Not symlinked${Reset}"
fi

read -n1 -t10 -p "${Yellow}Dotfiles${Reset}      ${DF_STATUS}   Copy/Update? (y/n): " INSTALL_DOTFILES
echo
[ "$INSTALL_DOTFILES" == "y" ] && ./dotfiles_nix.sh
echo

### MYGPG
if [ -f /usr/local/bin/mygpg ]; then
  diff -q ./mygpg.sh /usr/local/bin/mygpg &>/dev/null
  if [ $? -eq 0 ]; then
    MYGPG="${Green}Up to date${Reset}"
  else
    MYGPG="${Red}Does not match${Reset}"
  fi
else
  MYGPG="${Red}Not found${Reset}"
fi
read -n1 -t10 -p "${Yellow}MyGPG${Reset}         $MYGPG   Copy/Update? (y/n): " INSTALL_MYGPG
echo
[ "$INSTALL_MYGPG" == "y" ] && sudo cp -vf ./mygpg.sh /usr/local/bin/mygpg
echo

### VIM PLUGINS
if [ -d "${HOME}/.vim-plugins" ]; then
  VIM_PLUGINS="${Green}Exists${Reset}"
else
  VIM_PLUGINS="${Red}Not found${Reset}"
fi
read -n1 -t10 -p "${Yellow}Vim Plugins${Reset}   $VIM_PLUGINS   Install/Update? (y/n): " INSTALL_VIM_PLUGINS
echo
[ "$INSTALL_VIM_PLUGINS" == "y" ] && ./vim_plugins.sh
echo

### GITHUB
if [ -f "${HOME}/.ssh/github_rsa" ]; then
  GITHUB_KEY="${Green}Exists${Reset}"
else
  GITHUB_KEY="${Red}Not found${Reset}"
fi
read -n1 -t10 -p "${Yellow}GitHub Key${Reset}    $GITHUB_KEY   Install/Update? (y/n): " INSTALL_GITHUB
echo
[ "$INSTALL_GITHUB" == "y" ] && ./github_key_setup.sh
echo

### PIP
if [ "$(type -P pip)" ]; then 
  PIP="${Green}$(pip --version | awk '{print $2}')${Reset}"
else
  PIP="${Red}Not installed${Reset}"
fi
read -n1 -t10 -p "${Yellow}Pip${Reset}           $PIP   Install/Update? (y/n): " INSTALL_PIP
echo
[ "$INSTALL_PIP" == "y" ] && sudo ./pip_install.sh
echo

### ANSIBLE
if [ "$(type -P ansible)" ]; then
  ANSIBLE="${Green}$(ansible --version | awk 'NR==1 {print $2}')${Reset}"
else
  ANSIBLE="${Red}Not installed${Reset}"
fi
read -n1 -t10 -p "${Yellow}Ansible${Reset}       $ANSIBLE   Install/Update? (y/n): " INSTALL_ANSIBLE
echo
[ "$INSTALL_ANSIBLE" == "y" ] && ./ansible_install.sh
echo

### DROPBOX
if [ "$(type -P dropbox)" ]; then
  DROPBOX="${Green}Installed${Reset}"
else
  DROPBOX="${Red}Not installed${Reset}"
fi
read -n1 -t10 -p "${Yellow}Dropbox${Reset}       $DROPBOX   Install/Update? (y/n): " INSTALL_DROPBOX
echo
[ "$INSTALL_DROPBOX" == "y" ] && ./dropbox_install.sh
echo

