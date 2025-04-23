export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussel"

DISABLE_UNTRACKED_FILES_DIRTY="true"
KEYTIMEOUT=1

plugins=(
	git
	web-search
	history
	jsontools
	zsh-autosuggestions
	zsh-vi-mode
	virtualenv
)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# functions
zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | xclip -sel c
	zvm_exit_visual_mode
}

cd() {
    z $1 && ls
}

fd() {
  local dir
  dir=$(find . -type d | fzf --reverse) && cd "$dir"
}

ff(){
    local file
    file=$(find . -type f | fzf --reverse) && nvim "$file"
}

lf() {
    cd "$(command lf -print-last-dir "$@")"
}

mc() {
    cmd='lf -config <(cat ~/.config/lf/lfrc; printf "set %s\n" nopreview "ratios 1" "info size:time")'
    tmux split -h "$cmd"; eval "$cmd"
}

unsetopt autocd

unalias 1
unalias 2
unalias 3
unalias 4
unalias 5
unalias 6
unalias 7
unalias 8
unalias 9

alias zup="source ~/.zshrc"
alias legi="cd ~/programming/legitimuz/kycbot/imgs && source ~/programming/legitimuz/kycbot/imgs/functions.sh"
alias clip="xclip -sel copy"
alias cpdir="pwd | clip"

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
