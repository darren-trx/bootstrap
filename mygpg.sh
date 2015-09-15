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
# remove any mygpg jobs in the at queue
mygpg_clear_at() {
  ATQ="$(atq | cut -f1)"
  if [ "$ATQ" != "" ]; then
    for i in "$ATQ"; do
      at -c $i | grep -qow "$MYGPG_BIN"
      [ $? -gt 0 ] || atrm $i &>/dev/null
    done
  fi
}
mygpg_delete_key() {
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
mygpg_import_key() { 
  echo "$1" | egrep -q "\.gpg$|\.asc$"
  if [ $? -eq 0 ]; then
    gpg -d "$1" | gpg --import
  else
    gpg --import "$1"
  fi

  # trust this key ultimately (6)
  echo "$(mygpg_fp_key):6:" | gpg --import-ownertrust
  
  # clear out any mygpg jobs from the at queue
  mygpg_clear_at
  # schedule a new job to delete the key after 5 hours
  echo "$MYGPG_BIN -d" | at now + 300 minutes
}

mygpg_encrypt() {
  FILE_IN="${1}"
  FILE_OUT="${2}"
  if [ "${FILE_OUT}" ]; then
    if [ -d "${FILE_OUT}" ]; then
      FILE_OUT="-o ${2}/${1}.asc"
    else
      FILE_OUT="-o ${2}.asc"
    fi
  fi
  gpg --encrypt --armor ${FILE_OUT} -r ${MYGPG_EMAIL} "${FILE_IN}"
}

mygpg_gen_key() {
  # if rng-tools is not installed, install it
  [ "$(which rngd)" ] || sudo apt-get install -y rng-tools
  
  # if rng-tools is installed, generate entropy with it
  if [ "$(which rngd)" ]; then
    sudo rngd -r /dev/urandom
  else
    echo "rngd not found, generate entropy manually"
  fi
  gpg --gen-key
}

case "$1" in
  "-e")
    mygpg_encrypt "$2" "$3";;
  "-s")
    gpg --symmetric --cipher-algo AES256 --armor --verbose "$2";;
  "-r")
    gpg -d "$2" 2>/dev/null | bash;;
  "-g")
    mygpg_gen_key;;
  "-i")
    mygpg_import_key "$2";;
  "-d")
    mygpg_delete_key "$2";;
  "-f")
    mygpg_fp_key;;
  "-l")
    gpg --list-keys && gpg --list-secret-keys;;
  *)
    echo "My GPG Key: $MYGPG_EMAIL $(mygpg_fp_key)
    -e  asymmetrically encrypt <file> using my gpg key
    -s  symetrically encrypt <file> using AES256
    -r  run <file> by piping it into bash
    -g  generate gpg key (installs rng-tools)
    -i  import gpg key (can be encrypted)
    -d  delete my gpg key from keychain
    -f  show fingerprint of my gpg key
    -l  list all loaded gpg keys"
    ;;
esac
