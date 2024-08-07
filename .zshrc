# vi: set fdm=marker
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
exec 9>&1

# for profiling zsh startup
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
	zmodload zsh/datetime
	zmodload zsh/zprof
	setopt PROMPT_SUBST
	TIME0=$EPOCHREALTIME
	PS4='+$(( ($EPOCHREALTIME - '$TIME0')*1000 )) %N:%i> '
	logfile=$(mktemp zsh_profile.XXXXXXXX)
	echo "Logging to $logfile"
	exec 3>&2 2>$logfile
	setopt XTRACE
fi


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


if [[ ! -z $DTACH_ID ]]; then
	echo "dtach ID: $DTACH_ID"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# https://gnunn1.github.io/tilix-web/manual/vteconfig/
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
	source /etc/profile.d/vte.sh
fi

# Plugins {{{
#
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# ------------------------------------------------------------
plugins=(
	# https://github.com/zdharma-continuum/fast-syntax-highlighting
	# there is also another fork at https://github.com/z-shell/F-Sy-H
	# F-Sy-H
	fast-syntax-highlighting
	git
	zsh-autosuggestions
	zsh-completions
	sudo
	zoxide
	zsh-histdb
	zsh-histdb-fzf
	zsh-notify
)

_Z_NO_RESOLVE_SYMLINKS="true"
# }}}

# source $ZSH/oh-my-zsh.sh
source $ZSH/my-zsh.sh

autoload -Uz add-zsh-hook # the zsh-histdb plugin might need this?

# set and load theme
# ZSH_THEME="custom-powerline"
ZSH_THEME="powerlevel10k/powerlevel10k"
source "$ZSH/custom/themes/$ZSH_THEME.zsh-theme"

# zsh-autosuggestions {{{
ZSH_AUTOSUGGEST_MANUAL_REBIND=1 #https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
_BORING_COMMANDS=("^ls?$" "^(cd|~)$" "^ " '^\.\.+$' "^h?top$" '^exit$' '^z ' '^(_ |sudo )? (pm-suspend|reboot)$' "^histdb")

_zsh_autosuggest_strategy_histdb_top() {
	local query="
	select commands.argv from history
		left join commands on history.command_id = commands.rowid
		left join places on history.place_id = places.rowid
		where commands.argv LIKE '$(sql_escape $1)%'
		group by commands.argv, places.dir
		order by places.dir != '$(sql_escape $PWD)', exit_status IS NULL, min(exit_status), count(commands.argv) desc, max(start_time) desc
		limit 1
		"
		suggestion=$(_histdb_query "$query")
}

