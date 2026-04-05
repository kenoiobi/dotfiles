local map = vim.keymap.set

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>f", "<cmd>NvimTreeFindFile<cr>", { desc = "Find file in explorer" })

map("n", "<C-PageDown>", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<C-PageUp>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

map("n", "<C-x>", function()
    local char = vim.fn.getcharstr()
    local actions = {
        o = function() vim.cmd("wincmd w") end,
        ["1"] = function() vim.cmd("only") end,
        ["2"] = function() vim.cmd("split") end,
        ["3"] = function() vim.cmd("vsplit") end,
    }
    local action = actions[char]
    if action then
        action()
    else
        vim.notify("C-x " .. char .. " is not mapped", vim.log.levels.WARN)
    end
end, { desc = "C-x prefix (emacs-style)" })

map("i", "<C-f>", "<Right>", { desc = "Forward char" })
map("i", "<C-b>", "<Left>", { desc = "Backward char" })
map("i", "<C-p>", "<Up>", { desc = "Previous line" })
map("i", "<C-n>", "<Down>", { desc = "Next line" })

map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<Tab>", "za", { desc = "Toggle fold" })
map("n", "<S-Tab>", "zo", { desc = "Open fold" })

map("n", "<C-;>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<C-;>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<leader>;", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<leader>;", "gc", { remap = true, desc = "Toggle comment" })

