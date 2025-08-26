" exit terminal mode with escape
tnoremap <Esc> <C-\><C-n>

" show trailing white space
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

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

map J 5j
map K 5k

" Leader bindings
map <leader>, :bp<CR>
map <leader>. :bn<CR>
map <leader>t :ter<CR>
map <leader>e :Ex<CR>

" plugin keybindings
" Telescope
map <leader>a :Telescope buffers<CR>

" Neotree
map <leader>sf :Neotree right<CR>

" Neogit
map <leader>gg :Neogit kind=replace<CR>

" bookmarks
map <leader><CR> :Telescope bookmarks list<CR>

" find files
map <leader><leader> :Telescope find_files<CR>
map <leader>f :Telescope live_grep<CR>

" Debugger
map <leader>d :DapContinue<CR>
map <leader>b :DapToggleBreakpoint<CR>

" Persistent undo
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

