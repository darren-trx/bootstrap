#!/bin/sh

sudo apt-get install -y sshpass

# install pip if necessary
[ "$(which pip)" ] || sudo ./pip_install.sh

sudo pip install paramiko PyYAML Jinja2 httplib2 \
                 dopy passlib credstash \
                 ansible

ansible --version
