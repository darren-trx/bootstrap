#!/bin/sh

MY_GPG="darren.q@gmail.com"

mygpg_fp_key() {
  gpg --fingerprint $MY_GPG | awk -F'=' '/Key fingerprint/ {print $2}' | sed 's/ //g'
}
mygpg_del_key() {
  echo "Deleting secret key for $MY_GPG $(mygpg_fp_key)"
  gpg --delete-secret-keys --batch --yes "$(mygpg_fp_key)"
  echo "Deleting public key for $MY_GPG"
  gpg --delete-keys --batch --yes $MY_GPG
}
mygpg_add_key() { 
  echo "$1" | egrep -q "\.gpg$|\.asc$"
  if [ $? -eq 0 ]; then
    gpg -d "$1" | gpg --import
  else
    gpg --import "$1"
  fi

  # trust this key ultimately (6)
  echo "$(mygpg_fp_key):6:" | gpg --import-ownertrust

  # flush the key after 5 hours, deleting any other gpg-del jobs first
  for i in "$(atq | cut -f1)"; do
    at -c $i | grep -qow "$HOME/.mygpg.sh"
    [ $? -gt 0 ] || atrm $i &>/dev/null
  done
  echo "$HOME/.mygpg.sh -d" | at now + 300 minutes
}

case "$1" in
  "-e")
    gpg --encrypt --armor -r $MY_GPG "$2";;
  "-s")
    gpg --symmetric --cipher-algo AES256 --armor --verbose "$2";;
  "-r")
    gpg -d "$2" 2>/dev/null | bash;;
  "-a")
    mygpg_add_key "$2";;
  "-d")
    mygpg_del_key "$2";;
  "-f")
    mygpg_fp_key;;
  "-l")
    gpg --list-keys && gpg --list-secret-keys;;
  *)
    gpg "$@";;
esac
