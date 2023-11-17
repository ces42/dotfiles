# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ca/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ca/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ca/.fzf/shell/completion.zsh" 2> /dev/null

FZF_CTRL_T_COMMAND='fd --no-ignore-parent --strip-cwd-prefix -L --no-ignore-vcs -t f -E "{*.aux,*.bbl,*.blg,*.fls,*.toc,*.out,*.fdb_latexmk,*.synctex.gz}"'
FZF_ALT_C_COMMAND='fd --no-ignore-parent --strip-cwd-prefix -L --no-ignore-vcs -t d'

FZF_CTRL_T_OPTS='--reverse --tiebreak=length --scheme=path --info inline'\
' --preview "exa -la --color=always {} && { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ application/pdf ]] && pdftotext -l 10 {} - | head -500 } || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ image ]] && tiv {} -w 77 -h 300 2> /dev/null} || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ binary ]] && echo binary file } || { [[ {} == *.ipynb ]] && jut --force-colors {} | head -500 } || { (bat --style=numbers --color=always {}) 2> /dev/null | head -500 }"'\
' --bind "ctrl-y:execute-silent(echo -n {} | xclip -i)"'\
' --bind "f3:toggle-preview,ctrl-h:backward-kill-word,ctrl-t:accept"'\
' --bind "alt-d:change-prompt(D> )+reload('${(q)FZF_ALT_C_COMMAND}')"'\
' --bind "alt-f:change-prompt(F> )+reload('${(q)FZF_CTRL_T_COMMAND}')"'\
' --bind "f5:reload('${(q)FZF_CTRL_T_COMMAND}')"'\
' --preview-window "right:50%:hidden"'\
' --bind '"'"'f2:execute(tmp=$(mktemp); echo {} | vi -c "let g:pager_mode = 1 | set nonu nornu | map q :qa!<CR> |write! $tmp" >&9; mv -nT {} "$(cat $tmp)")'"'"\

FZF_ALT_C_OPTS='--reverse --tiebreak=length --scheme=path --info inline'\
' --preview "ls -lah --color=always {}" --bind "ctrl-y:execute-silent(echo -n {} | xclip -i)"'\
' --bind "f2:toggle-preview,ctrl-h:backward-kill-word,ctrl-t:accept" --preview-window "right:50%:hidden"'

FZF_CTRL_R_BASE="fc -rl 1 | awk '{ cmd=\$0; sub(/^[ \\t]*[0-9]+\\**[ \\t]+/, \"\", cmd); if (!seen[cmd]++) print %s }'"
printf -v FZF_CTRL_R_COMMAND $FZF_CTRL_R_BASE 'cmd'
printf -v FZF_CTRL_R_NUM $FZF_CTRL_R_BASE '$0'
printf -v FZF_CTRL_R_NUMDATE $FZF_CTRL_R_BASE '$0'

FZF_CTRL_R_OPTS='--reverse --info inline '\
' --bind "ctrl-y:execute-silent(echo -n {} | sed -E \"s/^[[:digit:]]+ +//\" | xclip -i)"'\
' --bind "ctrl-h:backward-kill-word"'
# ' --bind "alt-d:reload(\"'${(q)FZF_CTRL_R_NUM}'\")"'
# ' --preview "ls -lah --color=always {} && { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ application/pdf ]] && pdftotext -l 10 {} - | head -500 } || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ image ]] && tiv {} -w 77 -h 300 2> /dev/null} || { [[ $(file --mime {} | awk -F\";\" \"{print $1}\") =~ binary ]] && echo binary file } || { [[ {} == *.ipynb ]] && jut --force-colors {} | head -500 } || { (bat --style=numbers --color=always {}) 2> /dev/null | head -500 }"'\
# ' --preview-window "right:50%:hidden"'


# Key bindings
# ------------
source "/home/ca/.fzf/shell/key-bindings.zsh"
