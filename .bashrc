# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=5000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

PROMPT_COMMAND='printf "\033]0;%s:%s\007" "${USER}" "${PWD/#$HOME/~}"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls="export GLOBIGNORE_TMP=$GLOBIGNORE; export GLOBIGNORE=$GLOBIGNORE:.*:$(tr '\n' ':' < .hidden); ls -dC --color=auto *; export GLOBIGNORE=$GLOBIGNORE_TMP"

    #function _ls() {
    #    GLOBIGNORE_TMP=$GLOBIGNORE
    #    export GLOBIGNORE=$GLOBIGNORE:.*:$(tr '\n' ':' < .hidden)
    #    ls -dC --color=auto * $@
    #    export GLOBIGNORE=$GLOBIGNORE_TMP
    #}
    alias ls="ls --color=auto"

    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

source ~/.aliases

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# show available tmux sessions + reminder when using ssh
if [ -z "$TMUX" ] && [ "$0" == "-bash" ]; then
    if [ "$SSH_CONNECTION" ]; then
        if [ "$(tmux list-sessions | grep -e '.*\]$')" ]; then
            echo -e "\033[0;31mavailabe tmux sessions: \033[m"
            tmux list-sessions | grep -e ".*\]$" --color=never
        else
            echo -e "\033[0;31mremember to use tmux\033[m"
        fi
    fi
fi

## custom aliases ##
alias l='ls -lh'
alias ..='cd ..'
alias psg='ps -A | grep'
# TF_ALIAS=fuck alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
# eval $(thefuck --alias --enable-experimental-instant-mode)
# THEFUCK_ALTER_HISTORY=true

alias black='xset dpms force off'

export HISTSIZE=50000
export HISFILESIZE=5000000

#source ~/.tmux_completion
if [[ $PWD == /home-store/ca/* ]] ; then
    cd ~/${PWD:15}
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

PROMPT_DIRTRIM=4 # don't display more than 4 directories in prompt

if [ "$color_prompt" = yes ]; then
    SUDO_INDICATOR='$(if sudo -n true 2>/dev/null; then echo "\[\e[01;31m\]"; else echo "\[\e[01;34m\]"; fi)'
    PS1='\[\e[01;30m\]B ${debian_chroot:+($debian_chroot)}\[\e[0;33m\]\A \[\e[01;32m\]\w '$SUDO_INDICATOR'\$\[\e[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt SUDO_INDICATOR

UNI=~/Documents/Uni

bind -f ~/.bash_inputrc

function mkcd() {
    if [[ $# -ne 1 ]]; then
        echo 'bash mkcd: too many arguments'
    fi
    mkdir -p $1
    cd $1
}
if [ "$TERM" == "linux" ]; then
    [ -n $FBTERM ] && export TERM=fbterm
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# For dotfiles management (see https://www.atlassian.com/git/tutorials/dotfiles)
# (except there it's called 'config' instead of 'dotfiles')
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi
