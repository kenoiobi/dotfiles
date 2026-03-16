return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = true, -- color line numbers by change type (add/change/delete)
        linehl = false,
        word_diff = false,
        watch_gitdir = { follow_files = true },
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author> · <author_time:%R> · <summary>",
        sign_priority = 6,
        update_debounce = 100,
        max_file_length = 40000,
        preview_config = {
            border = "rounded",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end

            -- Blame: current line (popup) and selection (blame buffer for range)
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, "Blame current line (popup)")
            map("v", "<leader>hb", "<cmd>Gitsigns blame<cr>", "Blame (open blame view)")

            -- Hunk navigation
            map("n", "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                gs.nav_hunk("next")
            end, "Next hunk")
            map("n", "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                gs.nav_hunk("prev")
            end, "Prev hunk")

            -- Hunk actions
            map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
            map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage selection")
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset selection")
            map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
        end,
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)
        -- Optional: subtle line number colors for changed lines (customize to your colorscheme)
        vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
        vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })
    end,
}
