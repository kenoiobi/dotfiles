# Antidote for managing files
source ~/.zsh.d/antidote/antidote.zsh
antidote load ~/.zsh.d/.zsh_plugins.txt

bindkey "^R" history-incremental-search-backward # backup history when o fzf in system
# source <(fzf --zsh)
