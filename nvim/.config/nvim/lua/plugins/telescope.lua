return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader><leader>",
            function()
                local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
                if not root or vim.v.shell_error ~= 0 then
                    root = vim.fn.getcwd()
                end
                require("telescope.builtin").find_files({
                    cwd = root,
                    attach_mappings = function(_, map)
                        local actions = require("telescope.actions")
                        map("i", "<CR>", actions.file_tab)
                        map("n", "<CR>", actions.file_tab)
                        return true
                    end,
                })
            end,
            desc = "Find files (project root)",
        },
    },
    config = function()
        require("telescope").setup({})
    end,
}
