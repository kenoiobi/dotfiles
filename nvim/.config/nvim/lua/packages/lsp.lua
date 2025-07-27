-- there are some parts to neovim lsp
-- first, it has a built in package, but nvim-lspconfig makes it trivial to use
-- second, we need a way to download and install lsps, mason does that
-- BUT, there is no total integration between mason and lspconfig itself, lspconfig cant ask for an lsp and etc

-- that's where this plugin comes in, it requires both and allows integration between both
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"pyright",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		{ "ms-jpq/coq_nvim", branch = "coq" },
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		{ 'ms-jpq/coq.thirdparty', branch = "3p" },
	},
	init = function()
		vim.g.coq_settings = {
			auto_start = "shut-up", -- if you want to start COQ at startup
			-- Your COQ settings here
		}
	end,
}

-- also, check linting.lua, it has the config to show errors inline
