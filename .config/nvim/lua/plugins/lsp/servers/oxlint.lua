return {
	{
		"neovim/nvim-lspconfig",
		-- other settings removed for brevity
		opts = {
			---@type lspconfig.options
			servers = {
				oxlint = {
					root_dir = Util.lsp.root_if_config({
						".oxlintrc.json",
					}),
				},
			},
		},
	},
}
