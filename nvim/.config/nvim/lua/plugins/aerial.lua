return {
    "stevearc/aerial.nvim",
    opts = {},
    config = function(_, opts)
        require("aerial").setup(vim.tbl_extend("force", opts, {
            on_attach = function(bufnr)
                vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr, desc = "Previous symbol" })
                vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr, desc = "Next symbol" })
            end,
        }))
        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "Toggle outline (aerial)" })
    end,
}
