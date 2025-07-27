" exit terminal mode with escape
tnoremap <Esc> <C-\><C-n>

" some emacs bindings
map <C-x>1 :only<cr>
map <C-x>2 :split<cr>
map <C-x>3 :vsplit<cr>
map <C-x>o <C-w>w
map <C-x> <C-w>
map <C-x>h ggVG
map <C-x>t :tabe<cr>
map <C-x>k :bd!<cr>

" folding
map <Tab> za

" Leader bindings
map <leader>, :bp<CR>
map <leader>. :bn<CR>
map <leader>t :ter<CR>

" plugin keybindings
" Telescope
map <leader>a :Telescope buffers<CR>

" Neotree
map <leader>sf :Neotree right<CR>

" Neogit
map <leader>gg :Neogit kind=replace<CR>

" bookmarks
map <leader><CR> :Telescope bookmarks list<CR>
