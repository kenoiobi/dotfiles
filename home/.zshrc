export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="neo"
HYPHEN_INSENSITIVE="true"

plugins=(
	git
	# sudo
	web-search
	# dirhistory
	history
	jsontools
	zsh-autosuggestions
	zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | xclip -sel c
	zvm_exit_visual_mode
}

KEYTIMEOUT=1


alias zup="source ~/.zshrc"
alias legi="cd ~/programming/legitimuz/kycbot/imgs && source ~/programming/legitimuz/kycbot/imgs/functions.sh"
alias clip="xclip -sel copy"
alias cpdir="pwd | clip"

fd() {
  local dir
  dir=$(find . -type d | fzf) && cd "$dir"
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

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
