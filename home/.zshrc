# allowing completion to be selected with arrow keys 
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
zstyle ':completion:*' menu select

# my theme
source ~/git/dotfiles/robbyrussell.zsh-theme

# external plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# aliases
source ~/drive/programming/legitimuz/kycbot/imgs/functions.sh
alias zup="source ~/.zshrc"
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias clip="xclip -sel copy"
alias cpdir="pwd | clip"
alias euporie="euporie-notebook --external_editor='tmux display-popup -x {left} -y {bottom} -w {width} -h {height} -B -E nvim'"
alias rm="trash-put"
alias poweroff="sudo poweroff"
alias py="python3"

alias emacs="emacsclient -t"
alias em="emacsclient -t"

alias token="command nvim ~/.token"

alias startcam="sudo modprobe uvcvideo"
alias stopcam="sudo modprobe -r uvcvideo"


# functions
cd() {
    z $1 && ls
}

legi() {
    tmux split
    tmux split
    tmux select-layout even-vertical
}

# keys

bindkey -v
bindkey -M viins '^F' vi-forward-char
bindkey -M viins '^B' vi-backward-char
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
bindkey "^R" history-incremental-search-backward 
export ZSH_SYSTEM_CLIPBOARD_METHOD="xcc"
source ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh	

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
