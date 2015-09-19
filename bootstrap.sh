#!/bin/bash

Red=`tput setaf 1`
Reset=`tput sgr0`

# abort if current dir is not ~/bootstrap
if [ "$(pwd)" != "${HOME}/bootstrap" ]; then
  echo "${Red}Script not being run from ${HOME}/bootstrap, aborting${Reset}"
  exit 1
fi


### DOTFILES
read -n1 -t10 -p "### Dotfiles - Copy/Update? (y/n): " INSTALL_DOTFILES
echo
[ "$INSTALL_DOTFILES" == "y" ] && sudo ./dotfiles_setup.sh
echo

### MYGPG
diff -q ./mygpg.sh /usr/local/bin/mygpg
if [ $? -eq 0 ]; then
  echo "#### MyGPG - Up to date"
else
  read -n1 -t10 -p "### MyGPG - Copy/Update? (y/n): " INSTALL_MYGPG
  echo
  [ "$INSTALL_MYGPG" == "y" ] && sudo cp -vf ./mygpg.sh /usr/local/bin/mygpg
fi
echo

### VIM PLUGINS
if [ -d "${HOME}/.vim-plugins" ]; then
  VIM_PLUGINS='Exists'
else
  VIM_PLUGINS='Not found'
fi
read -n1 -t10 -p "### ~/.vim-plugins - $VIM_PLUGINS - Install/Update? (y/n): " INSTALL_VIM_PLUGINS
echo
[ "$INSTALL_VIM_PLUGINS" == "y" ] && ./vim_plugins.sh --refresh
echo

### GITHUB
if [ -f "${HOME}/.ssh/github_rsa" ]; then
  GITHUB_KEY='Exists'
else
  GITHUB_KEY='Not found'
fi
read -n1 -t10 -p "### GitHub Key - $GITHUB_KEY - Install/Update? (y/n): " INSTALL_GITHUB
echo
[ "$INSTALL_GITHUB" == "y" ] && ./github_key_setup.sh
echo

### PIP
if [ "$(type -P pip)" ]; then 
  PIP="Version $(pip --version | awk '{print $2}')"
else
  PIP="Not installed"
fi
read -n1 -t10 -p "### Pip - $PIP - Install/Update? (y/n): " INSTALL_PIP
echo
[ "$INSTALL_PIP" == "y" ] && sudo ./pip_install.sh
echo

### ANSIBLE
if [ "$(type -P ansible)" ]; then
  ANSIBLE="Version $(ansible --version | awk 'NR==1 {print $2}')"
else
  ANSIBLE="Not installed"
fi
read -n1 -t10 -p "### Ansible - $ANSIBLE - Install/Update? (y/n): " INSTALL_ANSIBLE
echo
[ "$INSTALL_ANSIBLE" == "y" ] && ./ansible_install.sh
echo

### DROPBOX
if [ "$(type -P dropbox)" ]; then
  DROPBOX="Installed"
else
  DROPBOX="Not installed"
fi
read -n1 -t10 -p "### Dropbox - $DROPBOX - Install/Update? (y/n): " INSTALL_DROPBOX
echo
[ "$INSTALL_DROPBOX" == "y" ] && ./dropbox_install.sh
echo

