source ~/programming/legitimuz/kycbot/imgs/functions.sh

cd() {
    z $1 && ls
}

legi() {
    tmux split
    tmux split
    tmux select-layout even-vertical
}

zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | xclip -sel c
	zvm_exit_visual_mode
}

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function pyinit(){
    python3 -m venv venv
    echo "source venv/bin/activate" > .envrc
    direnv allow
    cd ..
    cd -
    pip list
}
