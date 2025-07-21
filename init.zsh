source ~/git/dotfiles/zsh/settings.zsh
source ~/git/dotfiles/zsh/plugins.zsh
source ~/git/dotfiles/zsh/keys.zsh
source ~/git/dotfiles/zsh/aliases.zsh
source ~/git/dotfiles/zsh/functions.zsh

# path
PATH=$PATH:/home/kayon/.cargo/bin

# GoLang
export GOROOT=/home/kayon/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/kayon/go
export PATH=$GOPATH/bin:$PATH

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# hooks (zoxide, direnv)
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# bun completions
[ -s "/home/kayon/.bun/_bun" ] && source "/home/kayon/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
