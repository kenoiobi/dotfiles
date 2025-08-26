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
alias drive="~/Downloads/drive"

alias emacs="emacsclient -t"
alias em="emacsclient -t"

alias token="command nvim ~/drive/passwords/.token"

alias startcam="sudo modprobe uvcvideo"
alias stopcam="sudo modprobe -r uvcvideo"

alias ne="nvim ~/dotfiles/nixos/configuration.nix"
alias nu="sudo nixos-rebuild switch"
alias dup="~/dotfiles/deb/apt.sh"

alias ff="find -type f | fzf | xargs nvim"

# alias nvim="/home/kayon/Downloads/nvim-linux-x86_64/bin/nvim"
