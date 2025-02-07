set tabstop=4
set softtabstop=0
set noexpandtab
set shiftwidth=4
colorscheme default

tnoremap <Esc> <C-\><C-n>
set number relativenumber
syntax on
map <C-Q> :q<cr>
map <C-x>2 :split<cr>
map <C-x>3 :vsplit<cr>
map <C-x>o <C-w>w
map <C-x> <C-w>
map <C-x>h ggVG
map <C-t> :tabe<CR>
let mapleader = " "
map <leader>e :e .<CR>
map <leader>r :so ~/.vimrc<CR>
map <leader>t :ter<CR>
map <leader><CR> :e ~/.bookmark<CR>
nmap <leader>; gcc
vmap <leader>; gc
map <leader>a :Telescope buffers<CR>
map <leader>p :Telescope projects<CR>
map <leader><leader> :Telescope find_files<CR>
map <leader>, :bp<CR>
map <leader>. :bn<CR>
set clipboard=unnamedplus
set autochdir

set showtabline=0
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ 
set statusline+=[%{tabpagenr()}/
set statusline+=%{tabpagenr('$')}]\ 
set statusline+=%P
