#!/bin/sh

# sshpass is required for password-based ssh login
sudo apt-get install -y sshpass

# install pip if necessary
[ "$(which pip)" ] || sudo ./pip_install.sh

# install relevent modules, then ansible itself
sudo pip install paramiko PyYAML Jinja2 httplib2 dopy passlib ansible

ansible --version
whereis ansible
