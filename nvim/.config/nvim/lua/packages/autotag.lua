-- Autotag is auto closing <div/> on react and html, depends on treesitter
return {
	"windwp/nvim-ts-autotag",
	config = function()
		require("nvim-ts-autotag").setup({
			auto_install = true,
		})
	end,
}
