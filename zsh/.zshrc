# fzf history prompt before anything else loads
_fzf_startup() {
  local output key selected query
  output=$(tac ~/.zsh_history | sed 's/^: [0-9]*:[0-9]*;//' | awk '!seen[$0]++' | fzf --print-query --expect=alt-enter --height=40% --reverse --tac +s)
  query=$(echo "$output" | sed -n '1p')
  key=$(echo "$output" | sed -n '2p')
  selected=$(echo "$output" | sed -n '3p')
  if [[ "$key" == "alt-enter" && -n "$selected" ]]; then
    _fzf_cmd="$selected"
  elif [[ -n "$query" ]]; then
    _fzf_cmd="$query"
  fi
}
# _fzf_startup

fpath=( ~/.zsh.d $fpath )
autoload -Uz compinit
compinit

source ~/.profile
source ~/.zsh.d/settings.zsh
source ~/.zsh.d/plugins.zsh
source ~/.zsh.d/keys.zsh
source ~/.zsh.d/aliases.zsh
source ~/.zsh.d/functions.zsh

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

# bun
export BUN_INSTALL="$HOME/.local/share/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/home/kayon/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/kayon/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

export GOROOT=/home/kayon/.go
export GOPATH=/home/kayon/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# GoLang
export GOROOT=/home/kayon/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/kayon/go
export PATH=$GOPATH/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
