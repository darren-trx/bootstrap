#!/bin/sh

### newer way (any distro)
### https://pip.pypa.io/en/latest/installing.html
# wget https://bootstrap.pypa.io/get-pip.py
# python get-pip.py

### older way (ubuntu/debian)
### should still result in a completely up to date pip
sudo apt-get install -y python-setuptools
sudo easy_install pip
sudo pip install pip --upgrade
