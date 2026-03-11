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

        -- Make :q and :bd behave as if tree was not visible (nvim-tree wiki recipe)
        vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
            nested = false,
            callback = function(e)
                local tree = require("nvim-tree.api").tree
                if not tree.is_visible() then
                    return
                end
                local win_count = 0
                for _, win_id in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_config(win_id).focusable then
                        win_count = win_count + 1
                    end
                end
                -- :q with only main + tree left → quit Neovim
                if e.event == "QuitPre" and win_count == 2 then
                    vim.api.nvim_cmd({ cmd = "qall" }, {})
                end
                -- :bd left only tree window → close tree, go to last buffer, re-open tree
                if e.event == "BufEnter" and win_count == 1 then
                    vim.defer_fn(function()
                        tree.toggle({ find_file = true, focus = true })
                        tree.toggle({ find_file = true, focus = false })
                    end, 10)
                end
            end,
        })
    end,
}
