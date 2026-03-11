-- Markdown: folding (Tab hide/show) and checkbox toggle (Enter)
-- Loaded at startup; sets FileType autocmds so keymaps and fold work in every markdown buffer.

local function markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
  local hashes = line:match("^(#+)")
  if hashes then
    return ">" .. #hashes
  end
  return "="
end

_G.Markdown_foldexpr = markdown_foldexpr

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  pattern = "markdown",
  callback = function(ev)
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.Markdown_foldexpr()"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    local buf = ev.buf

    vim.keymap.set("n", "<Tab>", "za", { buffer = buf, desc = "Toggle fold" })
    vim.keymap.set("n", "<S-Tab>", "za", { buffer = buf, desc = "Toggle fold" })

    vim.keymap.set("n", "<CR>", function()
      local line = vim.api.nvim_get_current_line()

      local function toggle_first(pat, replacement)
        local start = line:find(pat)
        if start then
          local new_line = line:sub(1, start - 1) .. replacement .. line:sub(start + 3)
          vim.api.nvim_set_current_line(new_line)
          return true
        end
        return false
      end

      if toggle_first("%[ %]", "[x]") then return end
      if toggle_first("%[x%]", "[ ]") then return end
      if toggle_first("%[X%]", "[ ]") then return end
      vim.cmd("normal! j")
    end, { buffer = buf, desc = "Toggle checkbox or next line" })
  end,
})
