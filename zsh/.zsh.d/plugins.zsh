# Antidote for managing files
source ~/dotfiles/zsh/antidote/antidote.zsh
antidote load ~/git/dotfiles/zsh/.zsh_plugins.txt

bindkey "^R" history-incremental-search-backward # backup history when o fzf in system
source <(fzf --zsh)
