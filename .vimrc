set tabstop=4
set softtabstop=0
set noexpandtab
set shiftwidth=4

tnoremap <Esc> <C-\><C-n>
set number relativenumber
syntax on
map <C-Q> :q<cr>
map <C-x>2 :split<cr>
map <C-x>3 :vsplit<cr>
map <C-x>o <C-w>w
map <C-x> <C-w>
map <C-x>h ggVG
let mapleader = " "
map <leader>e :Ex<CR>
map <leader>t :tab ter<CR>
map <leader><CR> :e ~/.bookmark<CR>
set clipboard=unnamedplus
set autochdir
