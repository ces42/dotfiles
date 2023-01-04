# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ca/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ca/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ca/.fzf/shell/completion.zsh" 2> /dev/null

FZF_CTRL_T_COMMAND='fd --strip-cwd-prefix -L --no-ignore-vcs -t f -E "{*.aux,*.bbl,*.blg,*.fls,*.toc,*.out,*.fdb_latexmk,*.synctex.gz}"'
FZF_ALT_C_COMMAND='fd --strip-cwd-prefix -L --no-ignore-vcs -t d'

FZF_CTRL_T_OPTS='--reverse --tiebreak=length --preview "ls -lah --color=always {} && { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ application/pdf ]] && pdftotext -l 10 {} - | head -500 } || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ image ]] && tiv {} -w 77 -h 300 2> /dev/null} || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ binary ]] && echo binary file } || { [[ {} == *.ipynb ]] && jut --force-colors {} | head -500 } || { (bat --style=numbers --color=always {}) 2> /dev/null | head -500 }" --bind "ctrl-y:execute-silent(echo -n {} | xclip -i)" --bind "f2:toggle-preview,ctrl-h:backward-kill-word,ctrl-t:accept" --bind "alt-d:change-prompt(D> )+reload(fd --strip-cwd-prefix -L --type d $IGNORES)" --bind "alt-f:change-prompt(F> )+reload(fd --strip-cwd-prefix -L --type f $IGNORES)" --preview-window "right:50%:hidden"'

FZF_ALT_C_OPTS='--reverse --tiebreak=length --preview "ls -lah --color=always {}" --bind "ctrl-y:execute-silent(echo -n {} | xclip -i)" --bind "f2:toggle-preview,ctrl-h:backward-kill-word,ctrl-t:accept" --preview-window "right:50%:hidden"'


# Key bindings
# ------------
source "/home/ca/.fzf/shell/key-bindings.zsh"
