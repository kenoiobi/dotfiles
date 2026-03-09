local agent

local function get_agent()
    if not agent then
        local Terminal = require("toggleterm.terminal").Terminal
        agent = Terminal:new({
            cmd = "cursor-agent --workspace " .. vim.fn.shellescape(vim.fn.getcwd()),
            direction = "float",
            hidden = true,
            float_opts = {
                border = "rounded",
                width = math.floor(vim.o.columns * 0.85),
                height = math.floor(vim.o.lines * 0.85),
            },
            on_open = function(term)
                vim.keymap.set("t", "<Esc>", function()
                    term:toggle()
                end, { buffer = term.bufnr })
            end,
            on_exit = function()
                agent = nil
            end,
        })
    end
    return agent
end

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {},
    config = function(_, opts)
        require("toggleterm").setup(opts)
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                local a = get_agent()
                a:spawn()
            end,
        })
        vim.keymap.set("n", "<leader>a", function()
            get_agent():toggle()
        end, { desc = "Cursor Agent" })
    end,
}
