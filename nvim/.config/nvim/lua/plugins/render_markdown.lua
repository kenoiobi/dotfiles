---@return string
function _markdown_foldexpr()
    local lnum = vim.v.lnum
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""

    -- ATX heading: # to ###### → fold level 1–6
    local hashes = line:match("^(#+)%s")
    if hashes then
        return ">" .. math.min(#hashes, 6)
    end

    -- Fenced code block: ``` starts (a1) or ends (s1) a fold
    if line:match("^```") then
        local count = 0
        for i = 1, lnum - 1 do
            local l = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1] or ""
            if l:match("^```") then
                count = count + 1
            end
        end
        return (count % 2 == 0) and "a1" or "s1"
    end

    return "="
end

local function toggle_checkbox()
    local line = vim.api.nvim_get_current_line()
    if line:match("%[ %]") then
        vim.api.nvim_set_current_line((line:gsub("%[ %]", "[x]", 1)))
    elseif line:match("%[x%]") or line:match("%[X%]") then
        vim.api.nvim_set_current_line((line:gsub("%[x%]", "[ ]", 1):gsub("%[X%]", "[ ]", 1)))
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Cr>", true, false, true), "n", false)
    end
end

return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
    config = function(_, opts)
        require("render-markdown").setup(opts)

        -- Folding by headings (chapters/sections) and fenced code blocks.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = function(args)
                local bufnr = args.buf
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "v:lua._markdown_foldexpr()"
                vim.wo.foldenable = true
                vim.wo.foldlevel = 99  -- start with all folds open
                vim.keymap.set("n", "<CR>", toggle_checkbox, { buffer = bufnr, desc = "Toggle checkbox or new line" })
            end,
        })
    end,
}
