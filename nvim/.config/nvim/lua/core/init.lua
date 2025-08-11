-- start by setting some basic stuff
vim.cmd("colorscheme habamax")
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.opt.number = true

-- tab size
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- call keybinding file
vim.cmd("source ~/.config/nvim/lua/core/keys.vim") -- i use vim script for keybindings cuz its 100x easier
require("core.folds")
