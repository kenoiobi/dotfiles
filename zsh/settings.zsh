source ~/git/dotfiles/zsh/my-theme.zsh-theme 

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt appendhistory
unsetopt autocd
zstyle ':completion:*' menu select
