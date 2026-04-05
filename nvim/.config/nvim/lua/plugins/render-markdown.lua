return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "quarto" },
  opts = {
    file_types = { "markdown", "quarto" },
    render_modes = { "n", "c", "t" },
    anti_conceal = {
      enabled = true,
      disabled_modes = false,
      above = 0,
      below = 0,
    },
  },
}
