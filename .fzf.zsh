# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

export FZF_DEFAULT_COMMAND='fd -L --type f'
export FZF_CTRL_T_COMMAND='fd -L --type f --no-ignore-vcs'
export FZF_ALT_C_COMMAND='fd -L --type d --no-ignore-vcs'
export FZF_ALT_D_COMMAND='fd -L --type d --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--multi --reverse --bind "ctrl-y:execute-silent(echo -n {} | xclip -i),f2:toggle-preview,ctrl-h:backward-kill-word,alt-d:+reload(fd -L --type d --no-ignore-vcs),alt-f:+reload(fd -L --type f --no-ignore-vcs)" --preview-window "right:50%:hidden" --preview "[ -d {} ] && ls -alh --color=always {} || [[ $(file --mime {}) =~ application/pdf ]] && pdftotext -l 10 {} - | head -500 || [[ $(file --mime {}) =~ binary ]] && echo binary file, $(du -kh {} | cut -f1)B || (bat --style=numbers --color=always {}) 2> /dev/null | head -500"'
# --preview "[ -d {} ] && echo {} is a directory || ([[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500)" 

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.zsh"
