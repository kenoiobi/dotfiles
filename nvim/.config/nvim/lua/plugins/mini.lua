return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        -- Better around/inside textobjects: va), ci", di(, etc.
        -- Adds targets like function args (a), brackets (b), quotes (q), tags (t)
        require("mini.ai").setup()

        -- Add/delete/replace surroundings: gsa, gsd, gsr
        -- e.g. gsaiw" to surround word with quotes, gsd" to delete quotes
        require("mini.surround").setup({
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",
            },
        })

        -- Auto-close brackets and quotes
        require("mini.pairs").setup()

        -- gcc to toggle line comment, gc in visual mode
        require("mini.comment").setup()

        -- Minimal statusline
        require("mini.statusline").setup()

        -- Highlight word under cursor
        require("mini.cursorword").setup()

        -- Animated indent scope guide
        require("mini.indentscope").setup({
            symbol = "│",
            draw = { delay = 50 },
        })

        -- Move selections and lines with Alt+h/j/k/l
        require("mini.move").setup()

        -- Highlight trailing whitespace
        require("mini.trailspace").setup()

        -- Fuzzy picker (used for snippet picker, etc.)
        require("mini.pick").setup()
    end,
}