_zsh_autosuggest_strategy_histdb_top_sudo() {
	if [[ "$1" =~ '_ .*' ]]; then
		q=${1#_ }
	elif [[ "$1" =~ 'sudo .*' ]]; then
		q=${1#sudo }
	else
		return
	fi
	local query="
	select commands.argv from history
		left join commands on history.command_id = commands.rowid
		left join places on history.place_id = places.rowid
		where commands.argv LIKE '_ $(sql_escape $q)%' OR commands.argv LIKE 'sudo $(sql_escape $q)%' OR commands.argv LIKE '$(sql_escape $q)%'
		group by commands.argv, places.dir, start_time
		order by commands.argv LIKE '$(sql_escape $q)%', places.dir != '$(sql_escape $PWD)', exit_status IS NULL, min(exit_status), count(commands.argv) desc, max(start_time) desc
		limit 1
		"
		suggestion=$(_histdb_query "$query")
		if [ -n "$suggestion" ]; then
			if [[ "$suggestion" =~ '_ .*' ]]; then
				suggestion="$1${suggestion#_ $q}"
			elif [[ "$suggestion" =~ 'sudo .*' ]]; then
				suggestion="$1${suggestion#sudo $q}"
			else
				suggestion="$1${suggestion#$q}"
			fi
		fi
}

_zsh_autosuggest_strategy_zoxide() {
	if [[ "$1" =~ '^z .*' ]]; then
		query=${1#* }
	elif [[ "$1" == "z" ]]; then
		query=''
	else
		return
	fi
	ans=$(eval "zoxide query $query" 2>/dev/null)
	if [[ $? == 0 ]]; then
		rel=${ans#$PWD/}

		if [[ "z $ans" =~ "^$1.*" ]]; then
			typeset -g suggestion="z $ans # ✔"
		elif [[ "z $rel" =~ "^$1.*" ]]; then
			typeset -g suggestion="z $rel # ✔"
		# elif [[ "$short" =~ "^$query.*" ]]; then
		# 	suggestion="z $short # ✔"
		else
			if [[ ! "$rel" == "$ans" ]]; then
				short=$rel
			else
				short=$(print -D $ans)
			fi
			typeset -g suggestion="$1 # -> "$short
		fi


		# if [[ "${ans#$PWD/}" =~ "^$query.*" ]]; then
		# 	suggestion="z ${ans#$PWD/} # ✔"
		# elif [[ "$ans" =~ "^$query.*" ]]; then
		# 	suggestion="z $ans # ✔"
		# else
		# 	suggestion=' # -> '${$(print -D $ans)#$(print -D $PWD)/#./}
		# fi
	else
		typeset -g suggestion="$1 # ✘"
	fi
}

ZSH_AUTOSUGGEST_STRATEGY=(zoxide histdb_top_sudo histdb_top completion)

# }}}

# zsh-notify {{{
zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"
zstyle ':notify:*' expire-time 2500
zstyle ':notify:*' app-name zsh
zstyle ':notify:*' check-focus no
zstyle ':notify:*' command-complete-timeout 20
function kitty-notify() {
    local message type time_elapsed title icon

    if [[ "$TERM" != "xterm-kitty" ]] && is-terminal-active; then
		echo "TERM=$TERM"
		zsh-notify "$@"
		return
    fi

    if [[ $# -lt 2 ]]; then
        echo usage: notifier TYPE TIME_ELAPSED 1>&2
        return 1
    fi

    zstyle -s ':notify:' plugin-dir plugin_dir
    source "$plugin_dir"/lib

    type="$1"
    time_elapsed="$(format-time "$2")"
    message=$(<&0)

    # zstyle -s ':notify:' expire-time expire_time

    title=$(notification-title "$type" time_elapsed "$time_elapsed")

    # notify-send -a "${=app_name}" -t $expire_time ${=icon_option} "$title" -- "$message"
    # notify-send -a "${=app_name}" -t $expire_time ${=icon_option} "$title" -- "$message"
	printf "\x1b]99;i=1:d=0:o=unfocused;$title\x1b\\"
	printf "\x1b]99;i=1:d=1:p=body:o=unfocused;$message\x1b\\"
}
zstyle ':notify:*' notifier kitty-notify
# }}}

# keybinding for sudo plugin (I didn't like the default)
bindkey "\e-" sudo-command-line

# User configuration {{{
setopt autocd # just type dir name to cd into it
setopt hist_ignorespace
setopt hist_ignore_dups
setopt correct
# superglobs (https://askubuntu.com/questions/1577/moving-from-bash-to-zsh)
setopt extendedglob
unsetopt caseglob
setopt nonomatch

autoload -U select-word-style
select-word-style bash
# }}}

# set environment variables {{{
export BAT_PAGER='less -RFS'
export LESS='-RF --mouse --wheel-lines=5'
TIMEFMT='%J  %*U user %*S system %P cpu %*E total' # millisecond precision in time
export LANG=en_US.UTF-8
REPORTTIME=10

# history settings
HISTSIZE=130000 # in memory
SAVEHIST=100000 # in file

source ~/.shellvars

# }}}

# export MANPATH="/usr/local/man:$MANPATH"

# aliases {{{
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias zshconfig="vi ~/.zshrc"
#alias o='xdg-open' # use function insted (calls vim for text files)
source ~/.aliases
# }}}

# functions (supposed to be called by the end user) {{{
function mkcd() {
	if [[ $# -ne 1 ]]; then
		echo 'bash mkcd: too many arguments'
	fi
	mkdir -p $1
	cd $1
}

# make `cd <filename>` take me to the directory of that file
cd() {
    [[ ! -e $argv[-1] ]] || [[ -d $argv[-1] ]] || argv[-1]=${argv[-1]%/*}
    builtin cd "$@"
}

function o() {
	for_vim=""
	for f in $@; do
		if [ "$f" =~ ".*\.(txt|md|log|py|tex|cpp|c|h|xml|html|sh|zsh|bib)" ]; then
			for_vim="$for_vim $f"
		else xdg-open "$f" 2>/dev/null
		fi
	done
	if [ -n "$for_vim" ]; then
		eval "vi -p $for_vim"
	fi
}
# }}}

# sudo indicator {{{
zmodload zsh/datetime
# SUDO_TIMEOUT=$(( $(sudo -l | grep -oP '(?<=timestamp_timeout\=)\d+')*60 )) # this is a bit slow
SUDO_TIMEOUT=1800

# writes timestamp (in variable) if we have sudo privileges
_SUDO_TIMESTAMP=0
function sudo() {
	/usr/bin/sudo $@
	local STAT=$?
	if /usr/bin/sudo -n true 2>/dev/null; then
		_LAST_SUDO_TIME=$EPOCHREALTIME
	else
		_LAST_SUDO_TIME=0
	fi
	return $STAT
}
#}}}

compdef vi=nvim # define completions for vi command
zstyle ':completion:*:*:vi:*' file-patterns '^*.(aux|log|pdf|fls|fdb_latexmk|toc|synctex.gz|out|bbl|blg|bak):source-files' '*:all-files' # make vim ignore .aux files etc.

# show available tmux sessions + reminder when using ssh {{{
if [ -z "$TMUX" ] && [ "$0" = "-zsh" ]; then
	if [ "$SSH_CONNECTION" ]; then
		if [ "$(tmux list-sessions | grep -e '.*\]$')" ]; then
			echo -e "\033[0;31mavailabe tmux sessions: \033[m"
			tmux list-sessions | grep -e ".*\]$" --color=never
		else
			echo -e "\033[0;31mremember to use tmux\033[m"
		fi
	fi
fi
# }}}

# zle keybindings {{{
bindkey "\C-h" backward-kill-word # ctrl + BS
bindkey "\e[3;5~" kill-word # ctrl + del
#bindkey -s "\ez" "  \e[D\C-k\C-a\C-k cd -\015\C-y\C-y\ey\C-x\C-x\e[D\e[3~\e[3~"
#bindkey -s "\ee" "  \e[D\C-k\C-a\C-k nautilus . 2>/dev/null&\015\C-y\C-y\ey\C-x\C-x\e[D\e[3~\e[3~"

# bindkey -s "\eE" "\C-q nautilus . 2>/dev/null&\C-m"
function _zle_guifiles {
	xdg-open . 2>&1 >/dev/null
}
zle -N _zle_guifiles
bindkey "\eE" _zle_guifiles

#bindkey -s "\C-f" "\e[A | grep -e \'\'\e[D"
bindkey "\ep" up-line-or-beginning-search
bindkey "\en" down-line-or-beginning-search
bindkey -M menuselect '?' history-incremental-search-forward
bindkey -s "\e#" "\C-a#\C-m"

bindkey -s "\eL" "\C-q exa -lah\C-m"
bindkey -s "\el" "\C-q ls\C-m"
# function _zle_ls { zle push-line; echo; ls; zle redisplay }
# function _zle_ll { exa -lhH }
# zle -N _zle_ls
# zle -N _zle_ll
# bindkey "\el" _zle_ls
# bindkey "\eL" _zle_ll

bindkey "\e[1;3C" forward-char
bindkey "\e[1;3D" backward-char
bindkey "\e;" forward-char

bindkey '\t' menu-complete # https://unix.stackexchange.com/questions/665913/how-to-make-zsh-immediately-show-all-completions-without-first-inserting-the

noop () { }
zle -N noop
bindkey "\e" noop
KEYTIMEOUT=50

autoload -U select-word-style
backward-kill-WORD () {
	select-word-style w
	zle backward-kill-word
	select-word-style n
}
zle -N backward-kill-WORD
bindkey '\C-w' backward-kill-WORD

function _zle_home_dir {
	cd
	for precmd in $precmd_functions; do
		$precmd
	done
	zle reset-prompt
	zle autosuggest-fetch
}
function _zle_updir {
	cd - > /dev/null
	for precmd in $precmd_functions; do
		$precmd
	done
	zle reset-prompt
	zle autosuggest-fetch
}
zle -N _zle_home_dir
zle -N _zle_updir

bindkey '\eOP' _zle_home_dir
bindkey '\e[2~' _zle_home_dir
bindkey '\ez' _zle_updir

# Alt + M toggles mouse
# bindkey "\em" zle-mouse-toggle # Alt + m to toggle mouse
# }}}

# print timestamp on the right of executed commands {{{
#timestamp-accept-line () {
	#if [[ ! $BUFFER =~ "^(\t| )*(#.*)?$" ]]; then
		#RPROMPT='%{'$fg[white]'%}[%*]%{'$reset_color'%}'
		#zle reset-prompt # FIXME this doesn't work the first time
		#RPROMPT=''
	#fi
	#zle .accept-line
#}
#zle -N accept-line timestamp-accept-line
#ZLE_RPROMPT_INDENT=-1

#}}}

# update prompt {{{
if [[ $USER -ne "root" ]]; then
	TRAPALRM() {
		if [ "$WIDGET" != "fzf-completion" ] && [ "$WIDGET" != "complete-word" ]; then
			last=$git_status
			if [ ! -z "$last" ]; then
				update_git
			fi
			if ([[ $EPOCHREALTIME-$_LAST_SUDO_TIME -lt $SUDO_TIMEOUT+$TMOUT ]] &&
				[[ $EPOCHREALTIME-$_LAST_SUDO_TIME -gt $SUDO_TIMEOUT ]]) ||
				[ "$last" != "$git_status" ]; then
					zle .reset-prompt
			fi
		fi
	}

	TMOUT=10 # update every 10 seconds
fi
# }}}

# apparently C-R only works if this is way down
source ~/.fzf.zsh

# Ubuntu's command-not-found
if [[ -s '/etc/zsh_command_not_found' ]]; then
	source '/etc/zsh_command_not_found'
fi

# initiate THEFUCK
#eval $(thefuck --alias --enable-experimental-instant-mode)
fuck() {
	eval $(thefuck --alias);
	fuck;
}

# if we are a tty then we should use fbterm
if [ "$TERM" = "linux" ]; then
	[ -n $FBTERM ] && export TERM=fbterm
fi

# man page highlighting https://unix.stackexchange.com/questions/169952/man-page-highlight-color#169955
#man() {
    #env LESS_TERMCAP_mb=$'\E[01;31m' \
    #LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    #LESS_TERMCAP_me=$'\E[0m' \
    #LESS_TERMCAP_se=$'\E[0m' \
    #LESS_TERMCAP_so=$'\E[38;5;246m' \
    #LESS_TERMCAP_ue=$'\E[0m' \
    #LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    #man "$@"
#}

function man() {
	env \
		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
		LESS_TERMCAP_me=$(tput sgr0) \
		LESS_TERMCAP_mb=$(tput blink) \
		LESS_TERMCAP_us=$(tput setaf 2) \
		LESS_TERMCAP_ue=$(tput sgr0) \
		LESS_TERMCAP_so=$(tput smso) \
		LESS_TERMCAP_se=$(tput rmso) \
		PAGER="${commands[less]:-$PAGER}" \
		man "$@"
}

# !! keep zsh-syntax-highlighting at end of .zshrc !!

# for profiling zsh startup
if [[ "$PROFILE_STARTUP" == true ]]; then
	unsetopt XTRACE
	exec 2>&3 3>&-
	echo ">>> ZSH >>>"
fi

# https://superuser.com/questions/836636/how-to-show-a-caret-c-in-canceled-command-line-in-zsh-like-bash-does
# TRAPINT() {
# 	zle && {
# 		zle autosuggest-clear
# 		print -n "$fg[red]^C$reset_prompt"
# 		return $(( 128 + $1  ))
# 	}
# }
# unfortunately powerlevel10k completely overrides the ability to define trap functions
local _trap_code='zle autosuggest-clear; print -n "$bg[white]$fg[black]^C$reset_prompt"'

local _p9k_trap_source=$(which _p9k_trapint)
local _mod_trap_source=$(echo $_p9k_trap_source | sed 's/^\(\s*\)zle && \(.*\)/\1zle \&\& {\n\1    \2\n\1    '$_trap_code'\n\1}/')
eval $_mod_trap_source


# del-prompt-accept-line() {
#     OLD_PROMPT="$PROMPT"
#     PROMPT='%{'$fg_bold[white]'%}⟩ '
#     zle reset-prompt
#     PROMPT="$OLD_PROMPT"
#     zle accept-line
# }

# zle -N del-prompt-accept-line
# bindkey "^M" del-prompt-accept-line

# This speeds up pasting w/ autosuggest {{{
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
# pasteinit() {
#     OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
#     zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
# }

# pastefinish() {
#     zle -N self-insert $OLD_SELF_INSERT
# }
# zstyle :bracketed-paste-magic paste-init pasteinit
# zstyle :bracketed-paste-magic paste-finish pastefinish

# this one looks simpler and the above might negatively affect performance
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

#}}}


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# For dotfiles management (see https://www.atlassian.com/git/tutorials/dotfiles)
# (except there it's called 'config' instead of 'dotfiles')
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Created by `pipx` on 2023-05-01 03:45:52
export PATH="$PATH:$HOME/.local/bin"

if [[ "$PROFILE_STARTUP" == true ]]; then
	zprof
fi
