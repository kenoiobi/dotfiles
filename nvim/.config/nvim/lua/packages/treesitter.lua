-- The big boy of IDE's is LSP, but tree sitter is a nice plus
-- mostly used for complex highlighting and, in my case, autotag
return {
	"nvim-treesitter/nvim-treesitter",
	config = function ()
		require'nvim-treesitter.configs'.setup {
			ensure_installed = {"lua", "python", "javascript"},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			}
		}
	end,
}
