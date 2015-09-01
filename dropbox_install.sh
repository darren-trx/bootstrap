#!/bin/sh

cd ~

# Download Dropbox using wget
# ARCH="$(uname -m)"
# [ "$ARCH" = "x86_64" ] || ARCH="x86"
# wget "https://www.dropbox.com/download?plat=lnx.x86_64" -O dropbox_${ARCH}.tar.gz
# tar xzf dropbox_${ARCH}.tar.gz

# Download Dropbox using Python script
wget "https://www.dropbox.com/download?dl=packages/dropbox.py" -O ~/dropbox.py
chmod 755 ~/dropbox.py
echo 'y' | ~/dropbox.py start -i
# zombie dropbox daemon, no account linked yet
killall dropbox

# run the Dropbox daemon to properly link an account
~/.dropbox-dist/dropboxd
