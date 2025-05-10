export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="my"

DISABLE_UNTRACKED_FILES_DIRTY="true"
KEYTIMEOUT=1

plugins=(
	zsh-vi-mode
	# fzf # added later for conflicting with zsh-vi-mode
	git
	web-search
	history
	jsontools
	zsh-autosuggestions
	virtualenv
)

# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
  [ -f ~/.oh-my-zsh/plugins/fzf/fzf.plugin.zsh ] && source ~/.oh-my-zsh/plugins/fzf/fzf.plugin.zsh
}

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

legi() {
    tmux split
    tmux split
    tmux select-layout even-vertical
}

fg() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
	--bind "start:reload:$RG_PREFIX {q}" \
	--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
	--delimiter : \
	--preview 'bat --color=always {1} --highlight-line {2}' \
	# --preview 'cat' \
	--bind 'enter:become(nvim {1} +{2})'
}

fzf-dir(){
    find ~/ -type d | fzf
}
zle -N fzf-dir



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

source ~/programming/legitimuz/kycbot/imgs/functions.sh
alias zup="source ~/.zshrc"
alias clip="xclip -sel copy"
alias cpdir="pwd | clip"
alias vim="nvim"
alias euporie="euporie-notebook --external_editor='tmux display-popup -x {left} -y {bottom} -w {width} -h {height} -B -E nvim'"

bindkey '^F' fzf-file-widget
bindkey '^G' fzf-dir

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
