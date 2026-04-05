return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  keys = {
    {
      "<leader>mp",
      function()
        local ok, err = pcall(vim.cmd, "MarkdownPreviewToggle")
        if not ok then
          vim.notify("Markdown preview: " .. tostring(err), vim.log.levels.ERROR)
        end
      end,
      desc = "Toggle markdown preview (browser)",
    },
  },
  build = "cd app && npx --yes yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_port = "8080"
    vim.g.mkdp_echo_preview_url = 1
  end,
}
