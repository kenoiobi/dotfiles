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
