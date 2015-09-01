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

alias wget='wget -c'    # -c continue partial file
alias nano='nano -w'    # -w no line wrapping

alias apt-get='sudo apt-get'

# neatly display PATH env var (one entry per line)
alias path='echo -e ${PATH//:/\\n}'

# dropbox control script
alias dropbox="$HOME/dropbox.py"
