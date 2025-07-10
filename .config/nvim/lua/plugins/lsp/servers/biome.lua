-- https://biomejs.dev/internals/language-support/
local supported = {
	"astro",
	"css",
	"graphql",
	-- "html",
	"javascript",
	"javascriptreact",
	"json",
	"jsonc",
	-- "markdown",
	"svelte",
	"typescript",
	"typescriptreact",
	"vue",
	-- "yaml",
}

return {

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				biome = {
					mason = false,
					cmd = { Util.root() .. "/node_modules/.bin/biome", "lsp-proxy" },
					root_dir = function(bufnr, on_dir)
						local util = require("lspconfig.util")
						local fname = vim.api.nvim_buf_get_name(bufnr)
						local root_files = { "biome.json", "biome.jsonc" }
						root_files = util.insert_package_json(root_files, "biome", fname)
						local root_dir = vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
						if root_dir then
							on_dir(root_dir)
						end
					end,
				},
			},
		},
	},

	{
		"stevearc/conform.nvim",
		optional = true,
		---@param opts ConformOpts
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			for _, ft in ipairs(supported) do
				opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
				table.insert(opts.formatters_by_ft[ft], "biome")
			end

			opts.formatters = opts.formatters or {}
			opts.formatters.biome = {
				require_cwd = true,
			}
		end,
	},

	-- none-ls support
	{
		"nvimtools/none-ls.nvim",
		optional = true,
		opts = function(_, opts)
			local nls = require("null-ls")
			opts.sources = opts.sources or {}
			table.insert(opts.sources, nls.builtins.formatting.biome)
		end,
	},
}
