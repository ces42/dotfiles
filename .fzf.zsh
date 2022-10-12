# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ca/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/ca/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ca/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/ca/.fzf/shell/key-bindings.zsh"
