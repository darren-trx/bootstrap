# ~/.bash_aliases

# -h  human readable file sizes
# -A  show Almost all entries (not .. or .)
# -F  append indicator (*/=@|)
# -l  long listing format
alias ll='ls -lhAF --color'
alias ls='ls --color'

alias ..='cd ..'
alias mkdir='mkdir -pv'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

alias wget='wget -c'     # -c continue partial file
alias nano='nano -w'     # -w no line wrapping
alias shred='shred -uv'  # -u remove file afterwards, -v show progress

alias apt-get='sudo apt-get'

# neatly display PATH env var (one entry per line)
alias path='echo -e ${PATH//:/\\n}'

# dropbox control script
if [ -f "$HOME/dropbox.py" ]; then
  alias dropbox="$HOME/dropbox.py"
fi

alias gpg-enc="gpg --encrypt --armor -r darren.q@gmail.com"
alias gpg-sym="gpg --symmetric --cipher-algo AES256 --armor --verbose"

__gpg-run () { gpg -d "$1" 2>/dev/null | bash; }
alias gpg-run="__gpg-run"

alias gpg-ls="gpg --list-keys && gpg --list-secret-keys"
alias gpg-fp="gpg --fingerprint darren.q@gmail.com | awk -F'=' '/Key fingerprint/ {print \$2}' | sed 's/ //g'"

__gpg-del() {
  gpg --delete-secret-keys --batch --yes "$(gpg-fp)"
  gpg --delete-keys --batch --yes darren.q@gmail.com
}
alias gpg-del="__gpg-del"

__gpg-add() { 
  echo "$1" | egrep -q "\.gpg$|\.asc$"
  if [ $? -eq 0 ]; then
    gpg -d "$1" | gpg --import
  else
    gpg --import "$1"
  fi
  echo "$(gpg-fp):6:" | gpg --import-ownertrust
}
alias gpg-add="__gpg-add"

