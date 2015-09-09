#!/bin/sh

MYGPG_EMAIL="darren.q@gmail.com"

MYGPG_SRC="${HOME}/bootstrap/mygpg.sh"
MYGPG_BIN="/usr/local/bin/mygpg"
THIS_FILE=$(readlink -f "$0")

if [ "${THIS_FILE}" != "${MYGPG_BIN}" ]; then
  sudo cp -v "${MYGPG_SRC}" "${MYGPG_BIN}"
  exit 1
fi

mygpg_fp_key() {
  gpg --fingerprint $MYGPG_EMAIL 2>/dev/null | awk -F'=' '/Key fingerprint/ {print $2}' | sed 's/ //g'
}
mygpg_clear_at() {
  ATQ="$(atq | cut -f1)"
  if [ "$ATQ" != "" ]; then
    for i in "$ATQ"; do
      at -c $i | grep -qow "$MYGPG_BIN"
      [ $? -gt 0 ] || atrm $i &>/dev/null
    done
  fi
}
mygpg_del_key() {
  MYGPG_FP="$(mygpg_fp_key)"
  if [ "$MYGPG_FP" != "" ]; then
    echo "Deleting secret key for $MYGPG_EMAIL $MYGPG_FP"
    gpg --delete-secret-keys --batch --yes "$MYGPG_FP"
    echo "Deleting public key for $MYGPG_EMAIL"
    gpg --delete-keys --batch --yes $MYGPG_EMAIL
  else
    echo "No key(s) loaded for $MYGPG_EMAIL"
  fi
  mygpg_clear_at
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
  
  # flush the key after 5 hours, deleting any existing at jobs first
  mygpg_clear_at
  echo "$MYGPG_BIN -d" | at now + 300 minutes
}

case "$1" in
  "-e")
    gpg --encrypt --armor -r $MYGPG_EMAIL "$2";;
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
    echo "  My GPG Key: $MYGPG_EMAIL $(mygpg_fp_key)
      -e  asymmetrically encrypt <file> using my gpg key
      -s  symetrically encrypt <file> using AES256
      -r  run <file> with bash
      -a  add gpg key (encrypted or not)
      -d  delete my gpg key"
    ;;
esac
