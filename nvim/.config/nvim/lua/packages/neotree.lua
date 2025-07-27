return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	},
	lazy = false, -- neo-tree will lazily load itself
	mappings = {
		["h"] = "focus_preview",
	},
	init = function()
		require('neo-tree').setup({
			hijack_netrw_behavior = "open_default",
			window = {
				position = "right",
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			}
		})
	end,
}
