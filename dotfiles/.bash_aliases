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

alias ssh-github='ssh -T git@github.com'

# neatly display PATH env var (one entry per line)
alias path='echo -e ${PATH//:/\\n}'

# ansible-playbook shortcut that automatically opens vault by gpg decrypting vault password
alias apvault='gpg -q -d vault.asc 2>/dev/null | ansible-playbook --vault-password-file=/bin/cat'

# start lxc containers in disconnected mode due to bug
alias lxc-create='lxc-create -d'
