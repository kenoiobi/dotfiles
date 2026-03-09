return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local function on_attach(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.del("n", "<CR>", { buffer = bufnr })
            vim.keymap.set("n", "<CR>", api.node.open.tab, opts("Open in new tab"))
            vim.keymap.set("n", "<2-LeftMouse>", api.node.open.tab, opts("Open in new tab"))
            vim.keymap.set("n", "s", api.node.open.edit, opts("Open in current window"))
            vim.keymap.set("n", "<C-x>", function()
                local char = vim.fn.getcharstr()
                if char == "o" then
                    vim.cmd("wincmd w")
                end
            end, opts("C-x prefix"))
        end

        require("nvim-tree").setup({
            on_attach = on_attach,
            view = {
                width = 35,
                side = "right",
            },
            tab = {
                sync = {
                    open = true,
                    close = true,
                },
            },
            renderer = {
                indent_markers = { enable = true },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "▸",
                            arrow_open = "▾",
                        },
                    },
                },
            },
            filters = {
                dotfiles = false,
                custom = { "^.git$" },
            },
            git = {
                enable = true,
                ignore = false,
            },
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                require("nvim-tree.api").tree.open()
                vim.cmd("wincmd p")
            end,
        })
    end,
}
