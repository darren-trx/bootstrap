# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Custom dir/file colors
# export LS_COLORS='di=1;36:fi=1:*.zip=33:*.iso=1;33:*.msi=1;32:*.gif=1;35:*.db=0;37:*.pdf=1;35'

# Set default "full-fledged" editor
# (Bash attempts to load $VISUAL before $EDITOR)
export VISUAL=vim

# History settings
export HISTSIZE=10000
# avoid duplicates
export HISTCONTROL=ignoredups:erasedups
# include PID & date/time
export HISTTIMEFORMAT='%F %T  '
# append history on shell exit (logout) instead of overwriting history file
shopt -s histappend
# keep multi line commands together in history
shopt -s cmdhist
# Append every command to history individually and immediately
# (allowing real-time history sharing between tmux panes)
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

GIT_PS1_VARTYPE=`type __git_ps1 2>/dev/null | awk '(NR==1){print $NF}'`
if [ "$GIT_PS1_VARTYPE" != "function" ]; then
  if [ -f ~/.git-prompt.sh ]; then 
    source ~/.git-prompt.sh
  else
    echo "__git_ps1 not defined and ~/.git-prompt.sh not found - to download it:"
    echo "curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh"
  fi
fi

# Git auto-completion, coloring, and branch hints
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

if [ -f ~/.bash_ssh_agent ]; then source ~/.bash_ssh_agent; fi
if [ -f ~/.bash_aliases ]; then source ~/.bash_aliases; fi
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

#if [ -f ~/docker-completion.bash ]; then source ~/docker-completion.bash; fi

# fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# homebrew
[ -d /home/linuxbrew/.linuxbrew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# PS1 variables, functions, etc.
Color_Off="\[\033[0m\]"
Black="\[\033[0;30m\]"
White="\[\033[0;37m\]"
Grey="\[\033[1;30m\]"
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]" 
Blue="\[\033[0;34m\]"
Blue2="\[\033[38;5;32m\]"
Cyan="\[\033[0;36m\]"
Cyan2="\[\033[38;5;24m\]"
Cyan3="\[\033[38;5;31m\]"
Yellow="\[\033[0;33m\]"
BRed="\[\033[1;31m\]"
BGreen="\[\033[1;32m\]"
BYellow="\[\033[1;33m\]"
BBlue="\[\033[1;34m\]"
BCyan="\[\033[1;36m\]"

# if xterm is being run under X, then set TERM to 256 color (for vim color scheme)
if [ -n "$DISPLAY" ] && [ "$TERM" == "xterm" ]; then
  export TERM=xterm-256color
fi

if [ "$(which git)" ]; then
PS1=$Cyan'\u'$Cyan2'@'$Cyan3'\h '$Color_Off'\
$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1;\
if [ "$?" -eq "0" ]; then echo "'$Green'"; else echo "'$Red'"; fi)$(__git_ps1 "[%s]") ";\
fi)'$Yellow'\w '$BGreen'\$ '$Color_Off
else
PS1=$Cyan'\u@\h '$Yellow'\w \$ '$Color_Off
fi

# export -n PS1 to demote it from an env var to a shell var
# (this prevents it from being used in other shells, ie. sh)
export -n PS1
