export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

DISABLE_UNTRACKED_FILES_DIRTY="true"
KEYTIMEOUT=1

plugins=(
    # zsh-vi-mode
    fzf # added later for conflicting with zsh-vi-mode
    git
    web-search
    history
    jsontools
    zsh-autosuggestions
    virtualenv
    conda-env
)

# The plugin will auto execute this zvm_after_init function
# function zvm_after_init() {
# [ -f ~/.oh-my-zsh/plugins/fzf/fzf.plugin.zsh ] && source ~/.oh-my-zsh/plugins/fzf/fzf.plugin.zsh
# }

source $ZSH/oh-my-zsh.sh
# source ~/.path

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

source ~/drive/programming/legitimuz/kycbot/imgs/functions.sh
alias zup="source ~/.zshrc"
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

PATH=$PATH:/home/kayon/.cargo/bin
PATH=$PATH:/home/kayon/miniconda3/bin

export TERM="st-256color"

bindkey -v
bindkey '^V' fzf-file-widget

bindkey -M viins '^F' vi-forward-char
bindkey -M viins '^B' vi-backward-char
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey '^G' fzf-dir

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kayon/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kayon/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kayon/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kayon/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# GoLang
export GOROOT=/home/kayon/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/kayon/go
export PATH=$GOPATH/bin:$PATH
